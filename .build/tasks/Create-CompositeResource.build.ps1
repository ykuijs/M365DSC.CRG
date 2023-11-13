param
(
    # Project path
    [Parameter()]
    [System.String]
    $ProjectPath = (property ProjectPath $BuildRoot),

    [Parameter()]
    # Base directory of all output (default to 'output')
    [System.String]
    $OutputDirectory = (property OutputDirectory (Join-Path $BuildRoot 'output')),

    [Parameter()]
    [System.String]
    $BuiltModuleSubdirectory = (property BuiltModuleSubdirectory ''),

    [Parameter()]
    [System.Management.Automation.SwitchParameter]
    $VersionedOutputDirectory = (property VersionedOutputDirectory $true),

    [Parameter()]
    [System.String]
    $ProjectName = (property ProjectName ''),

    [Parameter()]
    [System.String]
    $PesterOutputFolder = (property PesterOutputFolder 'testResults'),

    [Parameter()]
    [System.String]
    $PesterOutputFormat = (property PesterOutputFormat ''),

    [Parameter()]
    [System.Object[]]
    $PesterScript = (property PesterScript ''),

    [Parameter()]
    [System.String[]]
    $PesterTag = (property PesterTag @()),

    [Parameter()]
    [System.String[]]
    $PesterExcludeTag = (property PesterExcludeTag @()),

    [Parameter()]
    [System.String]
    $CodeCoverageThreshold = (property CodeCoverageThreshold ''),

    # Build Configuration object
    [Parameter()]
    [System.Collections.Hashtable]
    $BuildInfo = (property BuildInfo @{ })
)


# Synopsis: Merging several code coverage files together.
task Generate_Composite_Resource_Module {
    # Get the vales for task variables, see https://github.com/gaelcolas/Sampler#task-variables.
    . Set-SamplerTaskVariable

    "`tOutput Path                = '$OutputDirectory'"
    ""

    Write-Build White 'Generating Composite Resource Module'

    if ($null -eq ((Get-Module 'Microsoft365DSC' -ListAvailable) | Where-Object { $_.Version -eq $env:ModuleVersion }))
    {
        Install-Module -Name 'Microsoft365DSC' -RequiredVersion $env:ModuleVersion -Scope AllUsers -Confirm:$false -Force
    }

    $result = New-CompositeResourceModule -OutputPath $OutputDirectory -Version $env:ModuleVersion

    if ($result)
    {
        Write-Build Green "Module generation completed."
    }
    else
    {
        throw "Error occurred during module generation! Please check the log output."
    }
}
