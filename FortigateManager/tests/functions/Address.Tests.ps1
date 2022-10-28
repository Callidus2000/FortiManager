Describe  "Tests around address objects" {
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
        It "Create ipMask Address-Object" {
            $newAddress = New-FMObjAddress -Name "PESTER ipmask $pesterGUID" -Type ipmask -Subnet "192.168.1.1/32"
            $newAddress.name | Should -Be "PESTER ipmask $pesterGUID"
            $newAddress.type | Should -Be "ipmask"
            $newAddress.subnet | Should -Be "192.168.1.1/32"
        }
        It "Create ipRange Address-Object" {
            $newAddress = New-FMObjAddress -Name "PESTER iprange $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5"
            $newAddress.name | Should -Be "PESTER iprange $pesterGUID"
            $newAddress.type | Should -Be "iprange"
            $newAddress."start-ip" | Should -Be "192.168.1.1"
            $newAddress."end-ip" | Should -Be "192.168.1.5"
        }
        Context "Address-Objects created" {
            BeforeAll {
                $newAddresses = @()
                $newAddresses += New-FMObjAddress -Name "PESTER ipmask $pesterGUID" -Type ipmask -Subnet "192.168.1.1/32"
                $newAddresses += New-FMObjAddress -Name "PESTER iprange $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5"
            }
            It "Save Adresses to FM" {
                $newAddresses | Add-FMAddress | Should -BeNullOrEmpty
                { "foo" | Add-FMAddress } | should -Throw "*invalid value"
            }
            It "Nonsense cannot be saved as an address" {
                { "foo" | Add-FMAddress } | should -Throw "*invalid value"
            }
            It "Invalid attributes will be ignorned" {
                $newAddress = New-FMObjAddress -Name "PESTER Bogey Attr $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5"
                $newAddress | Add-Member -MemberType NoteProperty -Name "Foo" -Value "Bar"
                { $newAddress | Add-FMAddress } | should -Not -Throw
            }
            It "Query pester addresses" {
                $existingAddresses = Get-FMAddress -Filter "name -like PESTER%"
                Write-PSFMessage "`$existingAddresses=$($existingAddresses|ConvertTo-Json)" -Level Host
                $existingAddresses | Should -Not -BeNullOrEmpty
                $existingAddresses | Should -HaveCount 3
            }
            It "Query pester addresses by -Name shortcut" {
                # Write-PSFMessage "################" -Level Host
                Get-FMAddress -Name "PESTER ipmask $pesterGUID" | should -Not -BeNullOrEmpty -Because "Name is just a quick filter"
                Get-FMAddress -Name "PESTER ipmask $pesterGUID" -Filter 'type -eq ipmask' | should -Not -BeNullOrEmpty -Because "Name is just a quick filter which cooperates"
                Get-FMAddress -Name "PESTER ipmask%" | should -BeNullOrEmpty -Because "Name is just a quick filter for EQUAL, not LIKE"

                # Write-PSFMessage "################" -Level Host
            }
            It "Query pester addresses by -Name shortcut, positional parameter" {
                # Write-PSFMessage "################" -Level Host
                Get-FMAddress "PESTER ipmask $pesterGUID" | should -Not -BeNullOrEmpty -Because "Name is just a quick filter"
                Get-FMAddress "PESTER ipmask $pesterGUID" -Filter 'type -eq ipmask' | should -Not -BeNullOrEmpty -Because "Name is just a quick filter which cooperates"
                Get-FMAddress "PESTER ipmask%" | should -BeNullOrEmpty -Because "Name is just a quick filter for EQUAL, not LIKE"

                # Write-PSFMessage "################" -Level Host
            }
            It "Update existing address - Full Update" {
                $addr = Get-FMAddress -Filter "name -eq PESTER iprange $pesterGUID"
                $addr | Should -Not -BeNullOrEmpty
                $addr."start-ip" = "192.168.1.2"
                $addr | Update-FMAddress
                $addr = Get-FMAddress -Filter "name -eq PESTER iprange $pesterGUID"
                $addr."start-ip" | Should -Be "192.168.1.2"
                $addr."end-ip" | Should -Be "192.168.1.5"
            }
            It "Update existing address - Partial Update" {
                $addr = Get-FMAddress -Filter "name -eq PESTER iprange $pesterGUID"
                $addr | Should -Not -BeNullOrEmpty
                $addr."start-ip" | Should -Be "192.168.1.2"
                $addr = $addr | ConvertTo-PSFHashtable -Include "name", "end-ip"
                $addr."start-ip" | Should -BeNullOrEmpty
                $addr."end-ip" = "192.168.1.6"
                $addr | Update-FMAddress
                $addr = Get-FMAddress -Filter "name -eq PESTER iprange $pesterGUID"
                $addr."start-ip" | Should -Be "192.168.1.2"
                $addr."end-ip" | Should -Be "192.168.1.6"
            }
            It "Remove pester addresses - Pipeline by attribute" {
                $existingAddresses = Get-FMAddress -Filter "name -like PESTER%"
                $existingAddresses | Remove-FMAddress
                $postCheck = Get-FMAddress -Filter "name -like PESTER%"
                $postCheck | Should -BeNullOrEmpty
            }
            It "Remove pester addresses - Array to Foreach-Object" {
                { 1..5 | ForEach-Object { New-FMObjAddress -Name "PESTER WillBeKilled No $_ / $pesterGUID"  -Type ipmask -Subnet "192.168.1.1/32" } | Add-FMAddress }  | Should -Not -Throw

                $existingAddresses = Get-FMAddress -Filter "name -like PESTER%"
                $existingAddresses | Should -Not -BeNullOrEmpty
                $existingAddresses | Select-Object -ExpandProperty name | ForEach-Object { Remove-FMAddress -Name $_}

                $postCheck = Get-FMAddress -Filter "name -like PESTER%"
                $postCheck | Should -BeNullOrEmpty
            }
            It "Remove pester addresses - Pipeline from Array" {
                { 1..5 | ForEach-Object { New-FMObjAddress -Name "PESTER WillBeKilled No $_ / $pesterGUID"  -Type ipmask -Subnet "192.168.1.1/32" } | Add-FMAddress }  | Should -Not -Throw

                $existingAddresses = Get-FMAddress -Filter "name -like PESTER%"
                $existingAddresses | Should -Not -BeNullOrEmpty
                $array=$existingAddresses | Select-Object -ExpandProperty name
                $array | Remove-FMAddress -Connection $connection -Force

                $postCheck = Get-FMAddress -Filter "name -like PESTER%"
                $postCheck | Should -BeNullOrEmpty
            }
            # It "Rename Address" {
            #     $newAddress = New-FMObjAddress -Name "PESTER Mickey $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5"
            #     { $newAddress | Add-FMAddress } | should -Not -Throw
            #     { Rename-FMAddress -Name "PESTER Mickey $pesterGUID" -NewName "PESTER Donald $pesterGUID" } | Should -Not -Throw
            #     $addr = Get-FMAddress -Filter "name -eq PESTER Donald $pesterGUID"
            #     $addr | Should -Not -BeNullOrEmpty
            #     $addr."start-ip" | Should -Be "192.168.1.1"
            #     Get-FMAddress -Filter "name -eq PESTER Mickey $pesterGUID" | Should -BeNullOrEmpty
            # }
            # It "Rename Multiple Addresses" {
            #     { New-FMObjAddress -Name "PESTER Tick $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5" | Add-FMAddress } | should -Not -Throw
            #     { New-FMObjAddress -Name "PESTER Trick $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5" | Add-FMAddress } | should -Not -Throw
            #     { New-FMObjAddress -Name "PESTER Track $pesterGUID" -Type iprange -IpRange "192.168.1.1-192.168.1.5" | Add-FMAddress } | should -Not -Throw
            #     $renameMatrix = @{
            #         "PESTER Tick $pesterGUID"  = "PESTER Huey $pesterGUID"
            #         "PESTER Trick $pesterGUID" = "PESTER Dewey $pesterGUID"
            #         "PESTER Track $pesterGUID" = "PESTER Louie $pesterGUID"
            #     }
            #     { Rename-FMAddress -Mapping $renameMatrix } | Should -Not -Throw
            #     Get-FMAddress -Filter "name -eq PESTER Huey $pesterGUID" | Should -Not -BeNullOrEmpty
            #     Get-FMAddress -Filter "name -eq PESTER Dewey $pesterGUID" | Should -Not -BeNullOrEmpty
            #     Get-FMAddress -Filter "name -eq PESTER Dewey $pesterGUID" | Should -Not -BeNullOrEmpty
            #     Get-FMAddress -Filter "name -eq PESTER Tick $pesterGUID" | Should -BeNullOrEmpty
            #     Get-FMAddress -Filter "name -eq PESTER Trick $pesterGUID" | Should -BeNullOrEmpty
            #     Get-FMAddress -Filter "name -eq PESTER Track $pesterGUID" | Should -BeNullOrEmpty
            # }
            # It "Rename Multiple Addresses a second time" {
            #     $renameMatrix = @{
            #         "PESTER Pinky $pesterGUID" = "PESTER Brain $pesterGUID"
            #         "PESTER Brain $pesterGUID" = "PESTER Pinky $pesterGUID"
            #     }
            #     {
            #         $result = Rename-FMAddress -Mapping $renameMatrix -Verbose
            #         $result = Rename-FMAddress -Mapping $renameMatrix -EnableException $false
            #     } | Should -Throw

            #     Write-PSFMessage -Level Host "Bogey=$result"
            # }
            # It "Add Address, Overwrite" {
            #     $newAddress = New-FMObjAddress -Name "PESTER Scroodge $pesterGUID" -Type iprange -IpRange "192.168.1.10-192.168.1.50"
            #     { $newAddress | Add-FMAddress } | should -Not -Throw
            #     $addr = Get-FMAddress -Filter "name -eq PESTER Scroodge $pesterGUID"
            #     $addr."end-ip" = "192.168.1.60"
            #     { $addr | Add-FMAddress -Overwrite } | Should -Not -Throw
            #     $addr = Get-FMAddress -Filter "name -eq PESTER Scroodge $pesterGUID"
            #     $addr | Should -Not -BeNullOrEmpty
            #     $addr."start-ip" | Should -Be "192.168.1.10"
            #     $addr."end-ip" | Should -Be "192.168.1.60"
            # }
            # It "Add Address, Overwrite with insufficient data works" {
            #     $addr = Get-FMAddress -Filter "name -eq PESTER Scroodge $pesterGUID" | ConvertTo-PSFHashtable -Exclude "end-ip"
            #     $addr."start-ip" | Should -Be "192.168.1.10"
            #     $addr."end-ip" | Should -BeNullOrEmpty
            #     $addr."start-ip" = "192.168.1.8"
            #     { $addr | Add-FMAddress } | Should -Throw
            #     { $addr | Add-FMAddress -Overwrite -Verbose } | Should -Not -Throw
            #     $addr = Get-FMAddress -Filter "name -eq PESTER Scroodge $pesterGUID"
            #     $addr | Should -Not -BeNullOrEmpty
            #     $addr."end-ip" | Should -Be "192.168.1.60"
            #     $addr."start-ip" | Should -Be "192.168.1.8"
            # }
            # It "Remove Address which is in Use" {
            #     $addrName = "PESTER RemoveMe $pesterGUID"
            #     $groupName = "PESTER UseMyAddress $pesterGUID"
            #     New-FMObjAddress -Name $addrName -Type iprange -IpRange "192.168.1.1-192.168.1.5" | Add-FMAddress | Should -BeNullOrEmpty
            #     New-FMobjAddressGroup -Name $groupName -member $addrName | Add-FMAddressGroup | Should -BeNullOrEmpty
            #     Get-FMAddress -Filter "name -eq $addrName" | Should -Not -BeNullOrEmpty
            #     { Remove-FMAddress -Name $addrName } | Should -Throw
            #     Get-FMAddress -Filter "name -eq $addrName" | Should -Not -BeNullOrEmpty
            #     { Remove-FMAddress -Name $addrName -Force } | Should -Not -Throw
            #     Get-FMAddress -Filter "name -eq $addrName" | Should -BeNullOrEmpty
            # }
        }
    }
}