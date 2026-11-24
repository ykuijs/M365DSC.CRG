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

        $testVersion = '1.23.1108.100'
        $testM365DSCVersion = '1.23.1108.1'

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

            New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $testVersion | Should -Be $false
        }

        It 'Should return False because Microsoft365DSC cannot be found' {
            Mock -CommandName Test-Path -MockWith { return $true } -ModuleName $dscModuleName
            Mock -CommandName Get-Module -MockWith { } -ModuleName $dscModuleName

            New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $testVersion | Should -Be $false
        }

    }

    Context 'Function succeeds, module is created correctly' {
        BeforeAll {
            Mock -CommandName Test-Path -MockWith { return $true } -ModuleName $dscModuleName
            Mock -CommandName Get-Module -MockWith { return @(@{Name = 'Microsoft365DSC';Version = $testM365DSCVersion;ModuleBase = "C:\Program Files\WindowsPowerShell\Modules\Microsoft365DSC\$testM365DSCVersion"}) } -ModuleName $dscModuleName
            Mock -CommandName Initialize-Module -MockWith {} -ModuleName $dscModuleName
            Mock -CommandName Get-ResourceSchema -MockWith {
                $fixtures = . $PSScriptRoot\ResourceSchemas.ps1
                $schemas = @{}
                foreach ($definitions in $fixtures.Values)
                {
                    foreach ($definition in $definitions)
                    {
                        $schemas[$definition.ClassName] = $definition
                    }
                }
                return $schemas
            } -ModuleName $dscModuleName
            Mock -CommandName Save-Resource -MockWith {} -ModuleName $dscModuleName
            Mock -CommandName Set-Content -MockWith {
                $sb = [Scriptblock]::Create($value)
                $global:psdContent = $sb.InvokeReturnAsIs()
            } -ModuleName $dscModuleName
        }

        It 'Should return True because the CR module is created successfully' {
            New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $testVersion | Should -Be $true
            Should -Invoke -CommandName Save-Resource -Times 10 -ModuleName $dscModuleName
            Should -Invoke -CommandName Set-Content -Times 1 -ModuleName $dscModuleName
            Should -Invoke -CommandName Save-Resource -Times 10 -Exactly -ModuleName $dscModuleName -ParameterFilter {
                $Config -match "Import-DscResource -ModuleName Microsoft365DSC -ModuleVersion '1.23.1108.1'"
            }

            $content = Get-Content -Path "$PSScriptRoot\PsdTemplate.psd1" -Raw
            $sb = [Scriptblock]::Create($content)
            $psdTargetContent = $sb.InvokeReturnAsIs()
            Test-Equality -a $psdContent -b $psdTargetContent | Should -Be $true
        }

        It 'Should stop before initializing output when metadata cannot be read' {
            Mock -CommandName Get-ResourceSchema -MockWith { throw 'Invalid resource metadata' } -ModuleName $dscModuleName

            { New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $testVersion } | Should -Throw '*Invalid resource metadata*'
            Should -Invoke -CommandName Initialize-Module -Times 0 -Exactly -ModuleName $dscModuleName
        }

        It 'Should group unordered resources and exclude complex types and unsupported resources' {
            Mock -CommandName Get-ResourceSchema -MockWith {
                $attributes = @(
                    @{ Name = 'Id'; State = 'Key'; DataType = 'String'; IsArray = $false }
                    @{ Name = 'CertificateThumbprint'; State = 'Write'; DataType = 'String'; IsArray = $false }
                )
                @{
                    MSFT_AADLast = @{ FriendlyName = 'AADLast'; Attributes = $attributes }
                    MSFT_TeamsTest = @{ FriendlyName = 'TeamsTest'; Attributes = $attributes }
                    MSFT_AADFirst = @{ FriendlyName = 'AADFirst'; Attributes = $attributes }
                    MSFT_Complex = @{ FriendlyName = $null; Attributes = $attributes }
                    MSFT_AADUnsupported = @{ FriendlyName = 'AADUnsupported'; Attributes = @(@{ Name = 'Id'; State = 'Key' }) }
                    MSFT_M365DSCRuleEvaluation = @{ FriendlyName = 'M365DSCRuleEvaluation'; Attributes = $attributes }
                }
            } -ModuleName $dscModuleName

            New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $testVersion | Should -BeTrue
            Should -Invoke -CommandName Save-Resource -Times 2 -Exactly -ModuleName $dscModuleName
            Should -Invoke -CommandName Save-Resource -Times 1 -Exactly -ModuleName $dscModuleName -ParameterFilter {
                $Workload -eq 'AzureAD' -and $Config -match "'AADFirst'" -and $Config -match "'AADLast'" -and $Config -notmatch "'TeamsTest'"
            }
        }

        It 'Should reject metadata without supported resources before initializing output' {
            Mock -CommandName Get-ResourceSchema -MockWith {
                @{ MSFT_AADUnsupported = @{ FriendlyName = 'AADUnsupported'; Attributes = @(@{ Name = 'Id'; State = 'Key' }) } }
            } -ModuleName $dscModuleName

            { New-CompositeResourceModule -OutputPath 'C:\Temp' -Version $testVersion } | Should -Throw '*No supported resources*'
            Should -Invoke -CommandName Initialize-Module -Times 0 -Exactly -ModuleName $dscModuleName
        }
    }
}
