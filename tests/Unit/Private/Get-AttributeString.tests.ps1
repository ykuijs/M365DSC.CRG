BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-AttributeString {
    Context 'When calling the function with string value' {
        It 'Should populate ConfigData with properties' {
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

                $property = @{
                    Name = 'Input'
                    EmbeddedInstance = 'MSFT_CRG_WebApp'
                    IsArray = $true
                }

                $script:maxDepth = 5
                $configData = @{}

                Get-AttributeString -Property $property -ConfigData $configData

                $configData.Input | Should -Not -Be $null
            }
        }

        It 'Should populate ConfigData with one property, including subclasses' {
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

                $property = @{
                    Name = 'Input'
                    EmbeddedInstance = 'MSFT_CRG_WebApp'
                    IsArray = $false
                }

                $script:maxDepth = 5
                $configData = @{}

                Get-AttributeString -Property $property -ConfigData $configData

                $configData.Input | Should -Not -Be $null
            }
        }
    }
}
