@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'Sampler.psm1'

    # Version number of this module.
    ModuleVersion     = '0.117.0'

    # Supported PSEditions
    # CompatiblePSEditions = @('Desktop','Core') # Removed to support PS 5.0

    # ID used to uniquely identify this module
    GUID              = 'b59b8442-9cf9-4c4b-bc40-035336ace573'

    # Author of this module
    Author            = 'Gael Colas'

    # Company or vendor of this module
    CompanyName       = 'SynEdgy Limited'

    # Copyright statement for this module
    Copyright         = '(c) Gael Colas. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Sample Module with Pipeline scripts and its Plaster template to create a module following some of the community accepted practices.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        'Plaster'
    )

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules     = @()

    # Functions to export from this module
    FunctionsToExport = @('Add-Sample','Convert-SamplerHashtableToString','Get-BuildVersion','Get-BuiltModuleVersion','Get-ClassBasedResourceName','Get-CodeCoverageThreshold','Get-MofSchemaName','Get-OperatingSystemShortName','Get-PesterOutputFileFileName','Get-Psm1SchemaName','Get-SamplerAbsolutePath','Get-SamplerBuiltModuleBase','Get-SamplerBuiltModuleManifest','Get-SamplerCodeCoverageOutputFile','Get-SamplerCodeCoverageOutputFileEncoding','Get-SamplerModuleInfo','Get-SamplerModuleRootPath','Get-SamplerProjectName','Get-SamplerSourcePath','Invoke-SamplerGit','Merge-JaCoCoReport','New-SampleModule','New-SamplerJaCoCoDocument','New-SamplerPipeline','Out-SamplerXml','Set-SamplerPSModulePath','Split-ModuleVersion','Update-JaCoCoStatistic')

    # Cmdlets to export from this module
    CmdletsToExport   = ''

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport   = '*'

    # List of all modules packaged with this module
    ModuleList        = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
        PSData = @{
            # Extension for Plaster Template discoverability with `Get-PlasterTemplate -IncludeInstalledModules`
            Extensions   = @(
                @{
                    Module         = 'Plaster'
                    minimumVersion = '1.1.3'
                    Details        = @{
                        TemplatePaths = @(
                            'Templates\Classes'
                            'Templates\ClassResource'
                            'Templates\Composite'
                            'Templates\Enum'
                            'Templates\MofResource'
                            'Templates\PrivateFunction'
                            'Templates\PublicCallPrivateFunctions'
                            'Templates\PublicFunction'
                            'Templates\Sampler'
                        )
                    }
                }
            )

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Template', 'pipeline', 'plaster', 'DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource', 'Windows', 'MacOS', 'Linux')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/gaelcolas/Sampler/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/gaelcolas/Sampler'

            # A URL to an icon representing this module.
            IconUri      = 'https://raw.githubusercontent.com/gaelcolas/Sampler/main/Sampler/assets/sampler.png'

            # ReleaseNotes of this module
            ReleaseNotes = '## [0.117.0] - 2023-09-29

### Added

- Integration tests to build and import a module created using the Plaster
  template _SimpleModule_.
- Support [ModuleFast](https://github.com/JustinGrote/ModuleFast) when
  restoring dependencies by adding the parameter `UseModuleFast` to the
  `build.ps1`, e.g. `./build.ps1 -Tasks noop -ResolveDependency -UseModuleFast`
  or by enabling it in the configuration file Resolve-Dependency.psd1.
  Using ModuleFast will resolve dependencies much faster, but requires
  PowerShell 7.2.
- Support for [PSResourceGet (beta release)](https://github.com/PowerShell/PSResourceGet).
  If the modules PSResourceGet can be bootstrapped they will be used. If
  PSResourceGet cannot be bootstrapped then it will revert to using
  PowerShellGet v2.2.5. If the user requests or configures to use ModuleFast
  then that will override both PSResourceGet and PowerShellGet. The method
  PSResourceGet can be enabled in the configuration file Resolve-Dependency.psd1.
  It is also possible to use PSResourceGet by adding the parameter `UsePSResourceGet`
  to the `build.ps1`, e.g. `./build.ps1 -Tasks noop -ResolveDependency -UsePSResourceGet`.
- When using PSResourceGet to resolve dependencies it also possible to
  use PowerShellGet v2.9.0 (previous _CompatPowerShellGet_). To use the
  compatibility module it can be enabled in the configuration file Resolve-Dependency.psd1.
  It is also possible to use it by adding the parameter `UsePowerShellGetCompatibilityModule`
  to the `build.ps1`, e.g. `./build.ps1 -Tasks noop -ResolveDependency -UsePSResourceGet -UsePowerShellGetCompatibilityModule`.
  _The 2.9.0-preview has since then been unlisted, the compatibility_
  _module will now be released as PowerShellGet v3.0.0._

### Changed

- Task `publish_nupkg_to_gallery`
  - Add support for publishing a NuGet package to a gallery using the .NET SDK in addition to using nuget.exe. Fixes [#433](https://github.com/gaelcolas/Sampler/issues/433)
- Split up unit tests and integration tests in separate pipeline jobs since
  integration tests could change state on a developers machine, and in the
  current PowerShell session. Integration tests no longer run when running
  `./build.ps1 -Tasks test`. To run integration tests pass the parameter
  `PesterPath`, e.g. `./build.ps1 -Tasks test -PesterPath ''tests/Integration''`.
- Added sample private function and public function samples to Plaster template
  _SimpleModule_ so that it is possible to run task `test` without it failing.
- Sample Private function tests updated to Pester 5.
- Sample Public function tests updated to Pester 5.
- Sampler''s build.ps1 and the template build.ps1 was aligned.
- PowerShell Team will release the PSResourceGet compatibility module
  (previously known as CompatPowerShellGet) as PowerShellGet v2.9.0 (or
  higher). The resolve dependency script, when PowerShellGet is used, will
  use `MaximumVersion` set to `2.8.999` to make sure the expected
  PowerShellGet version is installed, today that it is v2.2.5.
  _The 2.9.0-preview has since then been unlisted, the compatibility_
  _module will now be released as PowerShellGet v3.0.0._

### Fixed

- Fix unit tests that was wrongly written and failed on Pester 5.5.
- There was different behavior on PowerShell and Windows PowerShell when
  creating the module manifest. So when the `modify` section that was meant
  to reuse the already present but commented `Prerelease` key it also ran
  the `modify` statement that adds a `Prerelease` key that is needed for
  a module manifest that is created under Windows PowerShell. This resulted
  in two `Prerelease` keys when creating a module under PowerShell 7.x.
  Now it will add a commented `Perelease` key and then next `modify` statement
  will remove the comment, making it work on all version of PowerShell.
  Fixes [#436](https://github.com/gaelcolas/Sampler/issues/436).
- The QA test template was updated so that it is possible to run the tests
  without the need to add a git remote (remote `origin`).

'

            Prerelease   = ''
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}
