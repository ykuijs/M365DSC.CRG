BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe New-CompositeResourceModule {
    BeforeAll {
        Mock -CommandName Write-Host -MockWith {} -ModuleName $dscModuleName

        # Mock -CommandName Get-PrivateFunction -MockWith {
        #     # This return the value passed to the Get-PrivateFunction parameter $PrivateData.
        #     $PrivateData
        # } -ModuleName $dscModuleName
    }

    Context 'Function fails because of issues' {
        It 'Should return False because the Dependencies file does not exist' {
            Mock -CommandName Test-Path -MockWith { return $false } -ModuleName $dscModuleName

            New-CompositeResourceModule -OutputPath 'C:\Temp' | Should -Be $false
        }

        It 'Should return False because Microsoft365DSC cannot be found' {
            Mock -CommandName Test-Path -MockWith { return $true } -ModuleName $dscModuleName
            Mock -CommandName Get-Module -MockWith { } -ModuleName $dscModuleName

            New-CompositeResourceModule -OutputPath 'C:\Temp' | Should -Be $false
        }

        It 'Should return False because multiple Microsoft365DSC modules were found' {
            Mock -CommandName Test-Path -MockWith { return $true } -ModuleName $dscModuleName
            Mock -CommandName Get-Module -MockWith { @(@{Name = 'Microsoft365DSC';Version = '1.23.1011.1'},@{Name = 'Microsoft365DSC';Version = '1.23.1018.1'}) } -ModuleName $dscModuleName

            New-CompositeResourceModule -OutputPath 'C:\Temp' | Should -Be $false
        }
    }

    Context 'Function succeeds, module is created correctly' {
        BeforeAll {
            Mock -CommandName Test-Path -MockWith { return $true } -ModuleName $dscModuleName
            Mock -CommandName Get-Module -MockWith { return @(@{Name = 'Microsoft365DSC';Version = '1.23.1011.1';Path = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1'}) } -ModuleName $dscModuleName
            Mock -CommandName Initialize-Module -MockWith {} -ModuleName $dscModuleName
            Mock -CommandName Get-ChildItem -MockWith {
                return @(
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_AADApplication\MSFT_AADApplication.schema.mof';Name = 'MSFT_AADApplication.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_EXOAcceptedDomain\MSFT_EXOAcceptedDomain.schema.mof';Name = 'MSFT_EXOAcceptedDomain.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_IntuneAntivirusPolicyWindows10SettingCatalog\MSFT_IntuneAntivirusPolicyWindows10SettingCatalog.schema.mof';Name = 'MSFT_IntuneAntivirusPolicyWindows10SettingCatalog.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_O365AdminAuditLogConfig\MSFT_O365AdminAuditLogConfig.schema.mof';Name = 'MSFT_O365AdminAuditLogConfig.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_ODSettings\MSFT_ODSettings.schema.mof';Name = 'MSFT_ODSettings.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_PlannerPlan\MSFT_PlannerPlan.schema.mof';Name = 'MSFT_PlannerPlan.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_PPTenantSettings\MSFT_PPTenantSettings.schema.mof';Name = 'MSFT_PPTenantSettings.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_SCAuditConfigurationPolicy\MSFT_SCAuditConfigurationPolicy.schema.mof';Name = 'MSFT_SCAuditConfigurationPolicy.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_SPOTenantSettings\MSFT_SPOTenantSettings.schema.mof';Name = 'MSFT_SPOTenantSettings.schema.mof' }
                    @{FullName = 'C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\1.23.1011.1\DSCResources\MSFT_TeamsClientConfiguration\MSFT_TeamsClientConfiguration.schema.mof';Name = 'MSFT_TeamsClientConfiguration.schema.mof' }
                ) } -ModuleName $dscModuleName
            Mock -CommandName Get-MofSchemaObject -MockWith {
                $allMofSchemas = . $PSScriptRoot\MofSchemas.ps1

                $shortName = Split-Path -Path $FileName -Leaf
                switch ($shortName)
                {
                    { $_.StartsWith('MSFT_AAD') }
                    {
                        $returnVal = $allMofSchemas.MSFT_AAD
                        continue
                    }
                    { $_.StartsWith('MSFT_EXO') }
                    {
                        $returnVal = $allMofSchemas.MSFT_EXO
                        continue
                    }
                    { $_.StartsWith('MSFT_Intune') }
                    {
                        $returnVal = $allMofSchemas.MSFT_Intune
                        continue
                    }
                    { $_.StartsWith('MSFT_O365') }
                    {
                        $returnVal = $allMofSchemas.MSFT_O365
                        continue
                    }
                    { $_.StartsWith('MSFT_OD') }
                    {
                        $returnVal = $allMofSchemas.MSFT_OD
                        continue
                    }
                    { $_.StartsWith('MSFT_Planner') }
                    {
                        $returnVal = $allMofSchemas.MSFT_Planner
                        continue
                    }
                    { $_.StartsWith('MSFT_PP') }
                    {
                        $returnVal = $allMofSchemas.MSFT_PP
                        continue
                    }
                    { $_.StartsWith('MSFT_SC') }
                    {
                        $returnVal = $allMofSchemas.MSFT_SC
                        continue
                    }
                    { $_.StartsWith('MSFT_SPO') }
                    {
                        $returnVal = $allMofSchemas.MSFT_SPO
                        continue
                    }
                    { $_.StartsWith('MSFT_Teams') }
                    {
                        $returnVal = $allMofSchemas.MSFT_Teams
                        continue
                    }
                }
                return $returnVal
            } -ModuleName $dscModuleName
            Mock -CommandName Save-Resource -MockWith {} -ModuleName $dscModuleName
            Mock -CommandName Set-Content -MockWith {
                $start = $value[0].IndexOf('@{')
                $end = $value[0].Length - $start
                $global:psdContent = $value[0].Substring($start,$end)
            } -ModuleName $dscModuleName
        }

        It 'Should return True because the CR module is created successfully' {
            New-CompositeResourceModule -OutputPath 'C:\Temp' | Should -Be $true
            Should -Invoke -CommandName Save-Resource -Times 10 -ModuleName $dscModuleName
            Should -Invoke -CommandName Set-Content -Times 1 -ModuleName $dscModuleName

            $psdTargetContent = Get-Content -Path $PSScriptRoot\PsdTemplate.psd1 -Raw
            $psdContent.Trim() | Should -Be $psdTargetContent.Trim()
        }
    }
}
