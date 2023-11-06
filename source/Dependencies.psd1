@{
    SCAutoSensitivityLabelRule    = '$ConfigurationData.NonNodeData.SecurityCompliance.AutoSensitivityLabelPolicies.Name | ForEach-Object { "[SCAutoSensitivityLabelPolicy]SCAutoSensitivityLabelPolicy-{0}" -f $_ }'
    SCCaseHoldRule                = '$ConfigurationData.NonNodeData.SecurityCompliance.CaseHoldPolicies | ForEach-Object { "[SCCaseHoldPolicy]SCCaseHoldPolicy-{0}-{1}" -f $_.Name,$_.Case }'
    SCCaseHoldPolicy              = '$ConfigurationData.NonNodeData.SecurityCompliance.ComplianceCases.Name | ForEach-Object { "[SCComplianceCase]SCComplianceCase-{0}" -f $_ }'
    SCDLPComplianceRule           = '$ConfigurationData.NonNodeData.SecurityCompliance.DLPCompliancePolicies.Name | ForEach-Object { "[SCDLPCompliancePolicy]SCDLPCompliancePolicy-{0}" -f $_ }'
    SCFilePlanPropertySubCategory = '$ConfigurationData.NonNodeData.SecurityCompliance.FilePlanPropertyCategories.Name | ForEach-Object { "[SCFilePlanPropertyCategory]SCFilePlanPropertyCategory-{0}" -f $_ }'
    SCLabelPolicy                 = '$ConfigurationData.NonNodeData.SecurityCompliance.SensitivityLabels.Name | ForEach-Object { "[SCSensitivityLabel]SCSensitivityLabel-{0}" -f $_ }'
    SCRetentionComplianceRule     = '$ConfigurationData.NonNodeData.SecurityCompliance.RetentionCompliancePolicies.Name | ForEach-Object { "[SCRetentionCompliancePolicy]SCRetentionCompliancePolicy-{0}" -f $_ }'
    SCSupervisoryReviewRule       = '$ConfigurationData.NonNodeData.SecurityCompliance.SupervisoryReviewPolicies.Name | ForEach-Object { "[SCSupervisoryReviewPolicy]SCSupervisoryReviewPolicy-{0}" -f $_ }'
}
