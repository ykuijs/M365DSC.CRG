BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-EmbeddedPropertyString {
    Context 'When calling the function with string value' {
        It 'Should return a single object' {
            InModuleScope -ModuleName $dscModuleName {
                $mofSchemas = @(
                    @{
                        ClassName = 'MSFT_CRG_WebApp'
                        Attributes = @(
                            @{
                                Name = 'Id'
                                State = 'Key'
                                ValueMap = $null
                            }
                            @{
                                Name = 'Url'
                                State = 'Required'
                                ValueMap = $null
                                EmbeddedInstance = 'MSFT_CRG_WebApp2'
                            }
                            @{
                                Name = 'Ensure'
                                State = 'Write'
                                ValueMap = @( 'Present', 'Absent' )
                            }
                        )
                    }
                    @{
                        ClassName = 'MSFT_CRG_WebApp2'
                        Attributes = @(
                            @{
                                Name = 'Url'
                                State = 'Required'
                                ValueMap = $null
                            }
                        )
                    }
                )

                $properties = @(
                    @{
                        Name = 'Id'
                        EmbeddedInstance = 'MSFT_CRG_WebApp'
                    }
                )

                $compareString = [System.Text.StringBuilder]::new()
                [void]$compareString.AppendLine("if (`$parameter.ContainsKey('Id'))")
                [void]$compareString.AppendLine("{")
                [void]$compareString.AppendLine("    `$parameter.Id = `$parameter.Id | ForEach-Object {")
                [void]$compareString.AppendLine("        if (`$_.ContainsKey('Url'))")
                [void]$compareString.AppendLine("        {")
                [void]$compareString.AppendLine("            `$_.Url = `$_.Url | ForEach-Object {")
                [void]$compareString.AppendLine("                if (`$_.ContainsKey('UniqueId'))")
                [void]$compareString.AppendLine("                {")
                [void]$compareString.AppendLine("                    `$_.Remove('UniqueId')")
                [void]$compareString.AppendLine("                }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("                (Get-DscSplattedResource -ResourceName 'MSFT_CRG_WebApp2' -Properties `$_ -NoInvoke).Invoke(`$_)")
                [void]$compareString.AppendLine("            }")
                [void]$compareString.AppendLine("        }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("        if (`$_.ContainsKey('UniqueId'))")
                [void]$compareString.AppendLine("        {")
                [void]$compareString.AppendLine("            `$_.Remove('UniqueId')")
                [void]$compareString.AppendLine("        }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("        (Get-DscSplattedResource -ResourceName 'MSFT_CRG_WebApp' -Properties `$_ -NoInvoke).Invoke(`$_)")
                [void]$compareString.AppendLine("    }")
                [void]$compareString.AppendLine("}")
                [void]$compareString.AppendLine("")

                $script:maxDepth = 5
                $result = Get-EmbeddedPropertyString -Properties $properties -Indentation 0 -ParameterName '$parameter'
                $result | Should -Be $compareString.ToString()
            }
        }
    }
}
