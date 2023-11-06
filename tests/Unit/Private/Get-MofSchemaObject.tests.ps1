BeforeAll {
    $script:dscModuleName = 'M365DSC.CRG'

    Import-Module -Name $script:dscModuleName
}

AfterAll {
    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe Get-MofSchemaObject {
    Context 'When calling the function with string value' {
        BeforeAll {
            $script:className = 'MSFT_MofHelperTest'
            $script:fileName = '{0}.schema.mof' -f $script:ClassName
            $script:tempFileName = '{0}.tmp' -f $script:fileName
            $script:filePath = Join-Path -Path $TestDrive -ChildPath $script:fileName
            $script:tempFilePath = Join-Path -Path $TestDrive -ChildPath $script:tempFileName

            $script:fileContent = @"
[ClassVersion("1.0.0"), FriendlyName("MofHelperTest")]
class MSFT_MofHelperTest : OMI_BaseResource
{
    [Key,      Description("Test key string property")] String Name;
    [Required, Description("Test required property"), ValueMap{"Present","Absent"}, Values{"Present","Absent"}] String Needed;
    [Write,    Description("Test writeable string array")] String MultipleValues[];
    [Write,    Description("Test writeable boolean")] Boolean Switch;
    [Write,    Description("Test writeable datetime")] DateTime ExecuteOn;
    [Write,    Description("Test credential"), EmbeddedInstance("MSFT_Credential")] String Credential;
    [Read,     Description("Test readonly integer")] Uint32 NoWrite;
};
"@
            Set-Content -Path $script:filePath -Value $script:fileContent

            Mock -CommandName Resolve-Path -MockWith {
                [PSCustomObject]@{
                    Path = $script:filePath
                }
            } -ParameterFilter {$Path -eq $script:fileName}

            Mock -CommandName Join-Path -MockWith {
                $script:tempFilePath
            }
        }

        It 'Should return a single object' {
            InModuleScope -ModuleName $dscModuleName {
                $script:className = 'MSFT_MofHelperTest'
                $script:fileName = '{0}.schema.mof' -f $script:ClassName
                $script:filePath = Join-Path -Path $TestDrive -ChildPath $script:fileName

                { Get-MofSchemaObject -FileName $script:filePath -Verbose } | Should -Not -Throw

                # $schema = Get-MofSchemaObject -FileName $script:filePath -Verbose

                # It "Should import class with ClassName $script:className" {
                #     $schema.ClassName | Should -Be $script:className
                # }

                # It 'Should get class version' {
                #     $schema.ClassVersion | Should -Be '1.0.0'
                # }

                # It 'Should get class FriendlyName' {
                #     $schema.FriendlyName | Should -Be 'MofHelperTest'
                # }
            }
        }
    }
}
