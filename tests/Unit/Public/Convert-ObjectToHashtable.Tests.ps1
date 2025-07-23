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

Describe 'Convert-ObjectToHashtable' -Tag 'Public' {
    Context 'When converting a simple PSCustomObject' {
        It 'Should return a hashtable with all properties' {
            InModuleScope -ScriptBlock {
                $testObject = [PSCustomObject]@{
                    Name = 'John Doe'
                    Age = 30
                    Email = 'john.doe@contoso.com'
                    Department = 'IT'
                }

                $result = Convert-ObjectToHashtable -Object $testObject

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 4
                $result.Name | Should -Be 'John Doe'
                $result.Age | Should -Be 30
                $result.Email | Should -Be 'john.doe@contoso.com'
                $result.Department | Should -Be 'IT'
            }
        }
    }

    Context 'When converting an object with null properties' {
        It 'Should exclude null properties from the hashtable' {
            InModuleScope -ScriptBlock {
                $testObject = [PSCustomObject]@{
                    Name = 'John Doe'
                    Age = 30
                    Email = $null
                    Department = 'IT'
                    Manager = $null
                }

                $result = Convert-ObjectToHashtable -Object $testObject

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 3
                $result.Name | Should -Be 'John Doe'
                $result.Age | Should -Be 30
                $result.Department | Should -Be 'IT'
                $result.ContainsKey('Email') | Should -Be $false
                $result.ContainsKey('Manager') | Should -Be $false
            }
        }
    }

    Context 'When converting an object with complex property values' {
        It 'Should include complex objects as-is in the hashtable' {
            InModuleScope -ScriptBlock {
                $testObject = [PSCustomObject]@{
                    Name = 'Test User'
                    Tags = @('tag1', 'tag2', 'tag3')
                    Settings = @{
                        Option1 = 'value1'
                        Option2 = 'value2'
                    }
                    CreatedDate = Get-Date '2025-01-01'
                }

                $result = Convert-ObjectToHashtable -Object $testObject

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 4
                $result.Name | Should -Be 'Test User'
                $result.Tags | Should -Be @('tag1', 'tag2', 'tag3')
                $result.Settings | Should -BeOfType [hashtable]
                $result.Settings.Option1 | Should -Be 'value1'
                $result.CreatedDate | Should -BeOfType [DateTime]
            }
        }
    }

    Context 'When converting an empty object' {
        It 'Should return an empty hashtable' {
            InModuleScope -ScriptBlock {
                $testObject = [PSCustomObject]@{}

                $result = Convert-ObjectToHashtable -Object $testObject

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 0
            }
        }
    }

    Context 'When converting an object with all null properties' {
        It 'Should return an empty hashtable' {
            InModuleScope -ScriptBlock {
                $testObject = [PSCustomObject]@{
                    Property1 = $null
                    Property2 = $null
                    Property3 = $null
                }

                $result = Convert-ObjectToHashtable -Object $testObject

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 0
            }
        }
    }

    Context 'When using pipeline input' {
        It 'Should accept pipeline input and convert correctly' {
            InModuleScope -ScriptBlock {
                $testObject = [PSCustomObject]@{
                    Name = 'Pipeline Test'
                    Value = 42
                }

                $result = $testObject | Convert-ObjectToHashtable

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 2
                $result.Name | Should -Be 'Pipeline Test'
                $result.Value | Should -Be 42
            }
        }
    }

    Context 'When converting multiple objects via pipeline' {
        It 'Should process each object separately' {
            InModuleScope -ScriptBlock {
                $testObjects = @(
                    [PSCustomObject]@{ Name = 'Object1'; Value = 1 }
                    [PSCustomObject]@{ Name = 'Object2'; Value = 2 }
                    [PSCustomObject]@{ Name = 'Object3'; Value = $null }
                )

                $results = $testObjects | Convert-ObjectToHashtable

                $results | Should -HaveCount 3

                $results[0] | Should -BeOfType [hashtable]
                $results[0].Name | Should -Be 'Object1'
                $results[0].Value | Should -Be 1

                $results[1] | Should -BeOfType [hashtable]
                $results[1].Name | Should -Be 'Object2'
                $results[1].Value | Should -Be 2

                $results[2] | Should -BeOfType [hashtable]
                $results[2].Name | Should -Be 'Object3'
                $results[2].Count | Should -Be 1  # Only Name property, Value is null
                $results[2].ContainsKey('Value') | Should -Be $false
            }
        }
    }

    Context 'When converting objects with special property names' {
        It 'Should handle special property names correctly' {
            InModuleScope -ScriptBlock {
                $testObject = [PSCustomObject]@{
                    'Property-With-Dashes' = 'value1'
                    'Property With Spaces' = 'value2'
                    'Property123' = 'value3'
                    'PropertyWithNumbers456' = 'value4'
                }

                $result = Convert-ObjectToHashtable -Object $testObject

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 4
                $result.'Property-With-Dashes' | Should -Be 'value1'
                $result.'Property With Spaces' | Should -Be 'value2'
                $result.Property123 | Should -Be 'value3'
                $result.PropertyWithNumbers456 | Should -Be 'value4'
            }
        }
    }

    Context 'Parameter validation' {
        It 'Should throw when Object parameter is null' {
            InModuleScope -ScriptBlock {
                { Convert-ObjectToHashtable -Object $null } | Should -Throw
            }
        }

        It 'Should accept any object type' {
            InModuleScope -ScriptBlock {
                # Test with a string object
                $stringObject = 'test'
                $result = Convert-ObjectToHashtable -Object $stringObject

                $result | Should -BeOfType [hashtable]
                $result.Count | Should -Be 1
                $result.Length | Should -Be 4  # String.Length property
            }
        }
    }
}
