Describe  "Tests around Interface objects" {
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
        It "Create ipMask Interface-Object" {
            $newInterface = New-FMObjInterface -Name "PESTER $pesterGUID"
            $newInterface.name | Should -Be "PESTER $pesterGUID"
                    }
        Context "Interface-Objects created" {
            BeforeAll {
                $newInterfacees = @()
                $newInterfacees += New-FMObjInterface -Name "PESTER IF-A $pesterGUID"
                $newInterfacees += New-FMObjInterface -Name "PESTER IF-B $pesterGUID"
            }
            It "Save Adresses to FM" {
                $newInterfacees | Add-FMInterface | Should -BeNullOrEmpty
            }
            It "Nonsense cannot be saved as an Interface" {
                { "foo" | Add-FMInterface } | should -Throw "*invalid value"
            }
            It "Invalid attributes will be ignorned" {
                $newInterface = New-FMObjInterface -Name "PESTER Bogey Attr $pesterGUID"
                $newInterface | Add-Member -MemberType NoteProperty -Name "Foo" -Value "Bar"
                { $newInterface | Add-FMInterface } | should -Not -Throw
            }
            It "Query pester Interfacees" {
                $existingInterfacees = Get-FMInterface -Filter "name -like PESTER%"
                Write-PSFMessage "`$existingInterfacees=$($existingInterfacees| ConvertTo-Json -WarningAction SilentlyContinue)" -Level Host
                $existingInterfacees | Should -Not -BeNullOrEmpty
                $existingInterfacees | Should -HaveCount 3
            }
            It "Update existing Interface - Full Update" {
                $addr = Get-FMInterface -Filter "name -eq PESTER IF-A $pesterGUID"
                $addr | Should -Not -BeNullOrEmpty
                $addr.color | Should -Be 0
                $addr.color = 1
                $addr | Update-FMInterface
                $addr = Get-FMInterface -Filter "name -eq PESTER IF-A $pesterGUID"
                $addr.color | Should -Be 1
            }
            It "Update existing Interface - Partial Update" {
                $addr = Get-FMInterface -Filter "name -eq PESTER IF-A $pesterGUID"
                $addr | Should -Not -BeNullOrEmpty
                $addr.wildcard | Should -Be "disable"
                $addr.color | Should -Be 1
                $addr = $addr | ConvertTo-PSFHashtable -Include "name", "color"
                $addr.color=0
                $addr | Update-FMInterface
                $addr = Get-FMInterface -Filter "name -eq PESTER IF-A $pesterGUID"
                $addr.wildcard | Should -Be "disable"
                $addr.color | Should -Be 0
            }
            It "Remove pester Interfacees" {
                $existingInterfacees = Get-FMInterface -Filter "name -like PESTER%"
                $existingInterfacees | Remove-FMInterface
                $postCheck = Get-FMInterface -Filter "name -like PESTER%"
                $postCheck | Should -BeNullOrEmpty
            }
            It "Rename Interface" {
                $newInterface = New-FMObjInterface -Name "PESTER Mickey $pesterGUID" -color 1
                { $newInterface | Add-FMInterface } | should -Not -Throw
                Get-FMInterface -Filter "name -eq PESTER Mickey $pesterGUID" | Should -not -BeNullOrEmpty
                { Rename-FMInterface -Name "PESTER Mickey $pesterGUID" -NewName "PESTER Donald $pesterGUID" } | Should -Not -Throw
                $addr = Get-FMInterface -Filter "name -eq PESTER Donald $pesterGUID"
                $addr | Should -Not -BeNullOrEmpty
                $addr.color | Should -Be 1
                Get-FMInterface -Filter "name -eq PESTER Mickey $pesterGUID" | Should -BeNullOrEmpty
            }
            It "Rename Multiple Interfacees" {
                { New-FMObjInterface -Name "PESTER Tick $pesterGUID" | Add-FMInterface } | should -Not -Throw
                { New-FMObjInterface -Name "PESTER Trick $pesterGUID" | Add-FMInterface } | should -Not -Throw
                { New-FMObjInterface -Name "PESTER Track $pesterGUID" | Add-FMInterface } | should -Not -Throw
                $renameMatrix = @{
                    "PESTER Tick $pesterGUID"  = "PESTER Huey $pesterGUID"
                    "PESTER Trick $pesterGUID" = "PESTER Dewey $pesterGUID"
                    "PESTER Track $pesterGUID" = "PESTER Louie $pesterGUID"
                }
                { Rename-FMInterface -Mapping $renameMatrix } | Should -Not -Throw
                Get-FMInterface -Filter "name -eq PESTER Huey $pesterGUID" | Should -Not -BeNullOrEmpty
                Get-FMInterface -Filter "name -eq PESTER Dewey $pesterGUID" | Should -Not -BeNullOrEmpty
                Get-FMInterface -Filter "name -eq PESTER Dewey $pesterGUID" | Should -Not -BeNullOrEmpty
                Get-FMInterface -Filter "name -eq PESTER Tick $pesterGUID" | Should -BeNullOrEmpty
                Get-FMInterface -Filter "name -eq PESTER Trick $pesterGUID" | Should -BeNullOrEmpty
                Get-FMInterface -Filter "name -eq PESTER Track $pesterGUID" | Should -BeNullOrEmpty
            }
            It "Rename Multiple Interfacees a second time" {
                $renameMatrix = @{
                    "PESTER Pinky $pesterGUID" = "PESTER Brain $pesterGUID"
                    "PESTER Brain $pesterGUID" = "PESTER Pinky $pesterGUID"
                }
                {
                    $result = Rename-FMInterface -Mapping $renameMatrix -Verbose
                    $result= Rename-FMInterface -Mapping $renameMatrix -EnableException $false
                 } | Should -Throw

                Write-PSFMessage -Level Host "Bogey=$result"
            }
            It "Add Interface, Overwrite" {
                $newInterface = New-FMObjInterface -Name "PESTER Scroodge $pesterGUID"
                { $newInterface | Add-FMInterface } | should -Not -Throw
                $addr = Get-FMInterface -Filter "name -eq PESTER Scroodge $pesterGUID"
                $addr.color =1
                { $addr | Add-FMInterface -Overwrite } | Should -Not -Throw
                $addr = Get-FMInterface -Filter "name -eq PESTER Scroodge $pesterGUID"
                $addr | Should -Not -BeNullOrEmpty
                $addr.color | Should -Be 1
            }
            It "Add Interface, Overwrite with insufficient data works" {
                $addr = Get-FMInterface -Filter "name -eq PESTER Scroodge $pesterGUID" | ConvertTo-PSFHashtable -Exclude "color"
                $addr.color | Should -BeNullOrEmpty
                { $addr | Add-FMInterface } | Should -Throw
                { $addr | Add-FMInterface -Overwrite } | Should -Not -Throw
                $addr = Get-FMInterface -Filter "name -eq PESTER Scroodge $pesterGUID"
                $addr | Should -Not -BeNullOrEmpty
                $addr.color | Should -Be 1
            }
        }
    }
}