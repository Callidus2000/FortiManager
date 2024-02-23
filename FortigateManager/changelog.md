# Changelog
## 1.1.0 (2022-05-19)
 - New functions around Firewall Policies
## (many updates)
 - Follow/Watch the repository ;-)
## 2.0.0 (2022-08-19)
 - **Breaking Change** for [introducing mandatory revision notes](https://github.com/Callidus2000/FortiManager/blob/master/FortigateManager/en-us/about_RevisionNote.help.txt)
## 2.0.2 (2022-10-27)
 - Addresses can be removed even if they are used.
## 2.0.3 (2022-10-28)
 - Multiple Addresses can be removed in one request
 - fixed race condition in Invoke-FMApi which occurred while re-using a HashTable for splatting
## 2.2.0 (2022-11-30)
 - Added functionality:
   - ADOM revisions can be created/queried/removed
   - Merge-FMStringHashMap  
     Helper function to replace placeholders in an url with values from a hashtable.
   - Convert-FMZone2VLAN  
     Converts an interface from a firewall policy to the addresses of the physical interfaces/vlan on the relevant devices.
   - Get-FMFirewallScope  
   Queries firewall scopes for dynamic mapping etc
## 2.2.1 (2023-01-18)
 - Added Parameter SkipCheck to Connect-FM  
   Allows e.g. to skip SSL checks while performing the HTTP requests
## 2.3.0 (2023-05-26)
### Added
- Connect-FM allows to reconnect based on (de)serialized connection objects
### Changed
- Version 2.3.0
## 3.0.0 (2024-02-23)
### Added
- Search-FMALog for search a Forti Analyzer Logfile
### Changed
- Connect-FM allows to connect to a Forti Analyzer