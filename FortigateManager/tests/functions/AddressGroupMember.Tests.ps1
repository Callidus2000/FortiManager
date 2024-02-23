Describe  "Tests around address group objects" {
    BeforeAll {
        # Import-Module C:\DEV\odin.git\GitHub\FortigateManager\FortigateManager\FortigateManager.psd1 -Force
        . $PSScriptRoot\Connect4Testing.ps1
        Lock-FMAdom -RevisionNote "Pester Tests"
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
            Update-FMAddressGroupMember -Action add -Name "PESTER Single $pesterGUID" -Member "PESTER 3 $pesterGUID"
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
            Update-FMAddressGroupMember -Action add -Name "PESTER Single3 $pesterGUID" -Member ((3..5) | ForEach-Object { "PESTER $_ $pesterGUID" })
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
                { Update-FMAddressGroupMember -Action add -Name $addrGrpArray.name -Member ((3..5) | ForEach-Object { "PESTER $_ $pesterGUID" })  } | Should -Not -Throw
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
                { Update-FMAddressGroupMember -Action remove -Name $addrGrpArray.name -Member "PESTER 3 $pesterGUID" } | Should -Not -Throw
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
                { Update-FMAddressGroupMember -ActionMap $actionMap   } | Should -Not -Throw
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
            It "Check None-Membership functionality" {
                # $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
                # Create 5 Addresses
                $addrGrp = Get-FMAddressGroup -Filter "name -eq PESTER Twin1 $pesterGUID" -Fields name, member
                $addrGrp | Should -Not -BeNullOrEmpty
                $addrGrp.member | Should -HaveCount 4
                # remove all addresses from the group
                { Update-FMAddressGroupMember -Action remove -Name $addrGrp.name -Member $addrGrp.member  } | Should -Not -Throw
                $addrGrp = Get-FMAddressGroup -Filter "name -like PESTER Twin1 $pesterGUID" -Fields name, member
                Write-PSFMessage "`$addrGrp.member=$($addrGrp.member -join ',')"
                $addrGrp.member | Should -HaveCount 1
                $addrGrp.member | Should -Contain "none"
                { Update-FMAddressGroupMember -Action add -Name $addrGrp.name -Member "PESTER 3 $pesterGUID"  } | Should -Not -Throw
                $addrGrp = Get-FMAddressGroup -Filter "name -like PESTER Twin1 $pesterGUID" -Fields name, member
                Write-PSFMessage "`$addrGrp2.member=$($addrGrp.member -join ',')"
                $addrGrp.member | Should -HaveCount 1
                $addrGrp.member | Should -Contain "PESTER 3 $pesterGUID"
                $addrGrp.member | Should -Not -Contain "none"
            }
        }
    }
    Context "Scope Awareness" {
        BeforeAll {
            $devInfo = Get-FMDeviceInfo -Option 'object member'
            $allScopes = $devInfo."object member" | Select-Object name, vdom | Where-Object { $_.vdom }
            $firstScope = $allScopes[0]
            $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
            # Create 7 Addresses
            $addrNames = (1..7) | ForEach-Object { "PESTER $_ $pesterGUID" }
            { $addrNames | ForEach-Object { New-FMObjAddress -Name $_ -Type ipmask -Subnet "192.168.1.1/32" | Add-FMAddress } } | should -Not -Throw
            # Create New group, no members
            $addrGrpName = "PESTER Scope $pesterGUID"
            { New-FMobjAddressGroup -Name $addrGrpName -member "none" | Add-FMAddressGroup } | should -Not -Throw
            Write-PSFMessage -Level Error "###################################################"
        }
        It "Group exists" {
            $addrGrp = Get-FMAddressGroup -Filter "name -eq $addrGrpName"
            $addrGrp | Should -Not -BeNullOrEmpty
        }
        It "Add member to first scope" {
            Update-FMAddressGroupMember -Name $addrGrpName -Action add -Member $addrNames[0] -Scope $firstScope
            $addrGrp = Get-FMAddressGroup -Filter "name -eq $addrGrpName"
            Write-PSFMessage -Level Host "`$addrGrp=$($addrGrp| ConvertTo-Json -WarningAction SilentlyContinue -Depth 5)"
            $addrGrp.dynamic_mapping | Should -HaveCount 1
        }
        It "Add member to all available scopes" {
            Write-Host "ReqIds: $($connection.forti.requestId+1)"
            Update-FMAddressGroupMember -Name $addrGrpName -Action add -Member $addrNames[1] -Scope "*" #-Debug
            Write-Host "ReqId2: $($connection.forti.requestId)"
            $addrGrp = Get-FMAddressGroup -Filter "name -eq $addrGrpName"
            Write-PSFMessage -Level Host "`$addrGrp=$($addrGrp| ConvertTo-Json -WarningAction SilentlyContinue -Depth 5)"
            $addrGrp.dynamic_mapping | Should -HaveCount $allScopes.count
            foreach ($mapping in $addrGrp.dynamic_mapping) {
                $mapping.member | Should -Contain $addrNames[1]
            }
        }
        # It "Default member should still be 'none'" {
        #     $addrGrp = Get-FMAddressGroup -Filter "name -eq $addrGrpName"
        #     $addrGrp.member | Should -HaveCount 1
        #     $addrGrp.member | Should -Contain "none"
        # }
    }


}