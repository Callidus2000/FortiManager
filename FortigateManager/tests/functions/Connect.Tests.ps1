Describe  "Connection tests" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
    }
    Context "NotConnected" {
        It "Connection should not be established" {
            $wrongCreds = new-object -typename System.Management.Automation.PSCredential -argumentlist "anonymous", (ConvertTo-SecureString "password" -AsPlainText -Force)
            $connection = Connect-FM -Credential $wrongCreds -Url "noneResolvable" -verbose -Adom $adom -EnableException $false
            $connection | Should -BeNullOrEmpty
            {
                Connect-FM -Credential $wrongCreds -Url "noneResolvable" -verbose -Adom $adom | out-null
            } | Should -Throw
        }
        It "Is PSConfig set" {
            $adom | Should -not -BeNullOrEmpty
            $packageName | Should -not -BeNullOrEmpty
            $credentials | Should -not -BeNullOrEmpty
            $fqdn | Should -not -BeNullOrEmpty
        }
        It "Connection Established" {
            $connection = Connect-FM -Credential $credentials -Url $fqdn -verbose -Adom $adom -EnableException $false
            $connection | Should -Not -BeNullOrEmpty
            $connection.forti.session | Should -Not -BeNullOrEmpty
            $connection.forti.defaultADOM | Should -Be $adom
            $connection.forti.requestId | Should -Be 2
            (Get-FMLastConnection).forti.session | Should -Be $connection.forti.session
        }
    }
    Context "Connected" {
        BeforeAll{
            $connection = Connect-FM -Credential $credentials -Url $fqdn -verbose -Adom $adom -EnableException $false
            $connection | Should -Not -BeNullOrEmpty
        }
        It "Disconnect" {
            Get-FMLastConnection | Should -Not -BeNullOrEmpty
            Disconnect-FM
            Get-FMLastConnection -EnableException $false | Should -BeNullOrEmpty
            { Get-FMLastConnection } | Should -Throw "No last connection available"
            { Disconnect-FM } | Should -Throw "No last connection available"
        }
    }
}