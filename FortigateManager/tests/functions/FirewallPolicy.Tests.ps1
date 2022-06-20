Describe  "Tests around FirewallPolicy objects" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
        Lock-FMAdom
        $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
        Write-PSFMessage "`$pesterGUID=$pesterGUID" -Level Host
        $newAddresses = @()
        $srcAddrName = "PESTER source $pesterGUID"
        $dstAddrName = "PESTER destination $pesterGUID"
        $newAddresses += New-FMObjAddress -Name $srcAddrName -Type ipmask -Subnet "192.168.1.1/32"
        $newAddresses += New-FMObjAddress -Name $dstAddrName -Type iprange -IpRange "192.168.1.1-192.168.1.5"
        $newAddresses | Add-FMAddress | Should -BeNullOrEmpty
    }
    AfterAll {
        # Publish-FMAdomChange
        Disconnect-FM -EnableException $false
    }
    Context "Connected, locked, test addresses created" {
        It "Check PolicyPackage" {
            $policyPackage = Get-FMPolicyPackage -Name $packageName
            $policyPackage | Should -Not -BeNullOrEmpty
            $policyPackage.name | Should -Be $packageName
            $policyPackage."package settings" | Should -Not -BeNullOrEmpty
            # Write-PSFMessage "`$policyPackage=$($policyPackage|convertto-json)"
        }
        It "Create Policy" {
            $newPolicy = New-FMObjFirewallPolicy -Name "PESTER policy A $pesterGUID" -Srcaddr $srcAddrName -Dstaddr $dstAddrName -Srcintf "any" -Dstintf "any" -Service "ALL" -Action accept
            { $newPolicy | Add-FMFirewallPolicy -Package $packageName } | Should -Not -Throw
        }
        It "Check newly created Policy" {
            $policy = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID"
            $policy | Should -Not -BeNullOrEmpty
            $policy.name | Should -Be "PESTER policy A $pesterGUID"
        }
        It "Update Policy" {
            $policy = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID"
            $policy | Should -Not -BeNullOrEmpty
            $policy.name = "PESTER policy B $pesterGUID"
            $policy.service = "HTTP"
            $policy | Update-FMFirewallPolicy -Package $packageName
            $policy = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID"
            $policy | Should -Not -BeNullOrEmpty
            $policy.name | Should -Be "PESTER policy B $pesterGUID"
            $policy.service | Should -Contain "HTTP"
            Get-FMFirewallPolicy -Package $packageName -Filter "name -like PESTER policy A $pesterGUID" -EnableException $false | Should -BeNullOrEmpty
        }
        It "Move Policy to first position" {
            $policy = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID"
            $policy | Should -Not -BeNullOrEmpty
            $firstPolicyId = Get-FMFirewallPolicy -Package $packageName -Fields policyid | Select-Object -First 1 -ExpandProperty policyid
            { Move-FMFirewallPolicy -Package $packageName -PolicyID $policy.policyid -Target $firstPolicyId -Position before } | Should -Not -Throw
            $policy = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID"
            $policy."obj seq" | Should -Be 1
        }
        It "Remove Policy" {
            $policy = Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID"
            $policy | Should -Not -BeNullOrEmpty
            { $policy | Remove-FMFirewallPolicy -Package $packageName } | Should -Not -Throw
            Get-FMFirewallPolicy -Package $packageName -Filter "name -like %$pesterGUID" | Should -BeNullOrEmpty
        }
    }
}