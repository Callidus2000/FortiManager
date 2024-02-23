Register-PSFTeppScriptblock -Name "FortiAnalyzer.Devices" -ScriptBlock {
    try {
        if ([string]::IsNullOrEmpty($fakeBoundParameter.Connection)) {
            $connection = Get-FMLastConnection -Type Analyzer -EnableException $false
        }
        else {
            $connection = $fakeBoundParameter.Connection
        }
        if (-not $connection){return}
        if(-not $connection.forti.containskey('devices')){
            $deviceInfo=Get-FMADeviceInfo -Fields name
            $deviceNames = $deviceInfo.name + ($deviceInfo.vdom | ForEach-Object { "$($_.DevID)[$($_.name)]" })
            $connection.forti.devices = $deviceNames
        }
        return $connection.forti.devices
    }
    catch {
        return "Error"
    }
}
