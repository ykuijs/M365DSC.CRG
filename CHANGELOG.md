# Changelog for M365DSC.CRG

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
