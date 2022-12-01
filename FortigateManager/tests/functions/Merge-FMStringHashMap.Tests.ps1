Describe  "Tests around Merge-FMStringHashMap" {
    BeforeAll {
        $dataTable=@{
            device='FIREWALL';
            vdom='myVDOM';
            notUsefull='thisIs'
        }
    }
    AfterAll {
    }
        It "Replace by param" {
            $url="/pm/config/device/{{device}}/vdom/{{vdom}}/system/zone"
            Merge-FMStringHashMap -String $url -Data $dataTable |Should -be "/pm/config/device/FIREWALL/vdom/myVDOM/system/zone"
        }
        It "Replace by pipe" {
            $url="/pm/config/device/{{device}}/vdom/{{vdom}}/system/zone"
            $url|Merge-FMStringHashMap -Data $dataTable |Should -be "/pm/config/device/FIREWALL/vdom/myVDOM/system/zone"
        }
        It "Don't touch no-Replaceables" {
            $url="/pm/{keepMe}/device/{device}}/vdom/{vdom}}/system/zone"
            $url|Merge-FMStringHashMap -Data $dataTable |Should -be "/pm/{keepMe}/device/FIREWALL/vdom/myVDOM/system/zone"
        }
}