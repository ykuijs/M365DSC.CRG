# Changelog for M365DSC.CRG

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.5] - 2023-11-13

### Fixed

- Corrected Sampler tasks to include required version parameter

## [0.1.4] - 2023-11-13

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
