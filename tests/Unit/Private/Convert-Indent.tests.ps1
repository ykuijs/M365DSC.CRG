BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Convert-Indent {
    Context 'When calling the function with string value' {
        It 'Should return a string with four spaces' {
            InModuleScope -ModuleName $dscModuleName {
                Convert-Indent | Should -Be '    '
            }
        }

        It 'Should return an empty string' {
            InModuleScope -ModuleName $dscModuleName {
                Convert-Indent -Indent '0' | Should -Be ''
            }
        }

        It 'Should return a string with a tab' {
            InModuleScope -ModuleName $dscModuleName {
                Convert-Indent -Indent '1' | Should -Be "`t"
            }
        }

        It 'Should return a string with two spaces' {
            InModuleScope -ModuleName $dscModuleName {
                Convert-Indent -Indent '2' | Should -Be '  '
            }
        }

        It 'Should return a string with four spaces' {
            InModuleScope -ModuleName $dscModuleName {
                Convert-Indent -Indent '4' | Should -Be '    '
            }
        }
    }
}
