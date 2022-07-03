Describe  "Tests around address group objects" {
    BeforeAll {
        Import-Module C:\DEV\odin.git\GitHub\FortigateManager\FortigateManager\FortigateManager.psd1 -Force
        . $PSScriptRoot\Connect4Testing.ps1
        Lock-FMAdom
    }
    AfterAll {
        # Publish-FMAdomChange
        Disconnect-FM -EnableException $false
    }
    Context "Connected, locked" {
        It "Single Group, add single Address" {
            $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
            # Create 3 Addresses
            { (1..3) | ForEach-Object { New-FMObjAddress -Name "PESTER $_ $pesterGUID" -Type ipmask -Subnet "192.168.1.1/32" | Add-FMAddress } } | should -Not -Throw
            # Create New group, 2 members
            { New-FMobjAddressGroup -Name "PESTER Single $pesterGUID" -member ((1..2) | ForEach-Object { "PESTER $_ $pesterGUID" }) | Add-FMAddressGroup } | should -Not -Throw
            $addrGrp = Get-FMAddressGroup -Filter "name -eq PESTER Single $pesterGUID" -Fields name, member
            $addrGrp | Should -Not -BeNullOrEmpty
            $addrGrp.member | Should -HaveCount 2
            # Add the third address to the group
            Update-FMAddressGroupMember -Action add -Name "PESTER Single $pesterGUID" -Member "PESTER 3 $pesterGUID" -Verbose
            Write-PSFMessage -Level Host "Update done"
            $addrGrp = Get-FMAddressGroup -Filter "name -eq PESTER Single $pesterGUID" -Fields member
            $addrGrp | Should -Not -BeNullOrEmpty
            $addrGrp.member | Should -HaveCount 3
        }
        It "Single Group, add three addresses" {
            $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
            # Create 5 Addresses
            { (1..5) | ForEach-Object { New-FMObjAddress -Name "PESTER $_ $pesterGUID" -Type ipmask -Subnet "192.168.1.1/32" | Add-FMAddress } } | should -Not -Throw
            # Create New group, first 2 addresses as member
            { New-FMobjAddressGroup -Name "PESTER Single3 $pesterGUID" -member ((1..2) | ForEach-Object { "PESTER $_ $pesterGUID" }) | Add-FMAddressGroup } | should -Not -Throw
            $addrGrp = Get-FMAddressGroup -Filter "name -eq PESTER Single3 $pesterGUID" -Fields name, member
            $addrGrp | Should -Not -BeNullOrEmpty
            $addrGrp.member | Should -HaveCount 2
            # Add the third address to the group
            Update-FMAddressGroupMember -Action add -Name "PESTER Single3 $pesterGUID" -Member ((3..5) | ForEach-Object { "PESTER $_ $pesterGUID" }) -Verbose
            Write-PSFMessage -Level Host "Update done"
            $addrGrp = Get-FMAddressGroup -Filter "name -eq PESTER Single3 $pesterGUID" -Fields member
            $addrGrp | Should -Not -BeNullOrEmpty
            $addrGrp.member | Should -HaveCount 5
        }
        Context "Two Groups, add and remove" {
            BeforeAll {
                # Both tests target the same GUID objects
                $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
                # Create 7 Addresses
                { (1..7) | ForEach-Object { New-FMObjAddress -Name "PESTER $_ $pesterGUID" -Type ipmask -Subnet "192.168.1.1/32" | Add-FMAddress } } | should -Not -Throw
            }
            It "Two Group, add three addresses" {
                # Create two new group, first 2 addresses as member
                $members = ((1..2) | ForEach-Object { "PESTER $_ $pesterGUID" })
                $addrGrpArray = (1..2) | ForEach-Object { New-FMobjAddressGroup -Name "PESTER Twin$_ $pesterGUID" -member $members }
                { $addrGrpArray | Add-FMAddressGroup } | should -Not -Throw
                $addrGrpArray = Get-FMAddressGroup -Filter "name -like PESTER Twin%$pesterGUID" -Fields name, member
                $addrGrpArray | Should -Not -BeNullOrEmpty
                $addrGrpArray | Should -HaveCount 2
                foreach ($addGrp in $addrGrpArray) {
                    $addGrp.member | Should -HaveCount 2
                }
                # Add the third address to the group
                { Update-FMAddressGroupMember -Action add -Name $addrGrpArray.name -Member ((3..5) | ForEach-Object { "PESTER $_ $pesterGUID" }) -Verbose } | Should -Not -Throw
                Write-PSFMessage -Level Host "Update done"
                $addrGrpArray = Get-FMAddressGroup -Filter "name -like PESTER Twin%$pesterGUID" -Fields name, member
                foreach ($addGrp in $addrGrpArray) {
                    $addGrp.member | Should -HaveCount 5
                }
            }
            It "Two existing Groups, remove address 3" {
                # $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
                # Create 5 Addresses
                $addrGrpArray = Get-FMAddressGroup -Filter "name -like PESTER Twin%$pesterGUID" -Fields name, member
                $addrGrpArray | Should -Not -BeNullOrEmpty
                $addrGrpArray | Should -HaveCount 2
                foreach ($addGrp in $addrGrpArray) {
                    $addGrp.member | Should -HaveCount 5
                }
                # remove the third address from the group
                { Update-FMAddressGroupMember -Action remove -Name $addrGrpArray.name -Member "PESTER 3 $pesterGUID"  -Verbose } | Should -Not -Throw
                Write-PSFMessage -Level Host "Update done"
                $addrGrpArray = Get-FMAddressGroup -Filter "name -like PESTER Twin%$pesterGUID" -Fields name, member
                foreach ($addGrp in $addrGrpArray) {
                    $addGrp.member | Should -HaveCount 4
                    $addGrp.member | Should -Not -Contain "PESTER 3 $pesterGUID"
                }
            }
            It "Two existing Groups, remove and add by table" {
                $actionMap = @(
                    @{
                        addrGrpName = "PESTER Twin1 $pesterGUID"
                        addrName    = "PESTER 6 $pesterGUID"
                        action      = "add"
                    },
                    @{
                        addrGrpName = "PESTER Twin1 $pesterGUID"
                        addrName    = "PESTER 1 $pesterGUID"
                        action      = "remove"
                    },
                    @{
                        addrGrpName = "PESTER Twin2 $pesterGUID"
                        addrName    = "PESTER 7 $pesterGUID"
                        action      = "add"
                    },
                    @{
                        addrGrpName = "PESTER Twin2 $pesterGUID"
                        addrName    = "PESTER 2 $pesterGUID"
                        action      = "remove"
                    }
                )
                { Update-FMAddressGroupMember -ActionMap $actionMap  -Verbose } | Should -Not -Throw
                Write-PSFMessage -Level Host "Update done"
                $addrGrpArray = Get-FMAddressGroup -Filter "name -like PESTER Twin%$pesterGUID" -Fields name, member
                foreach ($index in (1..2)) {
                    $addGrp = $addrGrpArray[$index - 1]
                    Write-PSFMessage     -Level Host "Index $index=$($addGrp.name)"
                    $addGrp.member | Should -HaveCount 4
                    $addGrp.member | Should -Contain "PESTER 4 $pesterGUID"
                    $addGrp.member | Should -Not -Contain "PESTER $($index) $pesterGUID"
                    $addGrp.member | Should  -Contain "PESTER $(5+$index) $pesterGUID"
                }
            }
        }
        # It "Adding invalid data as address group does not work" {
        #     { "FooBar" | Add-FMAddressGroup } | Should -Throw "*invalid value*"
        # }
        # It "Invalid attributes will be ignorned" {
        #     $newGroup = New-FMobjAddressGroup -Name "PESTER noMemberBogey $pesterGUID" -member "none"
        #     $newGroup | Add-Member -MemberType NoteProperty -Name "Foo" -Value "Bar"
        #     { $newGroup | Add-FMAddressGroup } | should -Not -Throw
        # }
        # It "Groups can be queried" {
        #     $allAddressGroups = Get-FMAddressGroup -Filter "name -like PESTER % $pesterGUID"
        #     $allAddressGroups | Should -Not -BeNullOrEmpty
        #     $allAddressGroups | Should -HaveCount 2
        # }
        # It "Add Group with Members" {
        #     $newGroup = New-FMobjAddressGroup -Name "PESTER Member $pesterGUID" -member $testAddressNames
        #     { $newGroup | Add-FMAddressGroup } | Should -Not -Throw
        # }
        # It "Remove group" {
        #     $testGroup = Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER Member $pesterGUID"
        #     $testGroup | Should -Not -BeNullOrEmpty
        #     $testGroup | Remove-FMAddressGroup
        #     Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER Member $pesterGUID" | Should -BeNullOrEmpty
        # }
        # It "Update group" {
        #     $testGroup = Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBogey $pesterGUID" | ConvertTo-PSFHashtable
        #     $testGroup | Should -Not -BeNullOrEmpty
        #     $testGroup.comment = "Modified at $(Get-Date)"
        #     { $testGroup | Update-fmaddressgroup } | Should -Not -Throw
        # }
        # It "Rename group" {
        #     { Rename-FMAddressGroup -name "PESTER noMemberBogey $pesterGUID" -newName "PESTER noMemberBuggy $pesterGUID" } | Should -Not -Throw
        #     Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBogey $pesterGUID" | Should -BeNullOrEmpty
        #     Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBuggy $pesterGUID" | Should -not -BeNullOrEmpty
        #     (Get-FMAddressGroup -Connection $Connection -Filter "name -eq PESTER noMemberBuggy $pesterGUID").comment | Should -BeLike 'Modified at*'
        # }
        # It "Rename Multiple Addressgroups" {
        #         { New-FMobjAddressGroup -Name "PESTER Group Tick $pesterGUID" -member "none" | Add-FMAddressGroup } | should -Not -Throw
        #         { New-FMobjAddressGroup -Name "PESTER Group Trick $pesterGUID" -member "none" | Add-FMAddressGroup } | should -Not -Throw
        #         { New-FMobjAddressGroup -Name "PESTER Group Track $pesterGUID" -member "none" | Add-FMAddressGroup } | should -Not -Throw
        #         $renameMatrix = @{
        #             "PESTER Group Tick $pesterGUID"  = "PESTER Group Huey $pesterGUID"
        #             "PESTER Group Trick $pesterGUID" = "PESTER Group Dewey $pesterGUID"
        #             "PESTER Group Track $pesterGUID" = "PESTER Group Louie $pesterGUID"
        #         }
        #         { Rename-FMAddressGroup -Mapping $renameMatrix } | Should -Not -Throw
        #         Get-FMAddressGroup -Filter "name -eq PESTER Group Huey $pesterGUID" | Should -Not -BeNullOrEmpty
        #         Get-FMAddressGroup -Filter "name -eq PESTER Group Dewey $pesterGUID" | Should -Not -BeNullOrEmpty
        #         Get-FMAddressGroup -Filter "name -eq PESTER Group Dewey $pesterGUID" | Should -Not -BeNullOrEmpty
        #         Get-FMAddressGroup -Filter "name -eq PESTER Group Tick $pesterGUID" | Should -BeNullOrEmpty
        #         Get-FMAddressGroup -Filter "name -eq PESTER Group Trick $pesterGUID" | Should -BeNullOrEmpty
        #         Get-FMAddressGroup -Filter "name -eq PESTER Group Track $pesterGUID" | Should -BeNullOrEmpty
        #     }
    }
}