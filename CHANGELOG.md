# Changelog for M365DSC.CRG

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
