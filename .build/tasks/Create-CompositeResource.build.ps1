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

    Write-Build White 'Generating Composite Resource Module'

    $result = New-CompositeResourceModule -OutputPath $OutputDirectory

    if ($result)
    {
        Write-Build Green "Module generation completed."
    }
    else
    {
        throw "Error occurred during module generation! Please check the log output."
    }

    # $osShortName = Get-OperatingSystemShortName

    # $powerShellVersion = 'PSv.{0}' -f $PSVersionTable.PSVersion

    # $moduleFileName = '{0}.psm1' -f $ProjectName

    # $PesterOutputFolder = Get-SamplerAbsolutePath -Path $PesterOutputFolder -RelativeTo $OutputDirectory

    # "`tPester Output Folder            = '$PesterOutputFolder'"

    # $GetCodeCoverageThresholdParameters = @{
    #     RuntimeCodeCoverageThreshold = $CodeCoverageThreshold
    #     BuildInfo                    = $BuildInfo
    # }

    # $CodeCoverageThreshold = Get-CodeCoverageThreshold @GetCodeCoverageThresholdParameters

    # if (-not $CodeCoverageThreshold)
    # {
    #     $CodeCoverageThreshold = 0
    # }

    # "`tCode Coverage Threshold         = '$CodeCoverageThreshold'"

    # if ($CodeCoverageThreshold -gt 0)
    # {
    #     $getPesterOutputFileFileNameParameters = @{
    #         ProjectName       = $ProjectName
    #         ModuleVersion     = $ModuleVersion
    #         OsShortName       = $osShortName
    #         PowerShellVersion = $powerShellVersion
    #     }

    #     $pesterOutputFileFileName = Get-PesterOutputFileFileName @getPesterOutputFileFileNameParameters

    #     $getCodeCoverageOutputFile = @{
    #         BuildInfo          = $BuildInfo
    #         PesterOutputFolder = $PesterOutputFolder
    #     }

    #     $CodeCoverageOutputFile = Get-SamplerCodeCoverageOutputFile @getCodeCoverageOutputFile

    #     if (-not $CodeCoverageOutputFile)
    #     {
    #         $CodeCoverageOutputFile = (Join-Path -Path $PesterOutputFolder -ChildPath "CodeCov_$pesterOutputFileFileName")
    #     }

    #     "`tCode Coverage Output File       = $CodeCoverageOutputFile"

    #     $CodeCoverageMergedOutputFile = 'CodeCov_Merged.xml'

    #     if ($BuildInfo.CodeCoverage.CodeCoverageMergedOutputFile)
    #     {
    #         $CodeCoverageMergedOutputFile = $BuildInfo.CodeCoverage.CodeCoverageMergedOutputFile
    #     }

    #     $CodeCoverageMergedOutputFile = Get-SamplerAbsolutePath -Path $CodeCoverageMergedOutputFile -RelativeTo $PesterOutputFolder

    #     "`tCode Coverage Merge Output File = $CodeCoverageMergedOutputFile"

    #     $CodeCoverageFilePattern = 'Codecov*.xml'

    #     if ($BuildInfo.ContainsKey('CodeCoverage') -and $BuildInfo.CodeCoverage.ContainsKey('CodeCoverageFilePattern'))
    #     {
    #         $CodeCoverageFilePattern = $BuildInfo.CodeCoverage.CodeCoverageFilePattern
    #     }

    #     "`tCode Coverage File Pattern      = $CodeCoverageFilePattern"

    #     if (-not [System.String]::IsNullOrEmpty($CodeCoverageFilePattern))
    #     {
    #         $codecovFiles = Get-ChildItem -Path $PesterOutputFolder -Include $CodeCoverageFilePattern -Recurse
    #     }

    #     "`tMerging Code Coverage Files     = '{0}'" -f ($codecovFiles.FullName -join ', ')
    #     ""

    #     if (Test-Path -Path $CodeCoverageMergedOutputFile)
    #     {
    #         Write-Build Yellow "File $CodeCoverageMergedOutputFile found, deleting file."

    #         Remove-Item -Path $CodeCoverageMergedOutputFile -Force
    #     }

    #     Write-Build White "Processing folder: $OutputDirectory"

    #     if ($codecovFiles.Count -gt 1)
    #     {
    #         Write-Build DarkGray "Started merging $($codecovFiles.Count) code coverage files!"

    #         Start-CodeCoverageMerge -Files $codecovFiles -TargetFile $CodeCoverageMergedOutputFile

    #         Write-Build Green "Merge completed. Saved merge result to: $CodeCoverageMergedOutputFile"
    #     }
    #     else
    #     {
    #         throw "Found $($codecovFiles.Count) code coverage file. Need at least two files to merge."
    #     }
    # }
    # else
    # {
    #     Write-Build White 'Code coverage is not enabled, skipping.'
    # }
}
