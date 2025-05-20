@{
    AADConditionalAccessPolicy    = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.AzureAD.Group -or $null -ne $ConfigurationData.NonNodeData.AzureAD.User'
        DependsOnString = '@($ConfigurationData.NonNodeData.AzureAD.Group | Where-Object { $_ } | ForEach-Object { "[AADGroup]AADGroup-{0}-{1}" -f $_.DisplayName,$_.MailNickName }) + @($ConfigurationData.NonNodeData.AzureAD.User.UserPrincipalName | Where-Object { $_ } | ForEach-Object { "[AADUser]AADUser-{0}" -f $_ })'
    }
    SCAutoSensitivityLabelPolicy  = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabel'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabel.Name | ForEach-Object { "[SCSensitivityLabel]SCSensitivityLabel-{0}" -f $_ }'
    }
    SCAutoSensitivityLabelRule    = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.AutoSensitivityLabelPolicy'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.AutoSensitivityLabelPolicy.Name | ForEach-Object { "[SCAutoSensitivityLabelPolicy]SCAutoSensitivityLabelPolicy-{0}" -f $_ }'
    }
    SCCaseHoldRule                = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.CaseHoldPolicy'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.CaseHoldPolicy | ForEach-Object { "[SCCaseHoldPolicy]SCCaseHoldPolicy-{0}-{1}" -f $_.Name,$_.Case }'
    }
    SCCaseHoldPolicy              = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.ComplianceCase'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.ComplianceCase.Name | ForEach-Object { "[SCComplianceCase]SCComplianceCase-{0}" -f $_ }'
    }
    SCDLPComplianceRule           = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.DLPCompliancePolicy'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.DLPCompliancePolicy.Name | ForEach-Object { "[SCDLPCompliancePolicy]SCDLPCompliancePolicy-{0}" -f $_ }'
    }
    SCFilePlanPropertySubCategory = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.FilePlanPropertyCategory'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.FilePlanPropertyCategory.Name | ForEach-Object { "[SCFilePlanPropertyCategory]SCFilePlanPropertyCategory-{0}" -f $_ }'
    }
    SCLabelPolicy                 = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabel'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabel.Name | ForEach-Object { "[SCSensitivityLabel]SCSensitivityLabel-{0}" -f $_ }'
    }
    SCRetentionComplianceRule     = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.RetentionCompliancePolicy'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.RetentionCompliancePolicy.Name | ForEach-Object { "[SCRetentionCompliancePolicy]SCRetentionCompliancePolicy-{0}" -f $_ }'
    }
    SCSupervisoryReviewRule       = @{
        IfStatement = '$null -ne $ConfigurationData.NonNodeData.SecurityCompliance.SupervisoryReviewPolicy'
        DependsOnString = '$ConfigurationData.NonNodeData.SecurityCompliance.SupervisoryReviewPolicy.Name | ForEach-Object { "[SCSupervisoryReviewPolicy]SCSupervisoryReviewPolicy-{0}" -f $_ }'
    }
}
