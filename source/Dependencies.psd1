@{
    AADConditionalAccessPolicy    = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.AzureAD.Groups -or $null -ne $ConfigurationData.NonNodeData.AzureAD.Users'
        DependsOnString = '($ConfigurationData.NonNodeData.AzureAD.Groups | Where-Object { $_ } | ForEach-Object { "[AADGroup]AADGroup-{0}-{1}" -f $_.DisplayName,$_.MailNickName }) + ($ConfigurationData.NonNodeData.AzureAD.Users.UserPrincipalName | Where-Object { $_ } | ForEach-Object { "[AADUser]AADUser-{0}" -f $_ })'
    }
    SCAutoSensitivityLabelPolicy  = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabels'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabels.Name | ForEach-Object { "[SCSensitivityLabel]SCSensitivityLabel-{0}" -f $_ }'
    }
    SCAutoSensitivityLabelRule    = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.AutoSensitivityLabelPolicies'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.AutoSensitivityLabelPolicies.Name | ForEach-Object { "[SCAutoSensitivityLabelPolicy]SCAutoSensitivityLabelPolicy-{0}" -f $_ }'
    }
    SCCaseHoldRule                = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.CaseHoldPolicies'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.CaseHoldPolicies | ForEach-Object { "[SCCaseHoldPolicy]SCCaseHoldPolicy-{0}-{1}" -f $_.Name,$_.Case }'
    }
    SCCaseHoldPolicy              = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.ComplianceCases'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.ComplianceCases.Name | ForEach-Object { "[SCComplianceCase]SCComplianceCase-{0}" -f $_ }'
    }
    SCDLPComplianceRule           = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.DLPCompliancePolicies'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.DLPCompliancePolicies.Name | ForEach-Object { "[SCDLPCompliancePolicy]SCDLPCompliancePolicy-{0}" -f $_ }'
    }
    SCFilePlanPropertySubCategory = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.FilePlanPropertyCategories'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.FilePlanPropertyCategories.Name | ForEach-Object { "[SCFilePlanPropertyCategory]SCFilePlanPropertyCategory-{0}" -f $_ }'
    }
    SCLabelPolicy                 = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabels'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabels.Name | ForEach-Object { "[SCSensitivityLabel]SCSensitivityLabel-{0}" -f $_ }'
    }
    SCRetentionComplianceRule     = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.RetentionCompliancePolicies'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.RetentionCompliancePolicies.Name | ForEach-Object { "[SCRetentionCompliancePolicy]SCRetentionCompliancePolicy-{0}" -f $_ }'
    }
    SCSupervisoryReviewRule       = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.SupervisoryReviewPolicies'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.SupervisoryReviewPolicies.Name | ForEach-Object { "[SCSupervisoryReviewPolicy]SCSupervisoryReviewPolicy-{0}" -f $_ }'
    }
}
