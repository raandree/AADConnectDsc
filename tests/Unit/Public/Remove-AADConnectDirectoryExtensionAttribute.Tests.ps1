BeforeDiscovery {
    try
    {
        if (-not (Get-Module -Name 'DscResource.Test'))
        {
            # Assumes dependencies has been resolved, so if this module is not available, run 'noop' task.
            if (-not (Get-Module -Name 'DscResource.Test' -ListAvailable))
            {
                # Redirect all streams to $null, except the error stream (stream 2)
                & "$PSScriptRoot/../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
            }

            # If the dependencies has not been resolved, this will throw an error.
            Import-Module -Name 'DscResource.Test' -Force -ErrorAction 'Stop'
        }
    }
    catch [System.IO.FileNotFoundException]
    {
        throw 'DscResource.Test module dependency not found. Please run ".\build.ps1 -ResolveDependency -Tasks build" first.'
    }
}

BeforeAll {
    $script:dscModuleName = 'AADConnectDsc'

    $script:moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $PSScriptRoot))
    $script:moduleManifest = Join-Path -Path $script:moduleRoot -ChildPath "output\module\$($script:dscModuleName)\*\$($script:dscModuleName).psd1"

    Import-Module -Name $script:moduleManifest -Force -ErrorAction 'Stop'

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:dscModuleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:dscModuleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:dscModuleName
}

AfterAll {
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    # Unload the module being tested so that it doesn't impact any other tests.
    Get-Module -Name $script:dscModuleName -All | Remove-Module -Force
}

