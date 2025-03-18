BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe ConvertTo-Psd {
    Context 'When calling the function with string value' {
        It 'Should return a string representation of the hashtable' {
            InModuleScope -ModuleName $dscModuleName {
                $configData = [ordered]@{
                    Value1 = 'String1'
                    Value2 = 25
                    Value3 = [ordered]@{
                        Value4 = 'String2'
                        Value5 = 50
                    }
                    Value6 = @(
                        [ordered]@{
                            Value7   = 'String3'
                            Value8 = 75
                        }
                    )
                }

                $compareString = [System.Text.StringBuilder]::new()
                [void]$compareString.AppendLine("@{")
                [void]$compareString.AppendLine("    Value1 = 'String1'")
                [void]$compareString.AppendLine("    Value2 = 25")
                [void]$compareString.AppendLine("    Value3 = @{")
                [void]$compareString.AppendLine("        Value4 = 'String2'")
                [void]$compareString.AppendLine("        Value5 = 50")
                [void]$compareString.AppendLine("    }")
                [void]$compareString.AppendLine("    Value6 = @(")
                [void]$compareString.AppendLine("        @{")
                [void]$compareString.AppendLine("            Value7 = 'String3'")
                [void]$compareString.AppendLine("            Value8 = 75")
                [void]$compareString.AppendLine("        }")
                [void]$compareString.AppendLine("    )")
                [void]$compareString.Append("}")

                ConvertTo-Psd -InputObject $configData | Should -Be $compareString.ToString()
            }
        }
    }
}
