#  FortiManager Powershell Module

This Powershell Module is a wrapper for the API of Fortigate FortiManager. Fortigate FortiManager is a 
solution for managing multiple instances of Fortigate firewalls.

The API is documented in the [Fortinet Developer Network](https://fndn.fortinet.net/).

## Detailed Information for this Module
- [Project Homepage @github](https://github.com/Callidus2000/FortiManager)
- [Report Bug](https://github.com/Callidus2000/FortiManager/issues)
- [Request Feature](https://github.com/Callidus2000/FortiManager/issues)

## Installation

The releases are published in the Powershell Gallery, therefor it is quite simple:
  ```powershell
  Install-Module FortiManager -Force -AllowClobber
  ```
The `AllowClobber` option is currently neccessary because of an issue in the current PowerShellGet module. Hopefully it will not be needed in the future any more.

## Usage

The module is a wrapper for the Fortigate FortiManager API. For getting started take a look at the integrated help of the included functions.

Main Entries:
* Connect-FM - Connect to your installation
* Get-FMAddress - Queries existing addresses of the given ADOM.
* New-FMObjAddress - Creates a new address object
* Add-FMAddress - Add the object to the configuration
* Remove-FMAddress/Rename-FMAddress/Update-FMAddress - Does what it says
* Lock-FMAdom - Locks the ADOM for modification
* Publish-FMAdomChange - Same as clicking on "Save" in the Web-GUI
* Unlock-FMAdom - Unlocks the ADOM

Corresponding functions for address groups are also provided.
```Powershell
# Connect
$connection = Connect-FM -Credential $fortiCred -Url MyServer.MyCompany.com -verbose -Adom TEST

# Import some data from excel
$ipTable = Import-Excel -Path ".\ip-data.xlsx" -WorksheetName "addresses"
$ipAddressNamesFromExcel = $ipTable | Select-Object -expandproperty "Name"
$existingAddresses = Get-FMAddress -Connection $Connection -verbose -fields "name" | Select-Object -expandproperty name

$missingAddresses = $ipAddressNamesFromExcel | Where-Object { $_ -notin $existingAddresses } | Sort-Object -Unique
Write-PSFMessage -Level Host "$($existingAddresses.count) Adresses found in Forti, $($ipAddressNamesFromExcel.count) within Excel, missing $($missingAddresses.count)"
$newFMAddresses = @()
foreach ($newAddress in $missingAddresses) {
    Write-PSFMessage -Level Host "Create address object: $newAddress"
    $newFMAddresses += New-FMObjAddress -Name "$newAddress" -Type ipmask -Subnet "$newAddress"  -Comment "Created ByScript"
}
Lock-FMAdom -Connection $connection
try {
    $newFMAddresses | add-fmaddress -connection $connection
    Publish-FMAdomChange -Connection $connection
}
catch {
    Write-PSFMessage -Level Warning "$_"
}
finally {
    UnLock-FMAdom -Connection $connection
}
Disconnect-FM -connection $Connection
```

## License

Distributed under the GNU GENERAL PUBLIC LICENSE version 3. See [LICENSE](https://raw.githubusercontent.com/Callidus2000/FortiManager/master/LICENSE) for more information.

## Contact

Project Link: [https://github.com/Callidus2000/FortiManager](https://github.com/Callidus2000/FortiManager)
