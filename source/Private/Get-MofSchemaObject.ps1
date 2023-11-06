function Get-MofSchemaObject
{
    <#
        .Synopsis
        Reads and parses the Mof schema file

        .Description
        This function reads a Mof schema file and parses the results into
        an object.

        .Parameter FileName
        Specifies the full path of the Mof schema file.

        .Example
        # Loops through all schemas in the Microsoft365DSC module
        $m365modulePath = Split-Path -Path (Get-Module Microsoft365DSC -ListAvailable) -Parent
        $mofSearchPath = Join-Path -Path $m365modulePath -ChildPath '\**\**.schema.mof'
        $mofSchemaFiles = @(Get-ChildItem -Path $mofSearchPath -Recurse)
        foreach ($mofSchemaFile in $mofSchemaFiles)
        {
            $mofSchemas = Get-MofSchemaObject -FileName $mofSchemaFile.FullName
            # Your code to use the schemas
        }
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $FileName
    )

    process
    {
        if ($IsMacOS)
        {
            throw 'NotImplemented: Currently there is an issue using the type [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache] on macOS. See issue https://github.com/PowerShell/PowerShell/issues/5970 and issue https://github.com/PowerShell/MMI/issues/33.'
        }

        $temporaryPath = Get-TemporaryPath

        #region Workaround for OMI_BaseResource inheritance not resolving.
        $filePath = (Resolve-Path -Path $FileName).Path
        $tempFilePath = Join-Path -Path $temporaryPath -ChildPath "DscMofHelper_$((New-Guid).Guid).tmp"
        $rawContent = (Get-Content -Path $filePath -Raw) -replace '\s*:\s*OMI_BaseResource'

        Set-Content -LiteralPath $tempFilePath -Value $rawContent -ErrorAction 'Stop'

        # .NET methods don't like PowerShell drives
        $tempFilePath = Convert-Path -Path $tempFilePath
        #endregion

        try
        {
            $exceptionCollection = [System.Collections.ObjectModel.Collection[System.Exception]]::new()
            $moduleInfo = [System.Tuple]::Create('Module', [System.Version] '1.0.0')

            $class = [Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache]::ImportClasses(
                $tempFilePath, $moduleInfo, $exceptionCollection
            )
        }
        catch
        {
            throw "Failed to import classes from file $FileName. Error $_"
        }
        finally
        {
            Remove-Item -LiteralPath $tempFilePath -Force
        }

        foreach ($currentCimClass in $class)
        {
            $attributes = foreach ($property in $currentCimClass.CimClassProperties)
            {
                $state = switch ($property.flags)
                {
                    { $_ -band [Microsoft.Management.Infrastructure.CimFlags]::Key }
                    {
                        'Key'
                    }
                    { $_ -band [Microsoft.Management.Infrastructure.CimFlags]::Required }
                    {
                        'Required'
                    }
                    { $_ -band [Microsoft.Management.Infrastructure.CimFlags]::ReadOnly }
                    {
                        'Read'
                    }
                    default
                    {
                        'Write'
                    }
                }

                @{
                    Name             = $property.Name
                    State            = $state
                    DataType         = $property.CimType
                    ValueMap         = $property.Qualifiers.Where( { $_.Name -eq 'ValueMap' }).Value
                    IsArray          = $property.CimType -gt 16
                    Description      = $property.Qualifiers.Where( { $_.Name -eq 'Description' }).Value
                    EmbeddedInstance = $property.Qualifiers.Where( { $_.Name -eq 'EmbeddedInstance' }).Value
                }
            }

            @{
                ClassName    = $currentCimClass.CimClassName
                Attributes   = $attributes
                ClassVersion = $currentCimClass.CimClassQualifiers.Where( { $_.Name -eq 'ClassVersion' }).Value
                FriendlyName = $currentCimClass.CimClassQualifiers.Where( { $_.Name -eq 'FriendlyName' }).Value
            }
        }
    }
}
