Describe  "Connection tests" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
        Lock-FMAdom
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
            BeforeAll{
                $newAddresses=@()
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
            It "Query pester addresses"{
                $existingAddresses=Get-FMAddress -Filter "name -like PESTER%"
                Write-PSFMessage "`$existingAddresses=$($existingAddresses|ConvertTo-Json)" -Level Host
                $existingAddresses|Should -Not -BeNullOrEmpty
                $existingAddresses|Should -HaveCount 3
            }
            It "Remove pester addresses"{
                $existingAddresses=Get-FMAddress -Filter "name -like PESTER%"
                $existingAddresses|Remove-FMAddress
                $postCheck=Get-FMAddress -Filter "name -like PESTER%"
                $postCheck|Should -BeNullOrEmpty
            }
        }
    }
}