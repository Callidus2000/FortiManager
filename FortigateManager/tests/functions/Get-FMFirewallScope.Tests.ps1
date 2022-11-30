Describe  "Tests around Get-FMFirewallScope" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1

        Mock -ModuleName "FortigateManager" Get-FMDeviceInfo {
            return @"
{
    "object member": [
    {
        "name": "FW1",
        "vdom": "cologne"
    },
    {
        "name": "FW1",
        "vdom": "finance"
    },
    {
        "name": "FW2",
        "vdom": "munich"
    },
    {
        "name": "FW3",
        "vdom": "bonn"
    },
    {
        "name": "FW3",
        "vdom": "finance"
    },
    {
        "name": "All_FortiGate"
    }
    ]
}
"@ | ConvertFrom-Json
        }
    }
    AfterAll {
    }
    Context "Connected and mocked" {
        It "Query all scopes" {
            $scopes = Get-FMFirewallScope -verbose
            # Write-PSFMessage -Level Host "$($scopes|json)"
            $scopes | Should -havecount 5
        }
        It "Query single VDOM" {
            $scopes = Get-FMFirewallScope -vdom "bonn"
            # Write-PSFMessage -Level Host "$($scopes|json)"
            $scopes | Should -havecount 1
            $scopes.vdom | Should -Be 'bonn'
            $scopes.name | Should -Be 'FW3'
        }
        It "Query VDOM which happens to exist twice" {
            $scopes = Get-FMFirewallScope -vdom "finance"
            Write-PSFMessage -Level Host "$($scopes|json)"
            $scopes | Should -havecount 2
            $scopes.vdom | Should -Be @('finance', 'finance')
            $scopes.name | Should -Contain 'FW3'
            $scopes.name | Should -Contain 'FW1'
        }
        It "Query single Device" {
            $scopes = Get-FMFirewallScope -deviceName "FW2"
            # Write-PSFMessage -Level Host "$($scopes|json)"
            $scopes | Should -havecount 1
            $scopes.vdom | Should -Be 'munich'
            $scopes.name | Should -Be 'FW2'
        }
        It "Query Device which contains two VDOMs" {
            $scopes = Get-FMFirewallScope -deviceName "FW1"
            Write-PSFMessage -Level Host "$($scopes|json)"
            $scopes | Should -havecount 2
            $scopes.name | Should -Be @('FW1', 'FW1')
            $scopes.vdom | Should -Contain 'cologne'
            $scopes.vdom | Should -Contain 'finance'
        }
        It "Query Device which contains two VDOMs, specific VDOM" {
            $scopes = Get-FMFirewallScope -deviceName "FW1" -vdom 'cologne'
            Write-PSFMessage -Level Host "$($scopes|json)"
            $scopes | Should -havecount 1
            $scopes.name | Should -Be 'FW1'
            $scopes.vdom | Should -Contain 'cologne'
            $scopes.vdom | Should -not -Contain 'finance'
        }
        It "Query Device which contains two VDOMs, specific VDOM" {
            $scopes = Get-FMFirewallScope -vdom 'cologne', 'bonn'
            Write-PSFMessage -Level Host "$($scopes|json)"
            $scopes | Should -havecount 2
            $scopes.name | Should -Contain 'FW1'
            $scopes.name | Should -Contain 'FW3'
            $scopes.vdom | Should -Contain 'cologne'
            $scopes.vdom | Should -Contain 'bonn'
        }
    }
}