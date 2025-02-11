# Changelog for M365DSC.CRG

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.27] - 2025-02-11

### Added

- Added support for new Commerce workload

### Fixed

- Fixed issue where dependencies contained @-sign, which is not allowed.
  Replaced these with an underscore.

## [0.1.26] - 2025-01-29

### Fixed

- Fixed incorrect dependency naming for AADConditionalAccessPolicy
- Fixed incorrect conversion to string instead of array of dependencies

## [0.1.25] - 2025-01-28

### Fixed

- Corrected dependency naming from AAD to AzureAD

## [0.1.24] - 2025-01-28

### Added

- Added possibility to add multiple dependencies.
- Added dependency on AADGroups and AADUsers for AADConditionalAccessPolicy

### Fixed

- Fixed issue where dependencies were not determined properly when the data did
  not contain the resource it depended on.

## [0.1.23] - 2024-11-07

### Fixed

- Fixed an issue where PSCredential objects in an embedded property were
  not processed correctly, resulting in an empty hashtable in the example
  data file.

## [0.1.22] - 2024-10-15

### Added

- Added support for the new workloads to the AppCredentials parameter

## [0.1.20] - 2024-10-04

### Added

- Added the SettingDefinitionId parameter to the mergeable parameters, so that UniqueId
  is not required in those instances.
- Added support for the new Azure, Azure DevOps and Defender workloads

## [0.1.19] - 2024-09-18

### Added

- Added support for the new Sentinel workload

## [0.1.18] - 2024-09-09

### Added

- Added support for the new Fabric workload

## [0.1.17] - 2024-07-09

### Fixed

- Fixed issue were the new Workloads section was not created correctly

## [0.1.16] - 2024-07-03

### Added

- Added the UsedWorkloads section to the Environments section in the Example Data File
- Added a dependency to the SCSensitivityLabel resources for SCAutoSensitivityLabelPolicy

### Fixed

- Fixed issue were an array was not correctly created where this was required

## [0.1.15] - 2024-06-04

### Changed

- Updated StringArray data type into an actual array with string values in the ExampleDataFile
- Changed the MaxDepth from 5 to 8, so resources are generated on a lower level

## [0.1.14] - 2024-03-26

- Added CICD parameter under the Environment branch in the Example data

## [0.1.13] - 2024-01-10

- Fixed issue where the UniqueId parameter was added incorrectly for resources that had the IsSingleInstance parameter

## [0.1.12] - 2024-01-02

### Added

- Added parameter description to the example datafile generation.

### Changed

- Updated the NonNodeData\AppCredentials and Environment values to type definitions, in order to allow validation code to work consistently.

### Fixed

- Fixed RuleEvaluation filter bug that added incorrect data to the example datafile.

## [0.1.11] - 2023-11-29

### Changed

- Removed DscBuildHelpers module from ExternalModuleDependencies parameter in the module manifest

## [0.1.10] - 2023-11-28

### Changed

- Changed AAD resource name to AzureAD

## [0.1.9] - 2023-11-27

### Fixed

- Fixed type in module manifest generation that resulted in an invalid manifest

## [0.1.8] - 2023-11-27

### Fixed

- Fixed bug in example database generation that was caused by new versioning convention of the Composite Resources module

## [0.1.7] - 2023-11-27

### Fixed

- Fixed bug in module generation that was caused by new versioning convention of the Composite Resources module
- Fixed bug in unit test that was caused by new versioning convention of the Composite Resources module

## [0.1.6] - 2023-11-27

### Fixed

- Added summary of encountered issues during compilation
- Removed detection and installation of M365DSC, has to be done before running the task
- Updated logic to incorporate new version convention of the Composite Resources module

## [0.1.5] - 2023-11-13

### Changed

- Added check if the required Microsoft365DSC version is already installed, before trying to install it.

## [0.1.3] - 2023-11-13

### Added

- Added documentation to the Readme
- Extended the module manifest with the additional information
- Moved the example data file inside the module folder, so it will be ioported with the module

## [0.1.2] - 2023-11-07

### Added

- Added Composite Resource generator code
- Added Sampler task, to use the CRG in a pipeline
