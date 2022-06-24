Write-PSFMessage "Connect4Testing" -Level Host
if ([string]::IsNullOrEmpty($global:testroot)) {
    $global:testroot = (Resolve-Path "$PSScriptRoot\..").Path
}
$moduleRoot = (Resolve-Path "$global:testroot\..").Path
# Import-Module "$moduleRoot\FortigateManager.psd1" -Force
Write-PSFMessage "`$moduleRoot=$moduleRoot"
$adom = Get-PSFConfigValue "FortigateManager.pester.adom" -ErrorAction Stop
$packageName = Get-PSFConfigValue "FortigateManager.pester.packagename" -ErrorAction Stop
$credentials = Get-PSFConfigValue "FortigateManager.pester.credentials" -ErrorAction Stop
$fqdn = Get-PSFConfigValue "FortigateManager.pester.fqdn" -ErrorAction Stop
$VerbosePreference = "Continue"
$connection = Connect-FM -Credential $credentials -Url $fqdn -verbose -Adom $adom -EnableException $false
