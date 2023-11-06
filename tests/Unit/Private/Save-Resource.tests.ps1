BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Save-Resource {
    Context 'When calling the function with string value' {
        It 'Should store the created resource to a DSCResource file' {
            InModuleScope -ModuleName $dscModuleName {
                Mock -CommandName Test-Path -MockWith { $false }
                Mock -CommandName New-Item -MockWith { "" }
                Mock -CommandName Set-Content -MockWith { }

                Save-Resource -Config 'Config that is stored in the psm1 file' -Version '1.23.1101.1' -Workload 'Teams' -OutputPath 'C:\Temp' | Should -Invoke 'Set-Content' -Times 2
            }
        }
    }
}
