# Contributing to AADConnectDsc

Thank you for your interest in contributing to AADConnectDsc! This project
follows the DSC Community standards and welcomes contributions from the
community.

## Getting Started

Please review the common DSC Community
[contributing guidelines](https://dsccommunity.org/guidelines/contributing)
which cover:

- Code of Conduct
- Contribution workflow
- Pull request process
- Code style and standards

## Development Environment

### Prerequisites

- **Windows PowerShell 5.1** (PowerShell 7 is NOT supported)
- Azure AD Connect installed and configured
- Git for version control
- Visual Studio Code (recommended) with PowerShell extension

### Setting Up Your Development Environment

1. Fork the repository
1. Clone your fork locally
1. Install required modules:

```powershell
# Install dependencies
.\build.ps1 -ResolveDependency -Tasks noop
```

## Running the Tests

### Quick Test Run

```powershell
# Run all tests
.\build.ps1 -Tasks test
```

### Continuous Testing

```powershell
# Run tests in watch mode during development
Invoke-Pester -Path .\tests -Watch
```

For detailed testing information, see the
[Testing Guidelines](https://dsccommunity.org/guidelines/testing-guidelines/#running-tests).

## Building the Module

```powershell
# Build the module
.\build.ps1 -Tasks build

# Clean and rebuild
.\build.ps1 -Tasks clean
.\build.ps1 -Tasks build
```

## Project-Specific Guidelines

### Documentation Requirements

All contributions must include appropriate documentation:

- **New Resources**: Add complete documentation in `docs/` following existing
  patterns
- **New Functions**: Include comment-based help with examples
- **Examples**: Add practical examples to `source/Examples/Resources/`
- **README Updates**: Update main README.md if adding new capabilities

### Code Standards

- Follow PowerShell best practices and DSC Community style guide
- Use class-based DSC resources for consistency
- Include Pester tests for all new functionality
- Ensure all tests pass before submitting PR

### Testing Requirements

- Unit tests required for all new functions and resources
- Integration tests recommended for complex scenarios
- All existing tests must continue to pass

## Useful Resources

- [Architecture Guide](docs/Architecture.md) - Understand the module structure
- [Best Practices](docs/BestPractices.md) - Configuration design patterns
- [Troubleshooting Guide](docs/Troubleshooting.md) - Common issues and
  solutions

## Questions or Issues?

- Check the [Troubleshooting Guide](docs/Troubleshooting.md) for common issues
- Review existing [issues](https://github.com/dsccommunity/AADConnectDsc/issues)
- Join the [DSC Community](https://dsccommunity.org/) for discussions
