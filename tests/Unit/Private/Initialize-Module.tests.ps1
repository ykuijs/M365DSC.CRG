BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Initialize-Module {
    Context 'When calling the function with string value' {
        It 'Should create a module manifest file with the correct data' {
            InModuleScope -ModuleName $dscModuleName {
                Mock -CommandName Test-Path -MockWith { $false }
                Mock -CommandName New-Item -MockWith { "" }
                Mock -CommandName Set-Content -MockWith { }

                Initialize-Module -Version '1.23.1101.1' -OutputPath 'C:\Temp' | Should -Invoke 'Set-Content'
            }
        }
    }
}
