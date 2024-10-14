# Changelog for AADConnectDsc

The format is based on and uses the types of changes according to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- Fixed multiple bugs in the ADSyncRule class effected the comparing of objects.
- Fixed dealing with standard rules.

## [0.3.0] - 2024-08-07

### Fixed

- Add check for empty 'Expression' as it is a key and does not allow $null.
- Add check for empty 'Source' as it is a key and does not allow $null.
- Added error handling for non-existing standard rule.
- Set version of GitVersion to 5.*.

## [0.2.2] - 2024-07-05

### Changed

- AttributeFlowMapping:
  - Expression a key property again, otherwise complex rule sets
    are resulting in conflicts.

## [0.2.1] - 2024-07-04

### Changed

- AttributeFlowMapping:
  - Expression is no longer key

### Fixed

- Aligned build task.

## [0.2.0] - 2024-06-10

### Added

Initial Release
