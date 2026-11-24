BeforeDiscovery {
    $skipIntegration = $PSEdition -ne 'Desktop' -or
        [System.String]::IsNullOrWhiteSpace($env:M365DSC_CRG_INTEGRATION_VERSION)
}

Describe 'Class-based Microsoft365DSC compilation' -Tag 'Integration' -Skip:$skipIntegration {
    BeforeAll {
        Import-Module M365DSC.CRG -ErrorAction Stop
        Import-Module DscBuildHelpers -ErrorAction Stop
        $resourceVersion = [System.Version]$env:M365DSC_CRG_INTEGRATION_VERSION
        $compositeVersion = '{0}.{1}.{2}.{3}00' -f $resourceVersion.Major, $resourceVersion.Minor, $resourceVersion.Build, $resourceVersion.Revision
        New-CompositeResourceModule -OutputPath $TestDrive -Version $compositeVersion | Should -BeTrue
        $modulePath = Join-Path -Path $TestDrive -ChildPath "M365DSC.CompositeResources\$compositeVersion"
        $previousModulePath = $env:PSModulePath
        $env:PSModulePath = "$TestDrive;$env:PSModulePath"
    }

    AfterAll {
        $env:PSModulePath = $previousModulePath
        Remove-Module M365DSC.CRG -Force
    }

    It 'Generates importable example data and workload manifests from installed JSON metadata' {
        # Windows PowerShell's Import-PowerShellDataFile limits the number of keys.
        Import-LocalizedData -BindingVariable data -BaseDirectory $modulePath -FileName 'M365ConfigurationDataExample.psd1'
        $data.NonNodeData.AzureAD.AccessReviewDefinition | Should -Not -BeNullOrEmpty
        (Import-PowerShellDataFile -LiteralPath "$modulePath\M365DSC.CompositeResources.psd1").PowerShellVersion | Should -Be '5.1'
        $workloads = @(Get-ChildItem -LiteralPath "$modulePath\DscResources" -Directory)
        $workloads.Count | Should -BeGreaterThan 0
        foreach ($workload in $workloads)
        {
            $manifest = Import-PowerShellDataFile -LiteralPath "$($workload.FullName)\$($workload.Name).psd1"
            Test-Path -LiteralPath (Join-Path -Path $workload.FullName -ChildPath $manifest.RootModule) | Should -BeTrue
        }

        $installedModule = Get-Module Microsoft365DSC -ListAvailable |
            Where-Object { $_.Version -eq $resourceVersion } |
            Select-Object -First 1
        $resourceManifest = Import-PowerShellDataFile -LiteralPath $installedModule.Path
        $definitions = Get-Content -LiteralPath "$($installedModule.ModuleBase)\SchemaDefinition.json" -Raw | ConvertFrom-Json
        $expectedNames = @($definitions | Where-Object {
            ($_.ClassName -replace '^MSFT_') -in $resourceManifest.DscResourcesToExport -and
            $_.ClassName -notlike 'MSFT_M365DSC*' -and
            'CertificateThumbprint' -in $_.Parameters.Name
        } | ForEach-Object { $_.ClassName -replace '^MSFT_' })
        $generatedNames = @(foreach ($workload in $workloads)
        {
            $code = Get-Content -LiteralPath "$($workload.FullName)\$($workload.Name).schema.psm1" -Raw
            foreach ($match in [regex]::Matches($code, "Get-DscSplattedResource -ResourceName '(\w+)' -ExecutionName"))
            {
                $match.Groups[1].Value
            }
        })
        $generatedNames.Count | Should -Be $expectedNames.Count
        @($generatedNames | Sort-Object -Unique).Count | Should -Be $expectedNames.Count
        Compare-Object -ReferenceObject $expectedNames -DifferenceObject $generatedNames | Should -BeNullOrEmpty
    }

    It 'Compiles a generated composite with scalar, array, and deeply nested class properties without applying it' {
        $configurationData = @{
            AllNodes = @(@{ NodeName = 'localhost' })
            NonNodeData = @{
                AzureAD = @{
                    AccessReviewDefinition = @(
                        @{
                            DisplayName = 'CRG compilation test'
                            Ensure = 'Present'
                            AccessTokens = @('compilation-test-one', 'compilation-test-two')
                            AdditionalNotificationRecipients = $null
                            FallbackReviewers = @()
                            Reviewers = @(
                                @{ UniqueId = 'reviewer-one'; Type = 'Manager' }
                                @{ UniqueId = 'reviewer-two'; Type = 'Owner' }
                            )
                            Settings = @{
                                InstanceDurationInDays = 7
                                Recurrence = @{
                                    Pattern = @{ Type = 'daily'; Interval = 1 }
                                    Range = @{ Type = 'noEnd'; StartDate = '2026-10-20' }
                                }
                            }
                        }
                    )
                }
            }
        }
        $configuration = [scriptblock]::Create(@"
Configuration CRGClassResourceCompilation
{
    Import-DscResource -ModuleName M365DSC.CompositeResources -ModuleVersion '$compositeVersion' -Name AzureAD
    Node localhost
    {
        AzureAD Defaults
        {
            ApplicationId = '00000000-0000-0000-0000-000000000001'
            TenantId = 'example.onmicrosoft.com'
            CertificateThumbprint = '0000000000000000000000000000000000000000'
        }
    }
}
CRGClassResourceCompilation -ConfigurationData `$configurationData -OutputPath '$TestDrive\Compiled' -ErrorAction Stop
"@)
        & $configuration
        $mofPath = Join-Path -Path $TestDrive -ChildPath 'Compiled\localhost.mof'
        Test-Path -LiteralPath $mofPath | Should -BeTrue
        $mof = Get-Content -LiteralPath $mofPath -Raw
        $mof | Should -Match 'CRG compilation test'
        $mof | Should -Match 'MSFT_AADAccessReviewDefinitionReviewer'
        $mof | Should -Match 'MSFT_MicrosoftGraphPatternedRecurrence'
        $mof | Should -Not -Match 'reviewer-one|reviewer-two'
    }
}
