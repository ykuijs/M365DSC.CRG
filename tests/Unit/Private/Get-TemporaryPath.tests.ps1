BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-TemporaryPath {
    Context 'When calling the function with string value' {
        It 'Should return the Windows Temp folder' {
            InModuleScope -ModuleName $dscModuleName {
                Get-TemporaryPath | Should -Be $env:TEMP
            }
        }

        It 'Should return the MacOS Temp folder' {
            InModuleScope -ModuleName $dscModuleName {
                $IsMacOS = $true
                $env:TMPDIR = 'C:\MacOsTemp'
                Get-TemporaryPath | Should -Be 'C:\MacOSTemp'
            }
        }

        It 'Should return the Linux Temp folder' {
            InModuleScope -ModuleName $dscModuleName {
                $IsLinux = $true
                Get-TemporaryPath | Should -Be '/tmp'
            }
        }
    }
}
