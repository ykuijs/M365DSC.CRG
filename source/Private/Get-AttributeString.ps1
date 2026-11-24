function Get-AttributeString
{
    <#
        .Synopsis
        Adds complex properties to the example configuration data.

        .Description
        Recursively expands normalized complex-type definitions into the example
        configuration data, preserving scalar and array property shapes.

        .Example
        Get-AttributeString -Property $property -Schemas $schemas -ConfigData $currentDataObject

        .Parameter Property
        Specifies the normalized complex property to expand.

        .Parameter Schemas
        Specifies the lookup containing all resource and complex-type definitions.

        .Parameter ConfigData
        Specifies the configuration data object to update.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.Object]
        $Property,

        [Parameter(Mandatory = $true)]
        [System.Collections.Hashtable]
        $Schemas,

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

        try
        {
            $embeddedSchema = $Schemas[$Property.EmbeddedInstance]
            if ($null -eq $embeddedSchema)
            {
                throw "Complex type '$($Property.EmbeddedInstance)' for property '$($Property.Name)' is not defined."
            }

            $dataObject = @{}
            if ($Property.IsArray)
            {
                $ConfigData[$Property.Name] = @($dataObject)
                if ($embeddedSchema.Attributes.Name -notcontains 'Id' -and
                    $embeddedSchema.Attributes.Name -notcontains 'Identity' -and
                    $embeddedSchema.Attributes.Name -notcontains 'SettingDefinitionId')
                {
                    $dataObject.UniqueId = 'String | Required | [Unique ID to identify this specific object]'
                }
            }
            else
            {
                $ConfigData[$Property.Name] = $dataObject
            }

            foreach ($embeddedProperty in $embeddedSchema.Attributes)
            {
                if ($null -ne $embeddedProperty.EmbeddedInstance -and $embeddedProperty.EmbeddedInstance -ne 'MSFT_Credential')
                {
                    Get-AttributeString -Property $embeddedProperty -Schemas $Schemas -ConfigData $dataObject
                    continue
                }

                $description = $embeddedProperty.Description -replace "`r`n"
                $state = 'Optional'
                if ($embeddedProperty.State -in @('Key', 'Required'))
                {
                    $state = 'Required'
                }

                $dataType = $embeddedProperty.DataType -replace 'Array$'
                if ($embeddedProperty.EmbeddedInstance -eq 'MSFT_Credential')
                {
                    $dataType = 'PSCredential'
                }

                $result = '{0} | {1} | {2}' -f $dataType, $state, $description
                if ($null -ne $embeddedProperty.ValueMap)
                {
                    $result += ' | {0}' -f ($embeddedProperty.ValueMap -join ' / ')
                }

                if ($embeddedProperty.IsArray)
                {
                    $dataObject[$embeddedProperty.Name] = @($result)
                }
                else
                {
                    $dataObject[$embeddedProperty.Name] = $result
                }
            }
        }
        finally
        {
            $script:currentDepth--
        }
    }
}
