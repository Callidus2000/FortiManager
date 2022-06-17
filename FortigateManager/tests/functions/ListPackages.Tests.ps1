Describe  "Connection tests" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
    }
    AfterAll {
        Disconnect-FM -EnableException $false
    }
    Context "Connected" {
        It "Packages can be queried and Pester-" {
            $policyPackages = Get-FMPolicyPackage
            $policyPackages.count | Should -BeGreaterThan 0
            $policyPackages | Select-Object -ExpandProperty name | Should -Contain $packageName
        }
    }
}