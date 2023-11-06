function Initialize-Module
{
    <#
        .Synopsis
        Initializes the module by creating all required files and folders

        .Description
        This function initializes the M365DSC.CompositeResources module by creating the
        required folder structure and the module manifest file.

        .Parameter Version
        Specifies the version of the module.

        .Parameter OutputPath
        Path to which files of the new module are written.

        .Example
        Initialize-Module -Version 1.23.621.1
    #>
    [CmdletBinding()]
    [OutputType()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $Version,

        [Parameter(Mandatory = $true)]
        [System.String]
        $OutputPath
    )

    process
    {
        # Create the folder structure
        $modulePath = Join-Path -Path $OutputPath -ChildPath "M365DSC.CompositeResources\$Version"
        if ((Test-Path -Path $modulePath) -eq $false)
        {
            $null = New-Item -Path $modulePath -ItemType Directory
        }

        $dscResourcesPath = Join-Path -Path $modulePath -ChildPath 'DscResources'
        if ((Test-Path -Path $dscResourcesPath) -eq $false)
        {
            $null = New-Item -Path $dscResourcesPath -ItemType Directory
        }

        # Create the module manifest content
        $moduleManifestString = [System.Text.StringBuilder]::new()
        [void]$moduleManifestString.AppendLine('@{')
        [void]$moduleManifestString.AppendLine("    ModuleVersion        = '$Version'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("    GUID                 = '8c07a295-6a8d-465d-933d-9f598d77fdfb'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("    Author               = 'Yorick Kuijs'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("    CompanyName          = 'Microsoft'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("    RequiredModules      = @('DscBuildHelpers', @{ModuleName='DscBuildHelpers'; RequiredVersion='0.2.1'; GUID='23ccd4bf-0a52-4077-986f-c153893e5a6a'})")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("    DscResourcesToExport = @('*')")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("    Description          = 'DSC composite resource for configuring Microsoft 365'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    PrivateData          = @{')
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('        PSData = @{')
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("            Tags                       = @('DSC', 'Configuration', 'Composite', 'Resource', 'Microsoft365DSC')")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("            ExternalModuleDependencies = @('Microsoft365DSC')")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('        }')
        [void]$moduleManifestString.AppendLine('    }')
        [void]$moduleManifestString.AppendLine('}')

        $moduleManifestFileName = 'M365DSC.CompositeResources.psd1'
        $moduleManifestFilePath = Join-Path -Path $modulePath -ChildPath $moduleManifestFileName

        # Save the module manifest content to file
        Set-Content -Path $moduleManifestFilePath -Value $moduleManifestString.ToString()
    }
}
