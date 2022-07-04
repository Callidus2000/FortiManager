<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Thanks again! Now go create something AMAZING! :D
***
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![GPLv3 License][license-shield]][license-url]


<br />
<p align="center">
<!-- PROJECT LOGO
  <a href="https://github.com/Callidus2000/FortiManager">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>
-->

  <h3 align="center">Fortigate FortiManager Powershell Module</h3>

  <p align="center">
    This Powershell Module is a wrapper for the API of Fortigate FortiManager
    <br />
    <a href="https://github.com/Callidus2000/FortiManager"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/Callidus2000/FortiManager/issues">Report Bug</a>
    ·
    <a href="https://github.com/Callidus2000/FortiManager/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#use-cases-or-why-was-the-module-developed">Use-Cases - Why was this module created?</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

This Powershell Module is a wrapper for the API of Fortnet FortiManager. Fortnet FortiManager is a 
solution for managing multiple instances of Fortigate firewalls.

The API is documented in the [Fortinet Developer Network](https://fndn.fortinet.net/).


### Built With

* [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment)
* [psframework](https://github.com/PowershellFrameworkCollective/psframework)



<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

- Powershell 7.x (Core) (If possible get the latest version)  
  Maybe it's working under 5.1, just did not test it
- A Fortinet FortiManager Manager and HTTPS enable with JSON API enable for the user
  - Go on WebGUI of your FortiManager, on System Settings
  - Go `Administrators`
  - Click on `Create New`  
  - and create a new user and don't forget to enable `JSON API Access` to `Read-Write`

### Installation

The releases are published in the Powershell Gallery, therefor it is quite simple:
  ```powershell
  Install-Module FortiManager -Force -AllowClobber
  ```
The `AllowClobber` option is currently necessary because of an issue in the current PowerShellGet module. Hopefully it will not be needed in the future any more.

<!-- USAGE EXAMPLES -->
## Usage

The module is a wrapper for the Fortinet FortiManager API. For getting started take a look at the integrated help of the included functions. As inspiration you can take a look at the use-cases which led to the development of this module.

### Currently supported firewall object types (v1.5)
The following types of objects can handled (the list is not exhaustive):

| functionPrefix | `Get-FM*` | `New-FMObj*` | `Add-FM*` | `Update-FM*` | `Rename-FM*` | `Remove-FM*` |
| ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- |
| Address | X | X | X | X | X | X |
| AddressGroup | X | X | X | X | X | X | 
| FirewallPolicy | X | X | X | X | * | X | 
| FirewallService | X | X | X | X | * | | 
| FirewallInterfaces | X | X | X | X | X | X | 
| DeviceInfo | X |   |   |   |   |   | 

An * in Rename means there is no specific function for it, you may use the `Update-FM*` to do it manually.

### Additional Meta Functions
- `Connect-FM` - Connects to an instance
- `Disconnect-FM` - Disconnects
- `Get-FMAdomLockStatus` - Check if the DOM is locked
- `Lock-FMAdom` - Lock the ADOM for changes
- `Publish-FMAdomChange` - Publish those changes (aka `save`)
- `Unlock-FMAdom` - Unlock to make it available for change to other users
- `Get-FMFirewallHitCount` - How many hits does which rule get?
- `Move-FMFirewallPolicy` - Move a policy before/after another one
- `Convert-FMIpAddressToMaskLength` - Converts a IP Subnet-Mask to a Mask Length
- `Convert-FMSubnetMask` - Converts a subnet mask between long and short-version
- `Invoke-FMAPI` - The magical black box which handles the API requests

## Use-Cases or Why was the module developed?
### Background
Our company uses the Fortinet Manager for administration of 8 production firewalls. The policies were separated into 8 policy packages and no policy package was the same. In a refactoring project we created a new firewall design based on 
* categorizing the vlans into security levels
* creating hierarchical address groups based on the security levels and locations
* building new default policies based on those new objects

### Part One
First task was to import 400 new address objects from Excel. The business requirements were simple:
* Login to the manager (**Connect-FM**)
* Query existing addresses (**Get-FMAddress**) and address groups (**Get-FMADdressGroup**)
* Create new objects for the API (**New-FMObjAddressGroup** and **New-FMObjAddress**) out of the excel file (Thanks to ImportExcel)
* Lock the ADOM for writing (**Lock-FMAdom**)
* Add the new address objects to the ADOM (**Add-FMAddress** and **Add-FMAddressGroup**)
* Save the changes (**Publish-FMAdomChange**)
* Unlock the ADOM after work (**UnlockFMAdom**)

For testing purposes the antagonists of Add where needed (**Remove-FMAddress**, **Remove-FMAddressGroup**), and updating the objects would have been nice, too (you get it, **Update-***).
### Part Two
The new default address objects could be imported, the new default policy rules could be implemented... But where? We had 8 policy packages....

One solution would have been to add the policies to the Global Header config... But beside the firewalls within the project scope the Manager appliance was also in charge of the main location firewalls which would receive the new policies, too. That's not desirable.

New plan: 
* Create a new policy package, add all firewall devices/vdoms to the new package
* Create the new global policy rules
* Foreach existing policy package
  * Read the existing rules (**Get-FMFirewallPolicy**)
  * Modify them (rename, add the previous "Installation Targets" as "Install On" attribute (scope member))
  * Add the modified rule to the new policy package (**Add-FMFirewallPolicy**)
* Apply the new Package to each VDOM
  * The global rules would target all devices
  * The prior copied rules would target specific VDOMs

### Part three
As the module has the ability to read/create/add Firewall policy rules, why not import the new global rules directly from excel? No problem, just had to implement the functions around Firewall Services (**Get/Add/Update-FMFirewallService**). Voila, every necessary task can be automated.

# Example code
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
If you need an overview of the existing commands use
```powershell
# List available commands
Get-Command -Module FortiManager
```
everything else is documented in the module itself.
<!-- ROADMAP -->
## Roadmap
New features will be added if any of my scripts need it ;-)

Until V2.0.0 I cannot guarantee that no breaking change will occur as the development follows my internal DevOps need completely. Likewise I will not insert full documentation of all parameters as I don't have time for this copy&paste. Sorry.

See the [open issues](https://github.com/Callidus2000/FortiManager/issues) for a list of proposed features (and known issues).

If you need a special function feel free to contribute to the project.

<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**. For more details please take a look at the [CONTRIBUTE](docs/CONTRIBUTING.md#Contributing-to-this-repository) document

Short stop:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## Limitations
* The module works on the ADOM level as this is the only permission set I've been granted
* Maybe there are some inconsistencies in the docs, which may result in a mere copy/paste marathon from my other projects

<!-- LICENSE -->
## License

Distributed under the GNU GENERAL PUBLIC LICENSE version 3. See `LICENSE.md` for more information.



<!-- CONTACT -->
## Contact


Project Link: [https://github.com/Callidus2000/FortiManager](https://github.com/Callidus2000/FortiManager)



<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements

* [Friedrich Weinmann](https://github.com/FriedrichWeinmann) for his marvelous [PSModuleDevelopment](https://github.com/PowershellFrameworkCollective/PSModuleDevelopment) and [psframework](https://github.com/PowershellFrameworkCollective/psframework)





<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Callidus2000/FortiManager.svg?style=for-the-badge
[contributors-url]: https://github.com/Callidus2000/FortiManager/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Callidus2000/FortiManager.svg?style=for-the-badge
[forks-url]: https://github.com/Callidus2000/FortiManager/network/members
[stars-shield]: https://img.shields.io/github/stars/Callidus2000/FortiManager.svg?style=for-the-badge
[stars-url]: https://github.com/Callidus2000/FortiManager/stargazers
[issues-shield]: https://img.shields.io/github/issues/Callidus2000/FortiManager.svg?style=for-the-badge
[issues-url]: https://github.com/Callidus2000/FortiManager/issues
[license-shield]: https://img.shields.io/github/license/Callidus2000/FortiManager.svg?style=for-the-badge
[license-url]: https://github.com/Callidus2000/FortiManager/blob/master/LICENSE

