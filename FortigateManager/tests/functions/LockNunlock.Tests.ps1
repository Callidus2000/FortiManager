Describe  "Lock and Unlock tests" {
    BeforeAll {
        . $PSScriptRoot\Connect4Testing.ps1
        $firstConnection=$connection
        . $PSScriptRoot\Connect4Testing.ps1
        $secondConnection=$connection
    }
    AfterAll{
        Disconnect-FM -Connection $firstConnection -EnableException $false
        Disconnect-FM -Connection $secondConnection -EnableException $false
    }
    Context "Connected" {
        It "Two different sessions" {
            $firstConnection.forti.session|Should -Not -Be $secondConnection.forti.session
        }
        It "Both session should not be locked" {
            Get-FMAdomLockStatus -Connection $firstConnection|Should  -BeNullOrEmpty
            Get-FMAdomLockStatus -Connection $secondConnection|Should  -BeNullOrEmpty
        }
        Context "FirstLocked" {
            BeforeAll {
                Lock-FMAdom -Connection $firstConnection
            }
            AfterAll {
                UnLock-FMAdom -Connection $firstConnection
            }
            It "Check Lock from 1st Connection" {
                Get-FMAdomLockStatus -Connection $firstConnection |Should -Not -BeNullOrEmpty
                (Get-FMAdomLockStatus -Connection $firstConnection).lock_user | Should -Be $firstConnection.AuthenticatedUser
            }
            It "Check Lock from 2nd Connection" {
                Get-FMAdomLockStatus -Connection $secondConnection | Should -Not -BeNullOrEmpty
                (Get-FMAdomLockStatus -Connection $secondConnection).lock_user | Should -Be $secondConnection.AuthenticatedUser
            }
            It "Lock from 2nd Session has to fail" {
                { Lock-FMAdom -Connection $secondConnection } | Should -Throw "*Workspace is locked by other user*"
            }
        }
        Context "FirstUnLocked" {
            It "Lock from 2nd Session now should succeed" {
                { Lock-FMAdom -Connection $secondConnection } | Should -Not -Throw
                { UnLock-FMAdom -Connection $secondConnection } | Should -Not -Throw
            }
        }
    }
}