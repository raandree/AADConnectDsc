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

Describe 'Add-AADConnectDirectoryExtensionAttribute' -Tag 'Public' {
    Context 'When adding a new attribute with individual parameters' {
        It 'Should add the attribute successfully' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    return @()  # No existing attributes
                }

                Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                    $parameter = [PSCustomObject]@{
                        Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                        Value = 'existingAttr.user.String.True'
                    }
                    $parameters = [System.Collections.ArrayList]@($parameter)
                    $parameters | Add-Member -MemberType ScriptMethod -Name 'AddOrReplace' -Value {
                        param($newParameter)
                        $existing = $this | Where-Object Name -eq $newParameter.Name
                        if ($existing) { $existing.Value = $newParameter.Value }
                        else { $this.Add($newParameter) }
                    }
                    return [PSCustomObject]@{ Parameters = $parameters }
                }

                Mock -CommandName Set-ADSyncGlobalSettings -MockWith { return $null }

                { Add-AADConnectDirectoryExtensionAttribute -Name 'testAttr' -Type 'String' -AssignedObjectClass 'user' -IsEnabled $true } | Should -Not -Throw

                Should -Invoke Get-AADConnectDirectoryExtensionAttribute -Exactly 1
                Should -Invoke Get-ADSyncGlobalSettings -Exactly 1
                Should -Invoke Set-ADSyncGlobalSettings -Exactly 1
            }
        }
    }

    Context 'When adding an attribute with FullAttributeString parameter' {
        It 'Should parse the full attribute string correctly' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith { return @() }

                Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                    $parameter = [PSCustomObject]@{
                        Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                        Value = ''
                    }
                    $parameters = [System.Collections.ArrayList]@($parameter)
                    $parameters | Add-Member -MemberType ScriptMethod -Name 'AddOrReplace' -Value {
                        param($newParameter)
                        $existing = $this | Where-Object Name -eq $newParameter.Name
                        if ($existing) { $existing.Value = $newParameter.Value }
                        else { $this.Add($newParameter) }
                    }
                    return [PSCustomObject]@{ Parameters = $parameters }
                }

                Mock -CommandName Set-ADSyncGlobalSettings -MockWith { return $null }

                { Add-AADConnectDirectoryExtensionAttribute -FullAttributeString 'employeeId.user.String.True' } | Should -Not -Throw

                Should -Invoke Set-ADSyncGlobalSettings -Exactly 1
            }
        }

        It 'Should write error for malformed attribute string' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                Add-AADConnectDirectoryExtensionAttribute -FullAttributeString 'malformed.string'

                Should -Invoke Write-Error -Exactly 1
            }
        }
    }

    Context 'When attribute already exists with same properties' {
        It 'Should write error and not add duplicate' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    return @([PSCustomObject]@{
                        Name = 'duplicateAttr'
                        Type = 'String'
                        AssignedObjectClass = 'user'
                        IsEnabled = 'True'
                    })
                }

                Mock -CommandName Write-Error
                Mock -CommandName Set-ADSyncGlobalSettings -MockWith { return $null }

                Add-AADConnectDirectoryExtensionAttribute -Name 'duplicateAttr' -Type 'String' -AssignedObjectClass 'user' -IsEnabled $true

                Should -Invoke Write-Error -Exactly 1
                Should -Invoke Set-ADSyncGlobalSettings -Exactly 0
            }
        }
    }

    Context 'When attribute exists with different type and Force is not used' {
        It 'Should write error about type conflict' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    return @([PSCustomObject]@{
                        Name = 'conflictAttr'
                        Type = 'String'
                        AssignedObjectClass = 'user'
                        IsEnabled = 'True'
                    })
                }

                Mock -CommandName Write-Error
                Mock -CommandName Set-ADSyncGlobalSettings -MockWith { return $null }

                Add-AADConnectDirectoryExtensionAttribute -Name 'conflictAttr' -Type 'Integer' -AssignedObjectClass 'user' -IsEnabled $true

                Should -Invoke Write-Error -Exactly 1
                Should -Invoke Set-ADSyncGlobalSettings -Exactly 0
            }
        }
    }

    Context 'When attribute exists with different type and Force is used' {
        It 'Should remove existing attribute and add new one' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    return @([PSCustomObject]@{
                        Name = 'forceAttr'
                        Type = 'String'
                        AssignedObjectClass = 'user'
                        IsEnabled = 'True'
                    })
                }

                Mock -CommandName Remove-AADConnectDirectoryExtensionAttribute -MockWith { return $null }

                Mock -CommandName Get-ADSyncGlobalSettings -MockWith {
                    $parameter = [PSCustomObject]@{
                        Name = 'Microsoft.OptionalFeature.DirectoryExtensionAttributes'
                        Value = 'forceAttr.user.String.True'
                    }
                    $parameters = [System.Collections.ArrayList]@($parameter)
                    $parameters | Add-Member -MemberType ScriptMethod -Name 'AddOrReplace' -Value {
                        param($newParameter)
                        $existing = $this | Where-Object Name -eq $newParameter.Name
                        if ($existing) { $existing.Value = $newParameter.Value }
                        else { $this.Add($newParameter) }
                    }
                    return [PSCustomObject]@{ Parameters = $parameters }
                }

                Mock -CommandName Set-ADSyncGlobalSettings -MockWith { return $null }

                Add-AADConnectDirectoryExtensionAttribute -Name 'forceAttr' -Type 'Integer' -AssignedObjectClass 'user' -IsEnabled $true -Force

                Should -Invoke Remove-AADConnectDirectoryExtensionAttribute -Exactly 1
                Should -Invoke Set-ADSyncGlobalSettings -Exactly 1
            }
        }
    }

    Context 'Parameter validation' {
        It 'Should require Name parameter in ByProperties parameter set' {
            InModuleScope -ScriptBlock {
                { Add-AADConnectDirectoryExtensionAttribute -Type 'String' -AssignedObjectClass 'user' -IsEnabled $true } | Should -Throw
            }
        }

        It 'Should require Type parameter in ByProperties parameter set' {
            InModuleScope -ScriptBlock {
                { Add-AADConnectDirectoryExtensionAttribute -Name 'test' -AssignedObjectClass 'user' -IsEnabled $true } | Should -Throw
            }
        }

        It 'Should require AssignedObjectClass parameter in ByProperties parameter set' {
            InModuleScope -ScriptBlock {
                { Add-AADConnectDirectoryExtensionAttribute -Name 'test' -Type 'String' -IsEnabled $true } | Should -Throw
            }
        }

        It 'Should require IsEnabled parameter in ByProperties parameter set' {
            InModuleScope -ScriptBlock {
                { Add-AADConnectDirectoryExtensionAttribute -Name 'test' -Type 'String' -AssignedObjectClass 'user' } | Should -Throw
            }
        }
    }

    Context 'Error handling' {
        It 'Should handle ADSync cmdlet errors gracefully' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-AADConnectDirectoryExtensionAttribute -MockWith {
                    throw 'ADSync error'
                }

                { Add-AADConnectDirectoryExtensionAttribute -Name 'test' -Type 'String' -AssignedObjectClass 'user' -IsEnabled $true } | Should -Throw '*ADSync error*'
            }
        }
    }
}
