Describe  "Publish-FMAdomChange tests" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
        Lock-FMAdom -RevisionNote "Pester Tests"
        $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
    }
    AfterAll {
        # Publish-FMAdomChange
        Disconnect-FM -EnableException $false
    }
    Context "Connected and locked" {
        It "Create ipMask Address-Object and publish it" {
            New-FMObjAddress -Name "PESTER ipmask $pesterGUID" -Type ipmask -Subnet "192.168.1.1/32"            | Add-FMAddress | Should -BeNullOrEmpty
            Publish-FMAdomChange
            Disconnect-FM -EnableException $false
             Connect-FM -Credential $credentials -Url $fqdn -verbose -Adom $adom -EnableException $false|Should -Not -BeNullOrEmpty
        }
        It "Check published address" {
            $addr = Get-FMAddress -Filter "name -eq PESTER ipmask $pesterGUID"
            $addr|Should -Not -BeNullOrEmpty
            $addr.type | Should -Be "ipmask"
        }
        It "Remove published address" {
            $addr = Get-FMAddress -Filter "name -eq PESTER ipmask $pesterGUID"
            $addr | Should -Not -BeNullOrEmpty
            Lock-FMAdom -RevisionNote "Pester Tests"
            $addr|Remove-FMAddress
            Publish-FMAdomChange
            UnLock-FMAdom
            $addr = Get-FMAddress -Filter "name -eq PESTER ipmask $pesterGUID"
            $addr | Should -BeNullOrEmpty
        }
    }
}