BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Invoke-TerminatingError {
    Context 'When calling the function with string value' {
        It 'Should throw an exception' {
            InModuleScope -ModuleName $dscModuleName {
                { Invoke-TerminatingError -M 'This is an exception' } | Should -Throw 'This is an exception'
            }
        }
    }
}
