Describe  "Tests around address group objects" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
        Lock-FMAdom
        $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
        $newAddresses = @()
        $newAddresses += New-FMObjAddress -Name "PESTER ipmask $pesterGUID" -Type ipmask -Subnet "192.168.1.1/32"
        $newAddresses += New-FMObjAddress -Name "PESTER iprange $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5"
        $newAddresses | Add-FMAddress | Should -BeNullOrEmpty
        $testAddressNames = $newAddresses | Select-Object -ExpandProperty name
    }
    AfterAll {
        # Publish-FMAdomChange
        Disconnect-FM -EnableException $false
    }
    Context "Connected, locked, test addresses created" {
        It "Create Addressgroup without member" {
            $newGroup = New-FMobjAddressGroup -Name "PESTER noMember $pesterGUID" -member "none"
            { $newGroup | Add-FMAddressGroup } | Should -Not -Throw
        }
        It "Adding invalid data as address group does not work" {
            { "FooBar" | Add-FMAddressGroup } | Should -Throw "*invalid value*"
        }
        It "Invalid attributes will be ignorned" {
            $newGroup = New-FMobjAddressGroup -Name "PESTER noMemberBogey $pesterGUID" -member "none"
            $newGroup | Add-Member -MemberType NoteProperty -Name "Foo" -Value "Bar"
            { $newGroup | Add-FMAddressGroup } | should -Not -Throw
        }
        It "Groups can be queried" {
            $allAddressGroups = Get-FMAddressGroup -Filter "name -like PESTER % $pesterGUID"
            $allAddressGroups | Should -Not -BeNullOrEmpty
            $allAddressGroups | Should -HaveCount 2
        }
        It "Add Group with Members" {
            $newGroup = New-FMobjAddressGroup -Name "PESTER Member $pesterGUID" -member $testAddressNames
            { $newGroup | Add-FMAddressGroup } | Should -Not -Throw
        }
        It "Remove group" {
            $testGroup = Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER Member $pesterGUID"
            $testGroup | Should -Not -BeNullOrEmpty
            $testGroup | Remove-FMAddressGroup
            Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER Member $pesterGUID" | Should -BeNullOrEmpty
        }
        It "Update group" {
            $testGroup = Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBogey $pesterGUID" | ConvertTo-PSFHashtable
            $testGroup | Should -Not -BeNullOrEmpty
            $testGroup.comment = "Modified at $(Get-Date)"
            { $testGroup | Update-fmaddressgroup } | Should -Not -Throw
        }
        It "Rename group" {
            { Rename-FMAddressGroup -name "PESTER noMemberBogey $pesterGUID" -newName "PESTER noMemberBuggy $pesterGUID" } | Should -Not -Throw
            Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBogey $pesterGUID" | Should -BeNullOrEmpty
            Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBuggy $pesterGUID" | Should -not -BeNullOrEmpty
            (Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBuggy $pesterGUID").comment | Should -BeLike 'Modified at*'
        }
    }
}