function Save-Resource
{
    <#
        .Synopsis
        Saves the composite resource content to file

        .Description
        This function saves the composite resource content to the
        schema file and creates the resource data file.

        .Parameter Config
        Specifies the content of the composite resource.

        .Parameter Workload
        Specifies the workload of the composite resource.

        .Parameter Version
        Specifies the version of the composite resource.

        .Parameter OutputPath
        Path to which files of the new composite resource are written.

        .Example
        Save-Resource -Config $content.ToString() -Workload 'Teams' -Version 1.23.621.1 -OutputPath $OutputPath
    #>
    [CmdletBinding()]
    [OutputType()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Config,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Workload,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Version,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    process
    {
        $modulePath = Join-Path -Path $OutputPath -ChildPath "M365DSC.CompositeResources\$Version"
        $dscResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'

        # Save the schema file of the composite resource
        $resourceSavePath = Join-Path -Path $dscResourcesPath -ChildPath $Workload
        if ((Test-Path -Path $resourceSavePath) -eq $false)
        {
            $null = New-Item -Path $resourceSavePath -ItemType Directory
        }

        $schemaFileName = '{0}.schema.psm1' -f $Workload
        $schemaFilePath = Join-Path -Path $resourceSavePath -ChildPath $schemaFileName
        Set-Content -Path $schemaFilePath -Value $Config

        # Create the manifest content for the composite resource
        $manifestString = [System.Text.StringBuilder]::new()
        [void]$manifestString.AppendLine('@{')
        [void]$manifestString.AppendLine("    RootModule           = '$Workload.schema.psm1'")
        [void]$manifestString.AppendLine('')
        [void]$manifestString.AppendLine("    ModuleVersion        = '$Version'")
        [void]$manifestString.AppendLine('')
        [void]$manifestString.AppendLine("    GUID                 = '$(New-Guid)'")
        [void]$manifestString.AppendLine('')
        [void]$manifestString.AppendLine("    Author               = 'Yorick Kuijs'")
        [void]$manifestString.AppendLine('')
        [void]$manifestString.AppendLine("    CompanyName          = 'Microsoft'")
        [void]$manifestString.AppendLine('')
        [void]$manifestString.AppendLine("    Copyright            = 'Copyright to Microsoft Corporation. All rights reserved.'")
        [void]$manifestString.AppendLine('')
        [void]$manifestString.AppendLine("    DscResourcesToExport = @('$Workload')")
        [void]$manifestString.AppendLine('}')

        $manifestFileName = '{0}.psd1' -f $Workload
        $schemaFilePath = Join-Path -Path $resourceSavePath -ChildPath $manifestFileName

        # Save the manifest content of the composite resource to file
        Set-Content -Path $schemaFilePath -Value $manifestString.ToString()
    }
}