Describe 'Remove-AADConnectDirectoryExtensionAttribute' -Tag 'Public' {
    BeforeAll {
        # Mock existing attributes for testing
        $script:mockExistingAttributes = @(
            [PSCustomObject]@{
                Name = 'employeeNumber'
                AssignedObjectClass = 'user'
                Type = 'String'
                IsEnabled = 'True'
            }
            [PSCustomObject]@{
                Name = 'departmentCode'
                AssignedObjectClass = 'user'
                Type = 'String'
                IsEnabled = 'False'
            }
            [PSCustomObject]@{
                Name = 'badgeId'
                AssignedObjectClass = 'user'
                Type = 'Integer'
                IsEnabled = 'True'
            }
            [PSCustomObject]@{
                Name = 'costCenter'
                AssignedObjectClass = 'group'
                Type = 'String'
                IsEnabled = 'True'
            }
        )

        # Mock global settings object
        $script:mockGlobalSettings = [PSCustomObject]@{
            Parameters = [System.Collections.ArrayList]@(
                [PSCustomObject]@{
                    Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                    Value = 'employeeNumber.user.String.True,departmentCode.user.String.False,badgeId.user.Integer.True,costCenter.group.String.True'
                }
            )
        }

        # Add AddOrReplace method to Parameters collection
        $script:mockGlobalSettings.Parameters | Add-Member -MemberType ScriptMethod -Name 'AddOrReplace' -Value {
            param($parameter)
            # Find existing parameter with same name
            $existing = $this | Where-Object Name -eq $parameter.Name
            if ($existing) {
                $existing.Value = $parameter.Value
            } else {
                $this.Add($parameter)
            }
        }

        # Mock the ADSync cmdlets
        Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
            return $script:mockExistingAttributes
        }

        Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
            return $script:mockGlobalSettings
        }

        Mock -CommandName Set-ADSyncGlobalSettings -MockWith {
            param($GlobalSettings)
            # Mock successful update
        }
    }

    BeforeEach {
        # Reset mock data before each test
        $script:mockExistingAttributes = @(
            [PSCustomObject]@{
                Name = 'employeeNumber'
                AssignedObjectClass = 'user'
                Type = 'String'
                IsEnabled = 'True'
            }
            [PSCustomObject]@{
                Name = 'departmentCode'
                AssignedObjectClass = 'user'
                Type = 'String'
                IsEnabled = 'False'
            }
            [PSCustomObject]@{
                Name = 'badgeId'
                AssignedObjectClass = 'user'
                Type = 'Integer'
                IsEnabled = 'True'
            }
            [PSCustomObject]@{
                Name = 'costCenter'
                AssignedObjectClass = 'group'
                Type = 'String'
                IsEnabled = 'True'
            }
        )

        $script:mockGlobalSettings.Parameters[0].Value = 'employeeNumber.user.String.True,departmentCode.user.String.False,badgeId.user.Integer.True,costCenter.group.String.True'
    }

    Context 'When removing an attribute with individual parameters' {
        It 'Should remove the attribute successfully' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -Name 'employeeNumber' -Type 'String' -AssignedObjectClass 'user'

                Assert-MockCalled -CommandName Get-AADConnectDirectoryExtensionAttribute -Times 1
                Assert-MockCalled -CommandName Get-ADSyncGlobalSettings -Times 1
                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 1
                Assert-MockCalled -CommandName Write-Error -Times 0
            }
        }

        It 'Should update the global settings without the removed attribute' {
            InModuleScope -ScriptBlock {
                Remove-AADConnectDirectoryExtensionAttribute -Name 'badgeId' -Type 'Integer' -AssignedObjectClass 'user'

                # Verify the settings parameter was updated without the removed attribute
                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -ParameterFilter {
                    $GlobalSettings.Parameters[0].Value -notlike '*badgeId.user.Integer.True*' -and
                    $GlobalSettings.Parameters[0].Value -like '*employeeNumber.user.String.True*'
                }
            }
        }
    }

    Context 'When removing an attribute with FullAttributeString parameter' {
        It 'Should parse the full attribute string correctly and remove attribute' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -FullAttributeString 'departmentCode.user.String.False'

                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -ParameterFilter {
                    $GlobalSettings.Parameters[0].Value -notlike '*departmentCode.user.String.False*'
                }
                Assert-MockCalled -CommandName Write-Error -Times 0
            }
        }

        It 'Should write error for malformed attribute string' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -FullAttributeString 'malformed.string'

                Assert-MockCalled -CommandName Write-Error -Times 1 -ParameterFilter {
                    $Message -like '*correct format*'
                }
                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 0
            }
        }

        It 'Should handle attribute strings with various formats' {
            InModuleScope -ScriptBlock {
                $testCases = @(
                    'employeeNumber.user.String.True'
                    'costCenter.group.String.True'
                    'badgeId.user.Integer.True'
                )

                foreach ($testCase in $testCases) {
                    # Reset mocks for each test case
                    Mock -CommandName Write-Error

                    Remove-AADConnectDirectoryExtensionAttribute -FullAttributeString $testCase

                    Assert-MockCalled -CommandName Write-Error -Times 0
                    Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 1
                }
            }
        }
    }

    Context 'When trying to remove non-existent attribute' {
        It 'Should write error when attribute does not exist' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -Name 'nonExistentAttribute' -Type 'String' -AssignedObjectClass 'user'

                Assert-MockCalled -CommandName Write-Error -Times 1 -ParameterFilter {
                    $Message -like "*not defined*"
                }
                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 0
            }
        }

        It 'Should write error when attribute name matches but type differs' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -Name 'employeeNumber' -Type 'Integer' -AssignedObjectClass 'user'

                Assert-MockCalled -CommandName Write-Error -Times 1 -ParameterFilter {
                    $Message -like "*not defined*"
                }
                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 0
            }
        }

        It 'Should write error when attribute name and type match but object class differs' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -Name 'employeeNumber' -Type 'String' -AssignedObjectClass 'group'

                Assert-MockCalled -CommandName Write-Error -Times 1 -ParameterFilter {
                    $Message -like "*not defined*"
                }
                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 0
            }
        }
    }

    Context 'When using pipeline input' {
        It 'Should process pipeline input correctly' {
            InModuleScope -ScriptBlock {
                $inputObjects = @(
                    [PSCustomObject]@{
                        Name = 'employeeNumber'
                        Type = 'String'
                        AssignedObjectClass = 'user'
                    }
                    [PSCustomObject]@{
                        Name = 'costCenter'
                        Type = 'String'
                        AssignedObjectClass = 'group'
                    }
                )

                Mock -CommandName Write-Error

                $inputObjects | Remove-AADConnectDirectoryExtensionAttribute

                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 2
                Assert-MockCalled -CommandName Write-Error -Times 0
            }
        }

        It 'Should handle mixed valid and invalid pipeline input' {
            InModuleScope -ScriptBlock {
                $inputObjects = @(
                    [PSCustomObject]@{
                        Name = 'employeeNumber'
                        Type = 'String'
                        AssignedObjectClass = 'user'
                    }
                    [PSCustomObject]@{
                        Name = 'nonExistent'
                        Type = 'String'
                        AssignedObjectClass = 'user'
                    }
                )

                Mock -CommandName Write-Error

                $inputObjects | Remove-AADConnectDirectoryExtensionAttribute

                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 1  # Only valid one processed
                Assert-MockCalled -CommandName Write-Error -Times 1  # Error for invalid one
            }
        }
    }

    Context 'Parameter validation' {
        It 'Should require Name parameter in ByProperties parameter set' {
            InModuleScope -ScriptBlock {
                { Remove-AADConnectDirectoryExtensionAttribute -Type 'String' -AssignedObjectClass 'user' } | Should -Throw
            }
        }

        It 'Should require Type parameter in ByProperties parameter set' {
            InModuleScope -ScriptBlock {
                { Remove-AADConnectDirectoryExtensionAttribute -Name 'test' -AssignedObjectClass 'user' } | Should -Throw
            }
        }

        It 'Should require AssignedObjectClass parameter in ByProperties parameter set' {
            InModuleScope -ScriptBlock {
                { Remove-AADConnectDirectoryExtensionAttribute -Name 'test' -Type 'String' } | Should -Throw
            }
        }

        It 'Should require FullAttributeString parameter in SingleObject parameter set' {
            InModuleScope -ScriptBlock {
                # This should work - FullAttributeString is mandatory in SingleObject parameter set
                { Remove-AADConnectDirectoryExtensionAttribute -FullAttributeString 'test.user.String.True' } | Should -Not -Throw
            }
        }
    }

    Context 'Error handling' {
        It 'Should handle ADSync cmdlet errors gracefully' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                    throw 'Azure AD Connect service not available'
                }

                { Remove-AADConnectDirectoryExtensionAttribute -Name 'test' -Type 'String' -AssignedObjectClass 'user' } | Should -Throw '*Azure AD Connect*'
            }
        }

        It 'Should handle Set-ADSyncGlobalSettings errors' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Set-ADSyncGlobalSettings -MockWith {
                    throw 'Failed to update global settings'
                }

                { Remove-AADConnectDirectoryExtensionAttribute -Name 'employeeNumber' -Type 'String' -AssignedObjectClass 'user' } | Should -Throw '*Failed to update*'
            }
        }

        It 'Should handle Get-AADConnectDirectoryExtensionAttribute errors' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    throw 'Failed to retrieve attributes'
                }

                { Remove-AADConnectDirectoryExtensionAttribute -Name 'test' -Type 'String' -AssignedObjectClass 'user' } | Should -Throw '*Failed to retrieve*'
            }
        }
    }

    Context 'Edge cases' {
        It 'Should handle empty attributes list gracefully' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith { return @() }
                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -Name 'anyAttribute' -Type 'String' -AssignedObjectClass 'user'

                Assert-MockCalled -CommandName Write-Error -Times 1 -ParameterFilter {
                    $Message -like "*not defined*"
                }
                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 0
            }
        }

        It 'Should handle removal of last remaining attribute' {
            InModuleScope -ScriptBlock {
                # Mock only one attribute exists
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    return @(
                        [PSCustomObject]@{
                            Name = 'lastAttribute'
                            AssignedObjectClass = 'user'
                            Type = 'String'
                            IsEnabled = 'True'
                        }
                    )
                }

                $script:mockGlobalSettings.Parameters[0].Value = 'lastAttribute.user.String.True'

                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -Name 'lastAttribute' -Type 'String' -AssignedObjectClass 'user'

                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -ParameterFilter {
                    $GlobalSettings.Parameters[0].Value -eq ''
                }
                Assert-MockCalled -CommandName Write-Error -Times 0
            }
        }

        It 'Should handle special characters in attribute names' {
            InModuleScope -ScriptBlock {
                # Mock attribute with special characters
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    return @(
                        [PSCustomObject]@{
                            Name = 'attribute-with-dashes_and_underscores123'
                            AssignedObjectClass = 'user'
                            Type = 'String'
                            IsEnabled = 'True'
                        }
                    )
                }

                Mock -CommandName Write-Error

                Remove-AADConnectDirectoryExtensionAttribute -Name 'attribute-with-dashes_and_underscores123' -Type 'String' -AssignedObjectClass 'user'

                Assert-MockCalled -CommandName Set-ADSyncGlobalSettings -Times 1
                Assert-MockCalled -CommandName Write-Error -Times 0
            }
        }
    }
}
