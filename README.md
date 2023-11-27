# M365DSC.CRG

M365DSC CRG = Microsoft365DSC Composite Resource Generator

This module will be able to generate Composite Resources for Microsoft365DSC, which can be used on Microsoft365DSC deployments. These Composite Resources are used in the Microsoft365DSC whitepaper ["Managing Microsoft 365 in true DevOps style with Microsoft365DSC and Azure DevOps"](https://aka.ms/m365dscwhitepaper).

## Installation

You can install this module from the PowerShell Gallery by executing the following command:

```powershell
Install-Module -Name M365DSC.CRG
```

## Usage

This module publishes one function called `New-CompositeResourceModule`. This function will generate a module that contains composite resources for each workload of Microsoft365DSC. The function requires one parameter `OutputPath`, which specifies the path where the module will be generated. The module will be named `M365DSC.CompositeResources`.

It also creates an example data file, which is included in the module. You can use the function `New-M365DSCExampleDataFile` to copy this file to a specific folder, where you can use it as a starting point of your own data file. It is recommended you use this file, since that already uses the correct naming conventions that the composite resources use.

### Important notes

The configuration data sometimes uses arrays of hashtables. In order to merge these items correctly, the code needs to know which items are the same. This is done by using the `Id` or `Identity` properties. When the specific DSC resource does not have one of these properties, the code will look for the `UniqueID` property. This property is removed from the hashtable before it is used in the composite resource.

Where DSC resources use singular names in the resource names, like `AADAdministrativeUnit`. However in the configuration data, these names are made plural, like `AADAdministrativeUnits`.

The code will implement each DSC resource found in Microsoft365DSC, but there are a few exceptions. The following resources are not implemented:

- Resources that do not support CertThumbprint. Currently these are O365SearchAndIntelligenceConfigurations, TeamsOrgWideAppSettings and TeamsUserCallingSettings.
- The M365DSCRuleEvaluation resource does not have an equivalent in Microsoft 365 but is used to evaluate compliancy rules.

## ToDo

- Update output logging
