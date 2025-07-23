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

Describe 'Get-ADSyncRule' -Tag 'Public' {
    BeforeAll {
        # Mock connector data
        $script:mockConnectors = @(
            [PSCustomObject]@{
                Name = 'contoso.com'
                Identifier = [guid]'11111111-1111-1111-1111-111111111111'
            }
            [PSCustomObject]@{
                Name = 'fabrikam.com'
                Identifier = [guid]'22222222-2222-2222-2222-222222222222'
            }
            [PSCustomObject]@{
                Name = 'Azure Active Directory'
                Identifier = [guid]'33333333-3333-3333-3333-333333333333'
            }
        )

        # Mock sync rule data
        $script:mockSyncRules = @(
            [PSCustomObject]@{
                Name = 'In from AD - User Common'
                Identifier = [guid]'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                Connector = [guid]'11111111-1111-1111-1111-111111111111'
                Direction = 'Inbound'
            }
            [PSCustomObject]@{
                Name = 'In from AD - User AccountEnabled'
                Identifier = [guid]'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
                Connector = [guid]'11111111-1111-1111-1111-111111111111'
                Direction = 'Inbound'
            }
            [PSCustomObject]@{
                Name = 'Out to AAD - User Join'
                Identifier = [guid]'cccccccc-cccc-cccc-cccc-cccccccccccc'
                Connector = [guid]'33333333-3333-3333-3333-333333333333'
                Direction = 'Outbound'
            }
            [PSCustomObject]@{
                Name = 'In from AD - Group Common'
                Identifier = [guid]'dddddddd-dddd-dddd-dddd-dddddddddddd'
                Connector = [guid]'22222222-2222-2222-2222-222222222222'
                Direction = 'Inbound'
            }
        )

        # Mock the ADSync cmdlets
        Mock -CommandName Get-ADSyncConnector -MockWith {
            return $script:mockConnectors
        }

        Mock -CommandName 'ADSync\Get-ADSyncRule' -MockWith {
            param($Identifier)
            if ($Identifier) {
                return $script:mockSyncRules | Where-Object Identifier -eq $Identifier
            }
            return $script:mockSyncRules
        }
    }

    Context 'When called without parameters (get all rules)' {
        It 'Should return all sync rules' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule

                $result | Should -HaveCount 4
                $result[0].Name | Should -Be 'In from AD - User Common'
                $result[1].Name | Should -Be 'In from AD - User AccountEnabled'
                $result[2].Name | Should -Be 'Out to AAD - User Join'
                $result[3].Name | Should -Be 'In from AD - Group Common'
            }
        }

        It 'Should call ADSync Get-ADSyncRule without parameters' {
            InModuleScope -ScriptBlock {
                Get-ADSyncRule

                Assert-MockCalled -CommandName 'ADSync\Get-ADSyncRule' -Times 1 -ParameterFilter {
                    $null -eq $Identifier
                }
            }
        }
    }

    Context 'When called with Name parameter only' {
        It 'Should return rules matching the specified name' {
            InModuleScope -ScriptBlock {
                # Mock the ADSync cmdlets inside the test
                Mock -CommandName Get-ADSyncConnector -MockWith {
                    return @(
                        [PSCustomObject]@{ Name = 'contoso.com'; Identifier = [guid]'11111111-1111-1111-1111-111111111111' },
                        [PSCustomObject]@{ Name = 'fabrikam.com'; Identifier = [guid]'22222222-2222-2222-2222-222222222222' }
                    )
                }

                Mock -CommandName 'ADSync\Get-ADSyncRule' -MockWith {
                    return @(
                        [PSCustomObject]@{ Name = 'In from AD - User Common'; Identifier = [guid]'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'; Connector = [guid]'11111111-1111-1111-1111-111111111111' }
                    )
                }

                $result = Get-ADSyncRule -Name 'In from AD - User Common'

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'In from AD - User Common'
                $result.Identifier | Should -Be 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
            }
        }

        It 'Should return multiple rules if multiple names match' {
            InModuleScope -ScriptBlock {
                # This tests the Where-Object filtering
                $result = Get-ADSyncRule -Name 'In from AD - User AccountEnabled'

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'In from AD - User AccountEnabled'
            }
        }

        It 'Should return empty result when name does not match' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule -Name 'NonExistent Rule'

                $result | Should -BeNullOrEmpty
            }
        }

        It 'Should call Get-ADSyncConnector to retrieve connectors' {
            InModuleScope -ScriptBlock {
                Get-ADSyncRule -Name 'In from AD - User Common'

                Assert-MockCalled -CommandName Get-ADSyncConnector -Times 1
            }
        }
    }

    Context 'When called with Identifier parameter' {
        It 'Should return the rule with matching identifier' {
            InModuleScope -ScriptBlock {
                $testId = [guid]'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
                $result = Get-ADSyncRule -Identifier $testId

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'In from AD - User AccountEnabled'
                $result.Identifier | Should -Be $testId
            }
        }

        It 'Should call ADSync Get-ADSyncRule with Identifier parameter' {
            InModuleScope -ScriptBlock {
                $testId = [guid]'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
                Get-ADSyncRule -Identifier $testId

                Assert-MockCalled -CommandName 'ADSync\Get-ADSyncRule' -Times 1 -ParameterFilter {
                    $Identifier -eq $testId
                }
            }
        }

        It 'Should not call Get-ADSyncConnector when using Identifier' {
            InModuleScope -ScriptBlock {
                $testId = [guid]'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb'
                Get-ADSyncRule -Identifier $testId

                Assert-MockCalled -CommandName Get-ADSyncConnector -Times 0
            }
        }

        It 'Should return empty result for non-existent identifier' {
            InModuleScope -ScriptBlock {
                $nonExistentId = [guid]'99999999-9999-9999-9999-999999999999'
                $result = Get-ADSyncRule -Identifier $nonExistentId

                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'When called with ConnectorName parameter only' {
        It 'Should return all rules for the specified connector' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule -ConnectorName 'contoso.com'

                $result | Should -HaveCount 2
                $result[0].Name | Should -Be 'In from AD - User Common'
                $result[1].Name | Should -Be 'In from AD - User AccountEnabled'

                # Both should belong to the same connector
                $result[0].Connector | Should -Be '11111111-1111-1111-1111-111111111111'
                $result[1].Connector | Should -Be '11111111-1111-1111-1111-111111111111'
            }
        }

        It 'Should return rules for different connector' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule -ConnectorName 'fabrikam.com'

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'In from AD - Group Common'
                $result.Connector | Should -Be '22222222-2222-2222-2222-222222222222'
            }
        }

        It 'Should return empty result for non-existent connector' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule -ConnectorName 'nonexistent.com'

                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'When called with both Name and ConnectorName parameters' {
        It 'Should return rule matching both name and connector' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule -Name 'In from AD - User Common' -ConnectorName 'contoso.com'

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'In from AD - User Common'
                $result.Connector | Should -Be '11111111-1111-1111-1111-111111111111'
            }
        }

        It 'Should return empty result when name exists but not for the specified connector' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule -Name 'In from AD - User Common' -ConnectorName 'fabrikam.com'

                $result | Should -BeNullOrEmpty
            }
        }

        It 'Should write error when connector does not exist' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Write-Error

                $result = Get-ADSyncRule -Name 'In from AD - User Common' -ConnectorName 'nonexistent.com'

                $result | Should -BeNullOrEmpty
                Assert-MockCalled -CommandName Write-Error -Times 1 -ParameterFilter {
                    $Message -like "*connector*nonexistent.com*does not exist*"
                }
            }
        }

        It 'Should handle case where rule name does not exist for valid connector' {
            InModuleScope -ScriptBlock {
                $result = Get-ADSyncRule -Name 'NonExistent Rule' -ConnectorName 'contoso.com'

                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'Parameter set validation' {
        It 'Should use ByIdentifier parameter set correctly' {
            InModuleScope -ScriptBlock {
                $testId = [guid]'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'

                # This should work and not call Get-ADSyncConnector
                $result = Get-ADSyncRule -Identifier $testId

                $result | Should -Not -BeNullOrEmpty
                Assert-MockCalled -CommandName Get-ADSyncConnector -Times 0
            }
        }

        It 'Should use ByName parameter set correctly' {
            InModuleScope -ScriptBlock {
                # This should work and call Get-ADSyncConnector
                $result = Get-ADSyncRule -Name 'In from AD - User Common'

                $result | Should -Not -BeNullOrEmpty
                Assert-MockCalled -CommandName Get-ADSyncConnector -Times 1
            }
        }

        It 'Should use ByConnector parameter set correctly' {
            InModuleScope -ScriptBlock {
                # This should work and call Get-ADSyncConnector
                $result = Get-ADSyncRule -ConnectorName 'contoso.com'

                $result | Should -Not -BeNullOrEmpty
                Assert-MockCalled -CommandName Get-ADSyncConnector -Times 1
            }
        }

        It 'Should use ByNameAndConnector parameter set correctly' {
            InModuleScope -ScriptBlock {
                # This should work and call Get-ADSyncConnector
                $result = Get-ADSyncRule -Name 'In from AD - User Common' -ConnectorName 'contoso.com'

                $result | Should -Not -BeNullOrEmpty
                Assert-MockCalled -CommandName Get-ADSyncConnector -Times 1
            }
        }
    }

    Context 'Error handling' {
        It 'Should handle ADSync Get-ADSyncRule errors gracefully' {
            InModuleScope -ScriptBlock {
                Mock -CommandName 'ADSync\Get-ADSyncRule' -MockWith {
                    throw 'Azure AD Connect service not available'
                }

                { Get-ADSyncRule } | Should -Throw '*Azure AD Connect*'
            }
        }

        It 'Should handle Get-ADSyncConnector errors gracefully' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-ADSyncConnector -MockWith {
                    throw 'Failed to retrieve connectors'
                }

                { Get-ADSyncRule -Name 'test' } | Should -Throw '*Failed to retrieve*'
            }
        }

        It 'Should handle null connectors list' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-ADSyncConnector -MockWith { return $null }
                Mock -CommandName Write-Error

                $result = Get-ADSyncRule -ConnectorName 'contoso.com'

                # Should handle gracefully and return empty
                $result | Should -BeNullOrEmpty
            }
        }

        It 'Should handle empty connectors list' {
            InModuleScope -ScriptBlock {
                Mock -CommandName Get-ADSyncConnector -MockWith { return @() }
                Mock -CommandName Write-Error

                $result = Get-ADSyncRule -ConnectorName 'contoso.com'

                # Should handle gracefully and return empty
                $result | Should -BeNullOrEmpty
            }
        }
    }

    Context 'Edge cases' {
        It 'Should handle empty sync rules list' {
            InModuleScope -ScriptBlock {
                Mock -CommandName 'ADSync\Get-ADSyncRule' -MockWith { return @() }

                $result = Get-ADSyncRule

                $result | Should -BeNullOrEmpty
            }
        }

        It 'Should handle null sync rules list' {
            InModuleScope -ScriptBlock {
                Mock -CommandName 'ADSync\Get-ADSyncRule' -MockWith { return $null }

                $result = Get-ADSyncRule

                $result | Should -BeNullOrEmpty
            }
        }

        It 'Should handle case-sensitive name matching' {
            InModuleScope -ScriptBlock {
                # The function uses -EQ which is case-insensitive by default
                $result = Get-ADSyncRule -Name 'in from ad - user common'

                # This should not match due to case sensitivity
                $result | Should -BeNullOrEmpty
            }
        }

        It 'Should handle special characters in names' {
            InModuleScope -ScriptBlock {
                # Add a mock rule with special characters
                $specialRule = [PSCustomObject]@{
                    Name = 'Rule with (special) [characters] & symbols'
                    Identifier = [guid]'eeeeeeee-eeee-eeee-eeee-eeeeeeeeeeee'
                    Connector = [guid]'11111111-1111-1111-1111-111111111111'
                }

                Mock -CommandName 'ADSync\Get-ADSyncRule' -MockWith {
                    return ($script:mockSyncRules + $specialRule)
                }

                $result = Get-ADSyncRule -Name 'Rule with (special) [characters] & symbols'

                $result | Should -HaveCount 1
                $result.Name | Should -Be 'Rule with (special) [characters] & symbols'
            }
        }

        It 'Should handle guid conversion properly' {
            InModuleScope -ScriptBlock {
                $testGuid = [guid]'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
                $result = Get-ADSyncRule -Identifier $testGuid

                $result.Identifier | Should -BeOfType [guid]
                $result.Identifier | Should -Be $testGuid
            }
        }
    }
}
