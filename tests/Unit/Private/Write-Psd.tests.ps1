BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Write-Psd {
    Context 'When calling the function with string value' {
        It 'Should return a single object' {
            InModuleScope -ModuleName $dscModuleName {
                $configData = @{
                    Value1 = 'String1'
                    Value2 = 25
                    Value3 = @{
                        Value4 = 'String2'
                        Value5 = 50
                    }
                    Value6 = @(
                        @{
                            Value7   = 'String3'
                            Value8   = 75
                            Value9   = [Guid]'67e38349-8278-4968-a77e-81f810d33172'
                            Value10  = [Uri]'www.contoso.com'
                            Value_11 = 'String4'
                            Value12  = 100
                            Value13  = 1GB
                        }
                    )
                    Value20 = [DateTime]'1/1/2024'
                    Value21 = $true
                }

                $compareString = [System.Text.StringBuilder]::new()
                [void]$compareString.AppendLine("@{")
                [void]$compareString.AppendLine("    Value21 = `$true")
                [void]$compareString.AppendLine("    Value20 = [DateTime] '2024-01-01T00:00:00.0000000'")
                [void]$compareString.AppendLine("    Value2 = 25")
                [void]$compareString.AppendLine("    Value3 = @{")
                [void]$compareString.AppendLine("        Value5 = 50")
                [void]$compareString.AppendLine("        Value4 = 'String2'")
                [void]$compareString.AppendLine("    }")
                [void]$compareString.AppendLine("    Value6 = @(")
                [void]$compareString.AppendLine("        @{")
                [void]$compareString.AppendLine("            Value_11 = 'String4'")
                [void]$compareString.AppendLine("            Value7 = 'String3'")
                [void]$compareString.AppendLine("            Value10 = 'www.contoso.com'")
                [void]$compareString.AppendLine("            Value8 = 75")
                [void]$compareString.AppendLine("            Value12 = 100")
                [void]$compareString.AppendLine("            Value13 = 1073741824")
                [void]$compareString.AppendLine("        }")
                [void]$compareString.AppendLine("    )")
                [void]$compareString.AppendLine("    Value1 = 'String1'")
                [void]$compareString.AppendLine("}")

                $script:Depth = $Depth
                $script:Pruned = 0
                $script:Indent = Convert-Indent -Indent $Indent
                $script:Writer = New-Object System.IO.StringWriter

                Write-Psd -Object $configData
                $script:Writer | Should -Be $compareString.ToString()

                $script:Writer = $null
            }
        }
    }
}
