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
                $definitions = @(
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
                [void]$compareString.AppendLine("    `$parameter.Id = `$parameter.Id | Where-Object { `$null -ne `$_ } | ForEach-Object {")
                [void]$compareString.AppendLine("        if (`$_.ContainsKey('Url'))")
                [void]$compareString.AppendLine("        {")
                [void]$compareString.AppendLine("            `$_.Url = `$_.Url | Where-Object { `$null -ne `$_ } | ForEach-Object {")
                [void]$compareString.AppendLine("                if (`$_.ContainsKey('UniqueId'))")
                [void]$compareString.AppendLine("                {")
                [void]$compareString.AppendLine("                    `$_.Remove('UniqueId')")
                [void]$compareString.AppendLine("                }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("                if (`$_.Count -gt 0)")
                [void]$compareString.AppendLine("                {")
                [void]$compareString.AppendLine("                    (Get-DscSplattedResource -ResourceName 'MSFT_CRG_WebApp2' -Properties `$_ -NoInvoke).Invoke(`$_)")
                [void]$compareString.AppendLine("                }")
                [void]$compareString.AppendLine("            }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("            if (`$null -eq `$_.Url -or @(`$_.Url).Count -eq 0)")
                [void]$compareString.AppendLine("            {")
                [void]$compareString.AppendLine("                `$_.Remove('Url')")
                [void]$compareString.AppendLine("            }")
                [void]$compareString.AppendLine("        }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("        if (`$_.ContainsKey('UniqueId'))")
                [void]$compareString.AppendLine("        {")
                [void]$compareString.AppendLine("            `$_.Remove('UniqueId')")
                [void]$compareString.AppendLine("        }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("        if (`$_.Count -gt 0)")
                [void]$compareString.AppendLine("        {")
                [void]$compareString.AppendLine("            (Get-DscSplattedResource -ResourceName 'MSFT_CRG_WebApp' -Properties `$_ -NoInvoke).Invoke(`$_)")
                [void]$compareString.AppendLine("        }")
                [void]$compareString.AppendLine("    }")
                [void]$compareString.AppendLine("")
                [void]$compareString.AppendLine("    if (`$null -eq `$parameter.Id -or @(`$parameter.Id).Count -eq 0)")
                [void]$compareString.AppendLine("    {")
                [void]$compareString.AppendLine("        `$parameter.Remove('Id')")
                [void]$compareString.AppendLine("    }")
                [void]$compareString.AppendLine("}")
                [void]$compareString.AppendLine("")

                $script:maxDepth = 5
                $schemas = @{}
                foreach ($definition in $definitions)
                {
                    $schemas[$definition.ClassName] = $definition
                }
                $result = Get-EmbeddedPropertyString -Properties $properties -Schemas $schemas -Indentation 0 -ParameterName '$parameter'
                $result | Should -Be $compareString.ToString()
            }
        }

        It 'Removes null and empty complex values without invoking an embedded resource' {
            InModuleScope -ModuleName $dscModuleName {
                $schemas = @{
                    MSFT_Child = @{ Attributes = @(@{ Name = 'Value'; State = 'Write' }) }
                }
                $properties = @(
                    @{ Name = 'NullValue'; EmbeddedInstance = 'MSFT_Child' }
                    @{ Name = 'EmptyArray'; EmbeddedInstance = 'MSFT_Child'; IsArray = $true }
                    @{ Name = 'EmptyObject'; EmbeddedInstance = 'MSFT_Child' }
                    @{ Name = 'NullEntries'; EmbeddedInstance = 'MSFT_Child'; IsArray = $true }
                )
                $parameter = @{
                    NullValue = $null
                    EmptyArray = @()
                    EmptyObject = @{}
                    NullEntries = @($null, $null)
                }
                $script:currentDepth = 0
                $script:maxDepth = 8
                $code = Get-EmbeddedPropertyString -Properties $properties -Schemas $schemas -Indentation 0 -ParameterName '$parameter'
                & ([scriptblock]::Create($code))
                $parameter.Count | Should -Be 0
                $script:currentDepth | Should -Be 0
            }
        }
    }
}
