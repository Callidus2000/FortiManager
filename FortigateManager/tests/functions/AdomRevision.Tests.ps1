Describe  "Tests around ADOM revisions" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
        Lock-FMAdom -RevisionNote "Pester Tests"
        $pesterGUID = (New-Guid).guid -replace '.*-.*-.*-.*-'
    }
    AfterAll {
        # Publish-FMAdomChange
        # UnLock-FMAdom -RevisionNote "Pester Tests" -EnableException $false

        Disconnect-FM -EnableException $false
    }
    Context "Connected and locked" {
        It "Check adding an revision" {
            $prevRevisions = Get-FMAdomRevision
            $prevRevCount = ($prevRevisions | Measure-Object).Count
            Add-FMAdomRevision -Name "Pester $pesterGUID" -desc "Created by Pester"
            $postRevisions = Get-FMAdomRevision
            ($postRevisions | Measure-Object).Count | Should -be ($prevRevCount + 1)
        }
        It "Remove last revision" {
            $prevRevisions = Get-FMAdomRevision | Where-Object Name -like 'Pester*'
            $prevRevisions | Should -HaveCount 1
            Remove-FMAdomRevision -Version $prevRevisions.version
            Get-FMAdomRevision | Where-Object Name -like 'Pester*' | Should -BeNullOrEmpty
        }
        It "Remove all pester revisions by version" {
            $prevRevisions = Get-FMAdomRevision | Where-Object Name -like 'Pester*'
            $prevRevisions | Should -BeNullOrEmpty
            Add-FMAdomRevision -Name "Pester $pesterGUID A" -desc "Created by Pester"
            Add-FMAdomRevision -Name "Pester $pesterGUID B" -desc "Created by Pester"
            $prevRevisions = Get-FMAdomRevision | Where-Object Name -like 'Pester*'
            $prevRevisions | Should -Not -BeNullOrEmpty

            $prevRevisions | Select-Object -ExpandProperty version | Remove-FMAdomRevision -verbose
            Get-FMAdomRevision | Where-Object Name -like 'Pester*' | Should -BeNullOrEmpty
        }
        # It "Remove all pester revisions by Property" {
        #     $prevRevisions = Get-FMAdomRevision | Where-Object Name -like 'Pester*'
        #     $prevRevisions | Should -BeNullOrEmpty
        #     Add-FMAdomRevision -Name "Pester $pesterGUID A" -desc "Created by Pester"
        #     Add-FMAdomRevision -Name "Pester $pesterGUID B" -desc "Created by Pester"
        #     $prevRevisions = Get-FMAdomRevision | Where-Object Name -like 'Pester*'
        #     $prevRevisions | Should -Not -BeNullOrEmpty

        #     $prevRevisions | Remove-FMAdomRevision -verbose -EnableException $false
        #     $prevRevisions | Select-Object -ExpandProperty version | Remove-FMAdomRevision -verbose
        #     Get-FMAdomRevision | Where-Object Name -like 'Pester*' | Should -BeNullOrEmpty
        # }
    }
}