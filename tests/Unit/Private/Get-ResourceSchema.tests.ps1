BeforeAll {
    Import-Module -Name M365DSC.CRG
}

AfterAll {
    Remove-Module -Name M365DSC.CRG -Force
}

Describe Get-ResourceSchema {
    BeforeEach {
        Copy-Item -LiteralPath "$PSScriptRoot\..\..\Fixtures\SchemaDefinition.json" -Destination $TestDrive
        Set-Content -LiteralPath "$TestDrive\Microsoft365DSC.psd1" -Value "@{ DscResourcesToExport = @('TeamsTest', 'AADTest') }"
    }

    It 'Normalizes resources and shared complex types into a case-insensitive hashtable' {
        InModuleScope M365DSC.CRG {
            $schemas = Get-ResourceSchema -ModulePath $TestDrive
            $schemas | Should -BeOfType [hashtable]
            $schemas.Count | Should -Be 4
            $schemas['msft_aadtest'].FriendlyName | Should -Be 'AADTest'
            $schemas.MSFT_Child.FriendlyName | Should -BeNullOrEmpty
            $schemas.Values.Where({ $null -ne $_.FriendlyName }).Count | Should -Be 2

            $properties = $schemas.MSFT_AADTest.Attributes
            $properties[0] | Should -BeOfType [hashtable]
            $properties[0].State | Should -Be 'Key'
            $properties[0].DataType | Should -Be 'String'
            $properties[0].IsArray | Should -BeFalse
            $properties[0].EmbeddedInstance | Should -BeNullOrEmpty
            $properties[1].DataType | Should -Be 'StringArray'
            $properties[1].IsArray | Should -BeTrue
            $properties[2].DataType | Should -Be 'InstanceArray'
            $properties[2].EmbeddedInstance | Should -Be 'MSFT_Child'
            $properties[3].DataType | Should -Be 'Instance'
            $properties[3].IsArray | Should -BeFalse
            $properties[4].EmbeddedInstance | Should -Be 'MSFT_Credential'
            $properties[5].DataType | Should -Be 'InstanceArray'
            $schemas.MSFT_Child.Attributes[0].ValueMap | Should -Be @('One', 'Two')
        }
    }

    It 'Reads a JSON array containing only one definition' {
        $definition = @{ ClassName = 'MSFT_AADTest'; Parameters = @(@{ Name = 'Id'; CIMType = 'String'; Option = 'Key' }) }
        Set-Content -LiteralPath "$TestDrive\SchemaDefinition.json" -Value (ConvertTo-Json -InputObject @($definition) -Depth 5)
        Set-Content -LiteralPath "$TestDrive\Microsoft365DSC.psd1" -Value "@{ DscResourcesToExport = @('AADTest') }"
        InModuleScope M365DSC.CRG {
            (Get-ResourceSchema -ModulePath $TestDrive).Count | Should -Be 1
        }
    }

    It 'Rejects MOF-only modules with an explicit compatibility error' {
        Remove-Item -LiteralPath "$TestDrive\SchemaDefinition.json"
        InModuleScope M365DSC.CRG {
            { Get-ResourceSchema -ModulePath $TestDrive } | Should -Throw '*Only JSON/class-based*'
        }
    }

    It 'Rejects invalid JSON or root shape: <Content>' -TestCases @(
        @{ Content = '{'; Message = '*Failed to read resource metadata*' }
        @{ Content = '[]'; Message = '*non-empty JSON array*' }
        @{ Content = '{}'; Message = '*non-empty JSON array*' }
        @{ Content = ' '; Message = '*non-empty JSON array*' }
    ) {
        param($Content, $Message)
        Set-Content -LiteralPath "$TestDrive\SchemaDefinition.json" -Value $Content
        InModuleScope M365DSC.CRG -Parameters @{ Message = $Message } {
            { Get-ResourceSchema -ModulePath $TestDrive } | Should -Throw $Message
        }
    }

    It 'Rejects invalid metadata: <Case>' -TestCases @(
        @{ Case = 'DuplicateClass'; Message = '*Duplicate class*' }
        @{ Case = 'InvalidClass'; Message = '*Invalid class name*' }
        @{ Case = 'MissingParameters'; Message = '*Parameters array*' }
        @{ Case = 'DuplicateProperty'; Message = '*Duplicate property*' }
        @{ Case = 'InvalidProperty'; Message = '*Invalid property name*' }
        @{ Case = 'InvalidOption'; Message = '*Unsupported option*' }
        @{ Case = 'MissingType'; Message = '*Missing CIMType*' }
        @{ Case = 'UnsupportedType'; Message = '*Unsupported CIMType*' }
        @{ Case = 'MissingComplexType'; Message = '*Complex type*is not defined*' }
        @{ Case = 'InvalidValueMap'; Message = '*ValueMap*must be an array*' }
        @{ Case = 'MissingResource'; Message = '*has no definition*' }
        @{ Case = 'MissingKey'; Message = '*has no key property*' }
        @{ Case = 'EmptyExports'; Message = '*No DSC resources are exported*' }
    ) {
        param($Case, $Message)
        $definitions = Get-Content -LiteralPath "$TestDrive\SchemaDefinition.json" -Raw | ConvertFrom-Json
        switch ($Case)
        {
            'DuplicateClass' { $definitions += $definitions[0] }
            'InvalidClass' { $definitions[0].ClassName = 'Invalid' }
            'MissingParameters' { $definitions[0].Parameters = $null }
            'DuplicateProperty' { $definitions[0].Parameters += $definitions[0].Parameters[0] }
            'InvalidProperty' { $definitions[0].Parameters[0].Name = 'Invalid-Name' }
            'InvalidOption' { $definitions[0].Parameters[0].Option = 'Unknown' }
            'MissingType' { $definitions[0].Parameters[0].CIMType = $null }
            'UnsupportedType' { $definitions[0].Parameters[0].CIMType = 'Object' }
            'MissingComplexType' { $definitions[0].Parameters[0].CIMType = 'MSFT_Missing' }
            'InvalidValueMap' { $definitions[0].Parameters[0].ValueMap = 'Global' }
            'MissingResource' { $definitions = @($definitions | Where-Object ClassName -ne 'MSFT_TeamsTest') }
            'MissingKey' { $definitions[0].Parameters[0].Option = 'Write' }
            'EmptyExports' { Set-Content -LiteralPath "$TestDrive\Microsoft365DSC.psd1" -Value '@{ DscResourcesToExport = @() }' }
        }
        Set-Content -LiteralPath "$TestDrive\SchemaDefinition.json" -Value (ConvertTo-Json -InputObject @($definitions) -Depth 10)
        InModuleScope M365DSC.CRG -Parameters @{ Message = $Message } {
            { Get-ResourceSchema -ModulePath $TestDrive } | Should -Throw $Message
        }
    }

    It 'Preserves scalar, array, credential, and nested example-data shapes' {
        InModuleScope M365DSC.CRG {
            $schemas = Get-ResourceSchema -ModulePath $TestDrive
            $script:currentDepth = 0
            $script:maxDepth = 8
            $configData = @{}
            foreach ($property in $schemas.MSFT_AADTest.Attributes.Where({ $_.Name -in @('Child', 'Children') }))
            {
                Get-AttributeString -Property $property -Schemas $schemas -ConfigData $configData
            }
            $configData.Child | Should -BeOfType [hashtable]
            $configData.Children -is [array] | Should -BeTrue
            $configData.Children[0].UniqueId | Should -Not -BeNullOrEmpty
            $configData.Child.ContainsKey('UniqueId') | Should -BeFalse
            $configData.Child.Name | Should -Be 'String | Required | Child name | One / Two'
            $configData.Child.Numbers -is [array] | Should -BeTrue
            $configData.Child.Credential | Should -Be 'PSCredential | Required | Child credential'
            $configData.Child.Nested.Value | Should -Be 'SInt32 | Optional | Leaf value'
            $script:currentDepth | Should -Be 0
        }
    }
}
