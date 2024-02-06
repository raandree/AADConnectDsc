@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'DscResource.Common.psm1'

    # Version number of this module.
    ModuleVersion     = '0.17.0'

    # ID used to uniquely identify this module
    GUID              = '9c9daa5b-5c00-472d-a588-c96e8e498450'

    # Author of this module
    Author            = 'DSC Community'

    # Company or vendor of this module
    CompanyName       = 'DSC Community'

    # Copyright statement for this module
    Copyright         = 'Copyright the DSC Community contributors. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Common functions used in DSC Resources'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '4.0'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = @('Assert-BoundParameter','Assert-ElevatedUser','Assert-IPAddress','Assert-Module','Compare-DscParameterState','Compare-ResourcePropertyState','ConvertFrom-DscResourceInstance','ConvertTo-CimInstance','ConvertTo-HashTable','Find-Certificate','Get-ComputerName','Get-DscProperty','Get-EnvironmentVariable','Get-LocalizedData','Get-LocalizedDataForInvariantCulture','Get-PSModulePath','Get-TemporaryFolder','New-ArgumentException','New-ErrorRecord','New-Exception','New-InvalidDataException','New-InvalidOperationException','New-InvalidResultException','New-NotImplementedException','New-ObjectNotFoundException','Remove-CommonParameter','Set-DscMachineRebootRequired','Set-PSModulePath','Test-AccountRequirePassword','Test-DscParameterState','Test-DscProperty','Test-IsNanoServer','Test-IsNumericType')

    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport   = @()

    # Variables to export from this module
    VariablesToExport = @()

    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport   = 'New-InvalidArgumentException'

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{

        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('DSC', 'Localization')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/dsccommunity/DscResource.Common/blob/main/LICENSE'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/dsccommunity/DscResource.Common'

            # A URL to an icon representing this module.
            IconUri      = 'https://dsccommunity.org/images/DSC_Logo_300p.png'

            # ReleaseNotes of this module
            ReleaseNotes = '## [0.17.0] - 2024-01-23

### Added

- Tasks for automating documentation for the GitHub repository wiki ([issue #110](https://github.com/dsccommunity/DscResource.Common/issues/110)).
- `Set-PSModulePath`
  - A new parameters set takes two parameters `FromTarget` and `ToTarget`
    that can copy from omne target to the other ([issue #102](https://github.com/dsccommunity/DscResource.Common/issues/102)).
  - A new parameter `PassThru` that, if specified, returns the path that
    was set.
- `New-Exception`
  - New command that creates and returns an `[System.Exception]`.
- `New-ErrorRecord`
  - New command that creates and returns an `[System.Management.Automation.ErrorRecord]`
    ([issue #99](https://github.com/dsccommunity/DscResource.Common/issues/99)).
- `New-ArgumentException`
  - Now takes a parameter `PassThru` that returns the error record that was
    created (and does not throw).
- `New-InvalidOperationException`
  - Now takes a parameter `PassThru` that returns the error record that was
    created (and does not throw) ([issue #98](https://github.com/dsccommunity/DscResource.Common/issues/98)).
- `New-InvalidResultException`
  - Now takes a parameter `PassThru` that returns the error record that was
    created (and does not throw).
- `New-NotImplementedException`
  - Now takes a parameter `PassThru` that returns the error record that was
    created (and does not throw).
- `Compare-DscParameterState`
  - Add support for the type `[System.Collections.Specialized.OrderedDictionary]`
    passed to parameters `CurrentValues` and `DesiredValues` ([issue #57](https://github.com/dsccommunity/DscResource.Common/issues/57)).
  - Add support for `DesiredValues` (and `CurrentValues`) to pass a value,
    e.g a hashtable, that includes a property with the type `[System.Collections.Specialized.OrderedDictionary]`
    or an array of `[System.Collections.Specialized.OrderedDictionary]` ([issue #57](https://github.com/dsccommunity/DscResource.Common/issues/57)).

### Changed

- Updated the pipelines files for resolving dependencies.
- Command documentation was moved from README to GitHub repository wiki.
- Change the word cmdlet to command throughout in the documentation, code
  and localization strings.
- A meta task now removes the built module from the session if it is imported.
- Wiki source file HOME was modified to not link to README for help after
  command documentation now is in the wiki.
- `Get-LocalizedData`
  - Refactored to simplify execution and debugging. The command previously
    used a steppable pipeline (proxies `Import-LocalizedData`), that was
    removed since it was not possible to use the command in a pipeline.
    It just made it more complex and harder to debug. There are more
    debug messages added to hopefully simplify solving some hard to find
    edge cases bugs.
- `New-ArgumentException`
  - Now has a command alias `New-InvalidArgumentException` and the command
    was renamed to match the exception name.
  - Now uses the new command `New-ErrorRecord`.
- `New-InvalidDataException`
  - The parameter `Message` has a parameter alias `ErrorMessage` to make
    the command have the same parameter names as the other `New-*Exception`
    commands.
  - Now uses the new command `New-ErrorRecord`.
- `New-InvalidOperationException`
  - Now uses the new command `New-ErrorRecord`.
- `New-InvalidResultException`
  - Now uses the new command `New-ErrorRecord`.
- `New-NotImplementedException`
  - Now uses the new command `New-ErrorRecord`.
- `New-ObjectNotFoundException`
  - Now uses the new command `New-ErrorRecord`.

### Fixed

- `Assert-BoundParameter`
  - Fixed example in documentation that were referencing an invalid command name.
- `Get-LocalizedData`
  - One debug message was wrongly using a format operator ([issue #111](https://github.com/dsccommunity/DscResource.Common/issues/111).
- `New-ObjectNotFoundException`
  - Updated typo in comment-based help.

'

            Prerelease   = ''
        } # End of PSData hashtable

    } # End of PrivateData hashtable
}
