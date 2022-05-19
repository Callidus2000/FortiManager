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

All prerequisites will be installed automatically.

### Installation

The releases are published in the Powershell Gallery, therefor it is quite simple:
  ```powershell
  Install-Module FortiManager -Force -AllowClobber
  ```
The `AllowClobber` option is currently necessary because of an issue in the current PowerShellGet module. Hopefully it will not be needed in the future any more.

<!-- USAGE EXAMPLES -->
## Usage

The module is a wrapper for the Fortnet FortiManager API. For getting started take a look at the integrated help of the included functions.

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
* Currently there exists no viable pester tests
* Maybe there are some inconsitencies in the docs, which may result in a mere copy/paste marathon from my other projects

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

