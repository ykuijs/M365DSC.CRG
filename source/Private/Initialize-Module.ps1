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
        Initialize-Module -Version 1.23.621.100
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

        $m365dscVersion = $Version.Substring(0, $Version.LastIndexOf('.') + 2)

        # Create the module manifest content
        $moduleManifestString = [System.Text.StringBuilder]::new()
        [void]$moduleManifestString.AppendLine('#')
        [void]$moduleManifestString.AppendLine("# Module manifest for module 'M365DSC.CompositeResources'")
        [void]$moduleManifestString.AppendLine('#')
        [void]$moduleManifestString.AppendLine("# Generated on: $(Get-Date -f "d-M-yyyy")")
        [void]$moduleManifestString.AppendLine('#')
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('@{')
        [void]$moduleManifestString.AppendLine('    # Script module or binary module file associated with this manifest.')
        [void]$moduleManifestString.AppendLine("    RootModule           = 'M365DSC.CompositeResources.psm1'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Version number of this module.')
        [void]$moduleManifestString.AppendLine("    ModuleVersion        = '$Version'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # ID used to uniquely identify this module')
        [void]$moduleManifestString.AppendLine("    GUID                 = '8c07a295-6a8d-465d-933d-9f598d77fdfb'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Author of this module')
        [void]$moduleManifestString.AppendLine("    Author               = 'Yorick Kuijs'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Company or vendor of this module')
        [void]$moduleManifestString.AppendLine("    CompanyName          = 'Microsoft'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Modules that must be imported into the global environment prior to importing this module')
        [void]$moduleManifestString.AppendLine('    RequiredModules      = @(')
        [void]$moduleManifestString.AppendLine("        @{ModuleName='DscBuildHelpers'; ModuleVersion ='0.2.1'; GUID='23ccd4bf-0a52-4077-986f-c153893e5a6a'}")
        [void]$moduleManifestString.AppendLine("        @{ModuleName='Microsoft365DSC'; RequiredVersion='$m365dscVersion'; GUID='39f599a6-d212-4480-83b3-a8ea2124d8cf'})")
        [void]$moduleManifestString.AppendLine('    )')
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.')
        [void]$moduleManifestString.AppendLine("    FunctionsToExport    = @('New-M365DSCExampleDataFile')")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.')
        [void]$moduleManifestString.AppendLine("    CmdletsToExport      = @()")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Variables to export from this module')
        [void]$moduleManifestString.AppendLine("    VariablesToExport    = @()")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.')
        [void]$moduleManifestString.AppendLine("    AliasesToExport      = @()")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # DSC resources to export from this module')
        [void]$moduleManifestString.AppendLine("    DscResourcesToExport = @('*')")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Description of the functionality provided by this module')
        [void]$moduleManifestString.AppendLine("    Description          = 'DSC composite resource for configuring Microsoft 365'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Minimum version of the Windows PowerShell engine required by this module')
        [void]$moduleManifestString.AppendLine("    PowerShellVersion    = '5.0'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.')
        [void]$moduleManifestString.AppendLine('    PrivateData          = @{')
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('        PSData = @{')
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('            # Tags applied to this module. These help with module discovery in online galleries.')
        [void]$moduleManifestString.AppendLine("            Tags         = @('DSC', 'DesiredStateConfiguration', 'M365DSC', 'Microsoft365DSC', 'Microsoft365', 'CompositeResource')")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('            # A URL to the license for this module.')
        [void]$moduleManifestString.AppendLine("            LicenseUri   = 'https://github.com/ykuijs/M365DSC.CompositeResources/blob/main/LICENSE'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('            # A URL to the main website for this project.')
        [void]$moduleManifestString.AppendLine("            ProjectUri   = 'https://github.com/ykuijs/M365DSC.CompositeResources'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('            # A URL to an icon representing this module.')
        [void]$moduleManifestString.AppendLine("            IconUri      = 'https://github.com/microsoft/Microsoft365DSC/blob/Dev/Modules/Microsoft365DSC/Dependencies/Images/Logo.png?raw=true'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine('            # ReleaseNotes of this module')
        [void]$moduleManifestString.AppendLine("            ReleaseNotes = 'Module belongs to Microsoft365DSC v$($m365dscVersion)'")
        [void]$moduleManifestString.AppendLine('')
        [void]$moduleManifestString.AppendLine("            ExternalModuleDependencies = @('Microsoft365DSC', 'DscBuildHelpers')")
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
