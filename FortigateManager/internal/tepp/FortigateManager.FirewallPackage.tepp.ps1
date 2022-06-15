Register-PSFTeppScriptblock -Name "FortigateManager.FirewallPackage" -ScriptBlock {
    try {
        $connection = (Get-FMLastConnection)
        if($connection) {
            return Get-FMPolicyPackage -LoggingLevel Debug | Select-Object -ExpandProperty name | ForEach-Object { "`"$_`"" }
        }
    }
    catch {
        return "Error"
    }
}
