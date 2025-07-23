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

Describe 'Get-AADConnectDirectoryExtensionAttribute' -Tag 'Public' {
    BeforeAll {
        # Mock the ADSync cmdlets
        Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
            return [PSCustomObject]@{
                Parameters = @(
                    [PSCustomObject]@{
                        Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                        Value = 'employeeNumber.user.String.True,departmentCode.user.String.False,badgeId.user.Integer.True,isContractor.user.Boolean.True,costCenter.group.String.True'
                    }
                )
            }
        }
    }

    Context 'When retrieving all directory extension attributes' {
        It 'Should return all configured attributes' {
            InModuleScope -ScriptBlock {
                $result = Get-AADConnectDirectoryExtensionAttribute

                $result | Should -HaveCount 5

                # Verify first attribute
                $result[0].Name | Should -Be 'employeeNumber'
                $result[0].AssignedObjectClass | Should -Be 'user'
                $result[0].Type | Should -Be 'String'
                $result[0].IsEnabled | Should -Be 'True'

                # Verify mixed types and object classes
                $costCenterAttr = $result | Where-Object Name -eq 'costCenter'
                $costCenterAttr.AssignedObjectClass | Should -Be 'group'

                $badgeIdAttr = $result | Where-Object Name -eq 'badgeId'
                $badgeIdAttr.Type | Should -Be 'Integer'

                $contractorAttr = $result | Where-Object Name -eq 'isContractor'
                $contractorAttr.Type | Should -Be 'Boolean'
            }
        }

        It 'Should return objects with correct property structure' {
            InModuleScope -ScriptBlock {
                $result = Get-AADConnectDirectoryExtensionAttribute

                foreach ($attribute in $result) {
                    $attribute | Should -BeOfType [PSCustomObject]
                    $attribute.PSObject.Properties.Name | Should -Contain 'Name'
                    $attribute.PSObject.Properties.Name | Should -Contain 'Type'
                    $attribute.PSObject.Properties.Name | Should -Contain 'AssignedObjectClass'
                    $attribute.PSObject.Properties.Name | Should -Contain 'IsEnabled'
                    $attribute.PSObject.Properties | Should -HaveCount 4
                }
            }
        }
    }

    Context 'When retrieving a specific attribute by name' {
        It 'Should return only the matching attribute' {
            InModuleScope -ScriptBlock {
                $result = Get-AADConnectDirectoryExtensionAttribute -Name 'employeeNumber'

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'employeeNumber'
                $result.Type | Should -Be 'String'
                $result.AssignedObjectClass | Should -Be 'user'
                $result.IsEnabled | Should -Be 'True'
            }
        }

        It 'Should support wildcard patterns' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                # This should work with the current implementation since it uses -like
                $result = Get-AADConnectDirectoryExtensionAttribute -Name 'employee*'

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'employeeNumber'
            }
        }

        It 'Should write error when attribute does not exist' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                $result = Get-AADConnectDirectoryExtensionAttribute -Name 'nonExistentAttribute'

                $result | Should -BeNullOrEmpty
                Assert-MockCalled -CommandName Write-Error -Times 1 -ParameterFilter {
                    $Message -like "*nonExistentAttribute*not defined*"
                }
            }
        }
    }

    Context 'When no directory extension attributes are configured' {
        BeforeAll {
            Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                return [PSCustomObject]@{
                    Parameters = @(
                        [PSCustomObject]@{
                            Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                            Value = $null
                        }
                    )
                }
            }
        }

        It 'Should return nothing when no attributes are configured' {
            InModuleScope -ScriptBlock {
                $result = Get-AADConnectDirectoryExtensionAttribute

                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'When directory extension attributes parameter is empty string' {
        BeforeAll {
            Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                return [PSCustomObject]@{
                    Parameters = @(
                        [PSCustomObject]@{
                            Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                            Value = ''
                        }
                    )
                }
            }
        }

        It 'Should return nothing when attributes value is empty' {
            InModuleScope -ScriptBlock {
                $result = Get-AADConnectDirectoryExtensionAttribute

                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'When global settings parameter is missing' {
        BeforeAll {
            Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                return [PSCustomObject]@{
                    Parameters = @()
                }
            }
        }

        It 'Should handle missing parameter gracefully' {
            InModuleScope -ScriptBlock {
                $result = Get-AADConnectDirectoryExtensionAttribute

                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'When ADSync cmdlet throws an error' {
        BeforeAll {
            Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                throw 'Azure AD Connect is not installed or service is not running'
            }
        }

        It 'Should propagate ADSync errors' {
            InModuleScope -ScriptBlock {
                { Get-AADConnectDirectoryExtensionAttribute } | Should -Throw '*Azure AD Connect*'
            }
        }
    }

    Context 'Parameter validation' {
        It 'Should accept string parameter for Name' {
            InModuleScope -ScriptBlock {
                # Should not throw
                { Get-AADConnectDirectoryExtensionAttribute -Name 'test' } | Should -Not -Throw
            }
        }

        It 'Should work without any parameters' {
            InModuleScope -ScriptBlock {
                # Should not throw
                { Get-AADConnectDirectoryExtensionAttribute } | Should -Not -Throw
            }
        }
    }

    Context 'When attribute string has malformed format' {
        BeforeAll {
            Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                return [PSCustomObject]@{
                    Parameters = @(
                        [PSCustomObject]@{
                            Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                            Value = 'malformedAttribute,employeeNumber.user.String.True,another.malformed.attribute'
                        }
                    )
                }
            }
        }

        It 'Should handle malformed attribute strings gracefully' {
            InModuleScope -ScriptBlock {
                # The function should still return the valid attributes
                $result = Get-AADConnectDirectoryExtensionAttribute

                # Should get the properly formatted one
                $validAttribute = $result | Where-Object Name -eq 'employeeNumber'
                $validAttribute | Should -Not -BeNullOrEmpty
                $validAttribute.Name | Should -Be 'employeeNumber'

                # Malformed ones might create objects with incorrect properties
                # but the function should not crash
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}
