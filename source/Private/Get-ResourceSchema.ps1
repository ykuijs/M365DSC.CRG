function Get-ResourceSchema
{
    <#
        .Synopsis
        Reads and validates Microsoft365DSC resource metadata.

        .Description
        Normalizes SchemaDefinition.json into a case-insensitive lookup of resources
        and complex types. Exported resources are identified by the module manifest.

        .Parameter ModulePath
        Specifies the root directory of the selected Microsoft365DSC module.

        .Example
        Get-ResourceSchema -ModulePath 'C:\Modules\Microsoft365DSC\2.26.1007.1'
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $ModulePath
    )

    $schemaPath = Join-Path -Path $ModulePath -ChildPath 'SchemaDefinition.json'
    if (-not (Test-Path -LiteralPath $schemaPath -PathType Leaf))
    {
        throw "SchemaDefinition.json was not found in '$ModulePath'. Only JSON/class-based Microsoft365DSC releases are supported."
    }

    $manifestPath = Join-Path -Path $ModulePath -ChildPath 'Microsoft365DSC.psd1'
    $manifest = Import-PowerShellDataFile -LiteralPath $manifestPath -ErrorAction Stop
    $resourceNames = @($manifest.DscResourcesToExport)
    if ($resourceNames.Count -eq 0)
    {
        throw "No DSC resources are exported by '$manifestPath'."
    }

    try
    {
        $content = Get-Content -LiteralPath $schemaPath -Raw -ErrorAction Stop
        $definitions = $content | ConvertFrom-Json -ErrorAction Stop
    }
    catch
    {
        throw "Failed to read resource metadata from '$schemaPath': $_"
    }

    if ([System.String]::IsNullOrWhiteSpace($content) -or -not $content.TrimStart().StartsWith('[') -or $definitions.Count -eq 0)
    {
        throw "Resource metadata in '$schemaPath' must be a non-empty JSON array."
    }

    $schemas = @{}
    $primitiveTypes = @(
        'Boolean', 'Char16', 'DateTime', 'Real32', 'Real64', 'SInt8', 'SInt16',
        'SInt32', 'SInt64', 'String', 'UInt8', 'UInt16', 'UInt32', 'UInt64'
    )

    foreach ($definition in $definitions)
    {
        $className = $definition.ClassName
        if ($className -isnot [System.String] -or $className -notmatch '^MSFT_[a-zA-Z_][a-zA-Z0-9_]*$')
        {
            throw "Invalid class name in '$schemaPath': '$className'."
        }

        if ($schemas.ContainsKey($className))
        {
            throw "Duplicate class '$className' in '$schemaPath'."
        }

        if ($definition.Parameters -isnot [System.Array])
        {
            throw "Class '$className' must define a Parameters array."
        }

        $propertyNames = @{}
        $attributes = @(foreach ($property in $definition.Parameters)
        {
            if ($property.Name -isnot [System.String] -or $property.Name -notmatch '^[a-zA-Z_][a-zA-Z0-9_]*$')
            {
                throw "Invalid property name in class '$className'."
            }

            if ($propertyNames.ContainsKey($property.Name))
            {
                throw "Duplicate property '$($property.Name)' in class '$className'."
            }
            $propertyNames.Add($property.Name, $true)

            if ($property.Option -notin @('Key', 'Required', 'Write', 'Read'))
            {
                throw "Unsupported option '$($property.Option)' for '$className.$($property.Name)'."
            }

            if ($property.CIMType -isnot [System.String])
            {
                throw "Missing CIMType for '$className.$($property.Name)'."
            }

            $isArray = $property.CIMType.EndsWith('[]')
            $typeName = $property.CIMType -replace '\[\]$'
            $embeddedInstance = $null
            if ($typeName -match '^MSFT_[a-zA-Z_][a-zA-Z0-9_]*$')
            {
                $embeddedInstance = $typeName
                $dataType = 'Instance'
            }
            elseif ($typeName -in $primitiveTypes)
            {
                $dataType = $typeName
            }
            else
            {
                throw "Unsupported CIMType '$($property.CIMType)' for '$className.$($property.Name)'."
            }

            if ($isArray)
            {
                $dataType += 'Array'
            }

            if ($null -ne $property.ValueMap -and $property.ValueMap -isnot [System.Array])
            {
                throw "ValueMap for '$className.$($property.Name)' must be an array."
            }

            @{
                Name             = $property.Name
                State            = $property.Option
                DataType         = $dataType
                ValueMap         = $property.ValueMap
                IsArray          = $isArray
                Description      = $property.Description
                EmbeddedInstance = $embeddedInstance
            }
        })

        $schemas.Add($className, @{
            ClassName    = $className
            FriendlyName = $null
            Attributes   = $attributes
        })
    }

    foreach ($resourceName in $resourceNames)
    {
        if ($resourceName -isnot [System.String] -or $resourceName -notmatch '^[a-zA-Z_][a-zA-Z0-9_]*$')
        {
            throw "Invalid exported DSC resource name '$resourceName' in '$manifestPath'."
        }

        $className = "MSFT_$resourceName"
        if (-not $schemas.ContainsKey($className))
        {
            throw "Exported DSC resource '$resourceName' has no definition in '$schemaPath'."
        }

        if ('Key' -notin $schemas[$className].Attributes.State)
        {
            throw "Exported DSC resource '$resourceName' has no key property."
        }

        $schemas[$className].FriendlyName = $resourceName
    }

    foreach ($schema in $schemas.Values)
    {
        foreach ($property in $schema.Attributes)
        {
            if ($null -ne $property.EmbeddedInstance -and
                $property.EmbeddedInstance -ne 'MSFT_Credential' -and
                -not $schemas.ContainsKey($property.EmbeddedInstance))
            {
                throw "Complex type '$($property.EmbeddedInstance)' referenced by '$($schema.ClassName).$($property.Name)' is not defined."
            }
        }
    }

    return $schemas
}
