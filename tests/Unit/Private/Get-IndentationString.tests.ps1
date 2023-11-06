BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-IndentationString {
    Context 'When calling the function with string value' {
        It 'Should return a string with eight spaces' {
            InModuleScope -ModuleName $dscModuleName {
                Get-IndentationString -Indentation 2 | Should -Be '        '
            }
        }
    }
}
