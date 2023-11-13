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

        function Test-IsPsCustomObject
        {
            [CmdletBinding()]
            param (
                [Parameter()]
                [System.Object]
                $v
            )
            $v.PSTypeNames -contains 'System.Management.Automation.PSCustomObject'
        }

        function Test-Equality
        {
            [CmdletBinding()]
            param
            (
                [Parameter()]
                [System.Object]
                $a,

                [Parameter()]
                [System.Object]
                $b
            )

            # recursive step for arrays
            if ($a -is [array] -and $b -is [array])
            {
                if ($a.Count -ne $b.Count)
                {
                    return $false
                }
                $inequalIndexes = 0..($a.Count - 1) | Where-Object { -not (Test-Equality $a[$_] $b[$_]) }
                Write-Verbose -Message "inequalKeys: $inequalKeys"
                return $inequalIndexes.Count -eq 0
            }
            # recursive step for hashtables
            if ($a -is [hashtable] -and $b -is [hashtable])
            {
                $inequalKeys = $a.Keys + $b.Keys `
                | Sort-Object -Unique `
                | Where-Object { -not (Test-Equality $a[$_] $b[$_]) }
                Write-Verbose -Message "inequalKeys: $inequalKeys"
                return $inequalKeys.Count -eq 0
            }
            # recursive step for objects
            # use a helper function to circumvent this PowerShell bug:
            # https://github.com/PowerShell/PowerShell/issues/9557
            if ((Test-IsPsCustomObject -v $a) -and (Test-IsPsCustomObject -v $b))
            {
                $inequalKeys = $a.psobject.Properties + $b.psobject.Properties `
                | ForEach-Object Name `
                | Sort-Object -Unique `
                | Where-Object { -not (Test-Equality $a.$_ $b.$_) }
                Write-Verbose -Message "inequalKeys: $inequalKeys"
                return $inequalKeys.Count -eq 0
            }
            # base case
            return ($null -ne $a -or $null -ne $null) -and $a.GetType() -eq $b.GetType() -and $a -eq $b
        }
    }

    Context 'Function fails because of issues' {
        It 'Should return False because the Dependencies file does not exist' {
            Mock -CommandName Test-Path -MockWith { return $false } -ModuleName $dscModuleName

            New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $env:ModuleVersion | Should -Be $false
        }

        It 'Should return False because Microsoft365DSC cannot be found' {
            Mock -CommandName Test-Path -MockWith { return $true } -ModuleName $dscModuleName
            Mock -CommandName Get-Module -MockWith { } -ModuleName $dscModuleName

            New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $env:ModuleVersion | Should -Be $false
        }

    }

    Context 'Function succeeds, module is created correctly' {
        BeforeAll {
            Mock -CommandName Test-Path -MockWith { return $true } -ModuleName $dscModuleName
            Mock -CommandName Get-Module -MockWith { return @(@{Name = 'Microsoft365DSC';Version = $env:ModuleVersion;Path = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion"}) } -ModuleName $dscModuleName
            Mock -CommandName Initialize-Module -MockWith {} -ModuleName $dscModuleName
            Mock -CommandName Get-ChildItem -MockWith {
                return @(
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_AADApplication\MSFT_AADApplication.schema.mof";Name = 'MSFT_AADApplication.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_EXOAcceptedDomain\MSFT_EXOAcceptedDomain.schema.mof";Name = 'MSFT_EXOAcceptedDomain.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_IntuneAntivirusPolicyWindows10SettingCatalog\MSFT_IntuneAntivirusPolicyWindows10SettingCatalog.schema.mof";Name = 'MSFT_IntuneAntivirusPolicyWindows10SettingCatalog.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_O365AdminAuditLogConfig\MSFT_O365AdminAuditLogConfig.schema.mof";Name = 'MSFT_O365AdminAuditLogConfig.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_ODSettings\MSFT_ODSettings.schema.mof";Name = 'MSFT_ODSettings.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_PlannerPlan\MSFT_PlannerPlan.schema.mof";Name = 'MSFT_PlannerPlan.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_PPTenantSettings\MSFT_PPTenantSettings.schema.mof";Name = 'MSFT_PPTenantSettings.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_SCAuditConfigurationPolicy\MSFT_SCAuditConfigurationPolicy.schema.mof";Name = 'MSFT_SCAuditConfigurationPolicy.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_SPOTenantSettings\MSFT_SPOTenantSettings.schema.mof";Name = 'MSFT_SPOTenantSettings.schema.mof' }
                    @{FullName = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$env:ModuleVersion\DSCResources\MSFT_TeamsClientConfiguration\MSFT_TeamsClientConfiguration.schema.mof";Name = 'MSFT_TeamsClientConfiguration.schema.mof' }
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
                $sb = [Scriptblock]::Create($value)
                $global:psdContent = $sb.InvokeReturnAsIs()
            } -ModuleName $dscModuleName
        }

        It 'Should return True because the CR module is created successfully' {
            New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $env:ModuleVersion | Should -Be $true
            Should -Invoke -CommandName Save-Resource -Times 10 -ModuleName $dscModuleName
            Should -Invoke -CommandName Set-Content -Times 1 -ModuleName $dscModuleName

            $content = Get-Content -Path "$PSScriptRoot\PsdTemplate.psd1" -Raw
            $sb = [Scriptblock]::Create($content)
            $psdTargetContent = $sb.InvokeReturnAsIs()
            Test-Equality -a $psdContent -b $psdTargetContent | Should -Be $true
        }
    }
}
