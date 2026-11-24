# M365DSC.CRG

![Build Status](https://img.shields.io/github/actions/workflow/status/ykuijs/M365DSC.CRG/ModuleBuildTestRelease.yml)
[![PowerShell Gallery (with prereleases)](https://img.shields.io/powershellgallery/v/M365DSC.CRG.svg?include_prereleases&label=M365DSC.CRG%20Preview)](https://www.powershellgallery.com/packages/M365DSC.CRG)
[![PowerShell Gallery](https://img.shields.io/powershellgallery/v/M365DSC.CRG.svg?&label=M365DSC.CRG)](https://www.powershellgallery.com/packages/M365DSC.CRG)
![PowerShell Gallery Downloads](https://img.shields.io/powershellgallery/dt/M365DSC.CRG)

M365DSC CRG = Microsoft365DSC Composite Resource Generator

This module will be able to generate Composite Resources for Microsoft365DSC, which can be used on Microsoft365DSC deployments. These Composite Resources are used in the Microsoft365DSC whitepaper ["Managing Microsoft 365 in true DevOps style with Microsoft365DSC and Azure DevOps"](https://aka.ms/m365dscwhitepaper).

## Installation

You can install this module from the PowerShell Gallery by executing the following command:

```powershell
Install-Module -Name M365DSC.CRG
```

### Requirements

- Windows PowerShell 5.1 for generating and compiling DSC configurations.
- A class-based Microsoft365DSC release that includes `SchemaDefinition.json` and
  explicitly lists its resources in the module manifest's `DscResourcesToExport`.
  Generation and nested-property compilation have been validated with version
  `2.26.1007.1`.
- DscBuildHelpers 0.2.1 or later when compiling the generated composite resources.

MOF-only Microsoft365DSC releases are no longer supported. The generator reads
metadata from the selected installed module version, without importing its resource
classes for discovery. Missing or invalid JSON metadata causes a terminating error
before the output module is initialized.

## Usage

This module publishes one function called `New-CompositeResourceModule`. This function will generate a module that contains composite resources for each workload of Microsoft365DSC. The function requires one parameter `OutputPath`, which specifies the path where the module will be generated. The module will be named `M365DSC.CompositeResources`.

It also creates an example data file, which is included in the module. You can use the function `New-M365DSCExampleDataFile` to copy this file to a specific folder, where you can use it as a starting point of your own data file. It is recommended you use this file, since that already uses the correct naming conventions that the composite resources use.

For Microsoft365DSC `2.26.1007.1`, for example:

```powershell
New-CompositeResourceModule -OutputPath 'C:\GeneratedModules' -Version '2.26.1007.100'
```

The generated workload resources remain DSC composites (`.schema.psm1`). They import
the selected version of the class-based Microsoft365DSC resources and preserve nested
configuration-data hashtables and arrays; consumers do not need to replace these with
class constructors.

### Important notes

The configuration data sometimes uses arrays of hashtables. In order to merge these items correctly, the code needs to know which items are the same. This is done by using the `Id`, `Identity` or `SettingDefinitionId` properties. When the specific DSC resource does not have one of these properties, the code will look for the `UniqueID` property. This property is removed from the hashtable before it is used in the composite resource.

Where DSC resources use singular names in the resource names, like `AADAdministrativeUnit`. However in the configuration data, these names are made plural, like `AADAdministrativeUnits`.

The code will implement each DSC resource found in Microsoft365DSC, but there are a few exceptions. The following resources are not implemented:

- Resources that do not support CertificateThumbprint. In Microsoft365DSC
  `2.26.1007.1`, these are IntuneDeviceEnrollmentScopeConfigurationMam and
  IntuneDeviceEnrollmentScopeConfigurationMdm.
- The M365DSC-prefixed rule-evaluation resources, which do not configure Microsoft 365
  settings directly. In `2.26.1007.1`, these are M365DSCRuleEvaluation and
  M365DSCGraphAPIRuleEvaluation.

## Development and validation

Build and run unit/quality tests with the repository's existing build workflow:

```powershell
.\build.ps1 -Tasks build
.\build.ps1 -Tasks test
```

The class-resource integration tests are opt-in and require an installed
Microsoft365DSC release and DscBuildHelpers. Run them in a fresh Windows PowerShell
5.1 process after building the module:

```powershell
$env:M365DSC_CRG_INTEGRATION_VERSION = '2.26.1007.1'
.\build.ps1 -Tasks test -PesterScript '.\tests\Integration' -CodeCoverageThreshold 0
```

These tests generate the composite module and compile a representative configuration
containing complex arrays and deeply nested properties. They do not apply a
configuration or connect to a Microsoft 365 tenant.

## ToDo

- Update output logging
