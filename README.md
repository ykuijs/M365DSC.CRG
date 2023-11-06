# M365DSC.CRG

M365DSC CRG = Microsoft365DSC Composite Resource Generator

This module will be able to generate Composite Resources for Microsoft365DSC, which can be used on Microsoft365DSC deployments. These Composite Resources are used in the Microsoft365DSC whitepaper ["Managing Microsoft 365 in true DevOps style with Microsoft365DSC and Azure DevOps"](https://aka.ms/m365dscwhitepaper).

DOCUMENTATION!!
UniqueID -> Why is this added
How does it work
Plural vs Singular names
Create a CR for each workload

Exceptions:
Only resources with CertThumbprint (TeamsOrgWideAppSettings, O365SearchAndIntelligenceConfigurations, TeamsUserCallingSettings)
Filter M365DSCRuleEvaluation resource
