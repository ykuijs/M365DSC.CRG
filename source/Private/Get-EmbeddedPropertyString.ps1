function Get-EmbeddedPropertyString
{
    <#
        .Synopsis
        Adds all the provided embedded properties to the composite resource code.

        .Description
        This function loops through all the provided properties and adds references to them to the generated composite resource.

        .Example
        $result = Get-EmbeddedPropertyString -Properties $embeddedSchema.Attributes -Indentation $Indentation -ParameterName "`$_"

        .Parameter Properties
        The Properties parameter are the properties from the MOF schema that needs to be added to the composite resource.

        .Parameter Indentation
        The Indentation parameter is number of indentations that should be used for the generated code.

        .Parameter ParameterName
        The ParameterName parameter is the name of the parameter that should be used for the generated code.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Properties,

        [Parameter(Mandatory = $true)]
        [System.Int32]
        $Indentation,

        [Parameter(Mandatory = $true)]
        [System.String]
        $ParameterName
    )

    process
    {
        $script:currentDepth++

        if ($script:currentDepth -gt $script:maxDepth)
        {
            Write-Verbose 'MaxDepth reached!'
            $script:currentDepth--
            return
        }

        $propertyString = [System.Text.StringBuilder]::new()

        $embeddedProperties = $Properties | Where-Object { $null -ne $_.EmbeddedInstance -and $_.EmbeddedInstance -ne 'MSFT_Credential' }

        if ($embeddedProperties.Count -ne 0)
        {
            Write-Verbose "CurrentDepth: $($script:currentDepth)"
            foreach ($Property in $embeddedProperties)
            {
                Write-Verbose "$($Property.Name) - $($Property.EmbeddedInstance)"
                $embeddedSchema = $mofSchemas |
                    Where-Object -FilterScript {
                            ($_.ClassName -eq $Property.EmbeddedInstance)
                    }

                if ($null -ne $embeddedSchema)
                {
                    $propertyName = $Property.Name
                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), "if ($ParameterName.ContainsKey('$propertyName'))"))
                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), '{'))
                    $Indentation++

                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), "$ParameterName.$propertyName = $ParameterName.$propertyName | ForEach-Object {"))
                    $Indentation++

                    $result = Get-EmbeddedPropertyString -Properties $embeddedSchema.Attributes -Indentation $Indentation -ParameterName "`$_"
                    if ([String]::IsNullOrEmpty($result) -eq $false)
                    {
                        [void]$propertyString.Append($result)
                    }

                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), "if (`$_.ContainsKey('UniqueId'))"))
                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), '{'))
                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), "    `$_.Remove('UniqueId')"))
                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), '}'))
                    [void]$propertyString.AppendLine('')

                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), "(Get-DscSplattedResource -ResourceName '$($Property.EmbeddedInstance)' -Properties `$_ -NoInvoke).Invoke(`$_)"))

                    $Indentation--
                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), '}'))

                    $Indentation--
                    [void]$propertyString.AppendLine(('{0}{1}' -f (Get-IndentationString -Indentation $Indentation), '}'))
                    [void]$propertyString.AppendLine('')
                }
                else
                {
                    Write-Warning -Message "Specified embedded instance '$($Property.EmbeddedInstance)' for property '$($Property.Name)' cannot be found!"
                    $script:errors += [PSCustomObject]@{
                        Type = 'Warning'
                        Message = "Specified embedded instance '$($Property.EmbeddedInstance)' for property '$($Property.Name)' cannot be found for resource '$shortResourceName'!"
                    }
                }
            }
        }

        $script:currentDepth--
        return $propertyString.ToString()
    }
}
