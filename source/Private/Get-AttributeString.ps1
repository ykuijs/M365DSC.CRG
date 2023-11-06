function Get-AttributeString
{
    <#
        .Synopsis
        Adds all the provided properties to the configuration data object.

        .Description
        This function loops through all the provided properties and adds them to the specified configuration data object.

        .Example
        Get-AttributeString -Property $property -ConfigData $currentDataObject

        .Parameter Property
        The Property parameter is a property from the MOF schema that needs to be added to the configuration data object.

        .Parameter ConfigData
        The ConfigData parameter is the configuration data object that needs to be updated with the provided property.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Property,

        [Parameter(Mandatory = $true)]
        [System.Object]
        $ConfigData
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

        # Property is an EmbeddedInstance, so we have to use that in generating the properties.
        $embeddedSchemas = $mofSchemas |
            Where-Object -FilterScript {
                    ($_.ClassName -eq $Property.EmbeddedInstance)
            }

        Write-Verbose "CurrentDepth: $($script:currentDepth)"

        if ($Property.IsArray)
        {
            $ConfigData.$($Property.Name) = @(@{})

            if ($embeddedSchemas.Attributes.Name -notcontains "Id" -and $embeddedSchemas.Attributes.Name -notcontains "Identity")
            {
                $ConfigData.$($property.Name)[0].UniqueId = ('{0} | {1} | {2}' -f "String", "Required", "[Unique ID to identify this specific object]")
            }

            foreach ($embeddedProperty in $embeddedSchemas.Attributes)
            {
                if ($null -eq $embeddedProperty.EmbeddedInstance)
                {
                    $state = 'Optional'
                    if ($embeddedProperty.State -in @('Key', 'Required'))
                    {
                        $state = 'Required'
                    }

                    if ($null -eq $embeddedProperty.ValueMap)
                    {
                        $ConfigData.$($property.Name)[0].$($embeddedProperty.Name) = ('{0} | {1}' -f $embeddedProperty.DataType, $state)
                    }
                    else
                    {
                        $ConfigData.$($property.Name)[0].$($embeddedProperty.Name) = ('{0} | {1} | {2}' -f $embeddedProperty.DataType, $state, ($embeddedProperty.ValueMap -join ' / '))
                    }
                }
                else
                {
                    Get-AttributeString -Property $embeddedProperty -ConfigData ($ConfigData.$($Property.Name)[0])
                }
            }
        }
        else
        {
            $ConfigData.$($property.Name) = @{}

            foreach ($embeddedProperty in $embeddedSchemas.Attributes)
            {
                if ($null -eq $embeddedProperty.EmbeddedInstance)
                {
                    $state = 'Optional'
                    if ($embeddedProperty.State -in @('Key', 'Required'))
                    {
                        $state = 'Required'
                    }

                    if ($null -eq $embeddedProperty.ValueMap)
                    {
                        $ConfigData.$($property.Name).$($embeddedProperty.Name) = ('{0} | {1}' -f $embeddedProperty.DataType, $state)
                    }
                    else
                    {
                        $ConfigData.$($property.Name).$($embeddedProperty.Name) = ('{0} | {1} | {2}' -f $embeddedProperty.DataType, $state, ($embeddedProperty.ValueMap -join ' / '))
                    }
                }
                else
                {
                    Get-AttributeString -Property $embeddedProperty -ConfigData ($ConfigData.$($Property.Name))
                }
            }
        }
        $script:currentDepth--
    }
}
