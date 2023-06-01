@{
	# Script module or binary module file associated with this manifest
	RootModule        = 'FortigateManager.psm1'

	# Version number of this module.
	ModuleVersion     = '2.3.1'

	# ID used to uniquely identify this module
	GUID              = '6c74c0d7-80cf-4bef-8fe1-19ac4a89c438'

	# Author of this module
	Author            = 'Sascha Spiekermann'

	# Company or vendor of this module
	CompanyName       = 'MyCompany'

	# Copyright statement for this module
	Copyright         = 'Copyright (c) 2022 Sascha Spiekermann'

	# Description of the functionality provided by this module
	Description       = 'A module to interact with a Fortinet Manager appliance for Fortigate Firewalls'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.0'

	# Modules that must be imported into the global environment prior to importing
	# this module
	RequiredModules   = @(
		@{ ModuleName = 'PSFramework'; ModuleVersion = '1.6.214' }
		@{ ModuleName = 'ARAH'; ModuleVersion = '1.3.5' }
	)

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @('bin\FortigateManager.dll')

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @('xml\FortigateManager.Types.ps1xml')

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @('xml\FortigateManager.Format.ps1xml')

	# Functions to export from this module
	FunctionsToExport = @(
		'Add-FMAddress'
		'Add-FMAddressGroup'
		'Add-FMAdomRevision'
		'Add-FMFirewallPolicy'
		'Add-FMFirewallService'
		'Add-FMInterface'
		'Connect-FM'
		'Convert-FMIpAddressToMaskLength'
		'Convert-FMSubnetMask'
		'Convert-FMZone2VLAN'
		'Disconnect-FM'
		'Disable-FMFirewallPolicy'
		'Enable-FMFirewallPolicy'
		'Get-FMAddress'
		'Get-FMAddressGroup'
		'Get-FMAdomLockStatus'
		'Get-FMAdomRevision'
		'Get-FMDeviceInfo'
		'Get-FMFirewallHitCount'
		'Get-FMFirewallPolicy'
		'Get-FMFirewallScope'
		'Get-FMFirewallService'
		'Get-FMInterface'
		'Get-FMLastConnection'
		'Get-FMLog'
		'Get-FMPolicyPackage'
		'Get-FMSystemStatus'
		'Get-FMTaskResult'
		'Get-FMTaskStatus'
		'Invoke-FMAPI'
		'Lock-FMAdom'
		'Merge-FMStringHashMap'
		'Move-FMFirewallPolicy'
		'New-FMObjAddress'
		'New-FMObjAddressGroup'
		'New-FMObjDynamicAddressGroupMapping'
		'New-FMObjDynamicAddressMapping'
		'New-FMObjFirewallPolicy'
		'New-FMObjFirewallService'
		'New-FMObjInterface'
		'Publish-FMAdomChange'
		'Remove-FMAddress'
		'Remove-FMAddressGroup'
		'Remove-FMAdomRevision'
		'Rename-FMAddress'
		'Rename-FMAddressGroup'
		'Rename-FMInterface'
		'Remove-FMFirewallPolicy'
		'Remove-FMInterface'
		'Unlock-FMAdom'
		'Update-FMAddress'
		'Update-FMAddressGroup'
		'Update-FMAddressGroupMember'
		'Update-FMFirewallPolicy'
		'Update-FMFirewallService'
		'Update-FMInterface'
	)

	# Cmdlets to export from this module
	CmdletsToExport   = ''

	# Variables to export from this module
	VariablesToExport = ''

	# Aliases to export from this module
	AliasesToExport   = ''

	# List of all modules packaged with this module
	ModuleList        = @()

	# List of all files packaged with this module
	FileList          = @()

	# Private data to pass to the module specified in ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData       = @{

		#Support for PowerShellGet galleries.
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('Fortinet','Fortigate','FortiManager','FortinetManager')

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/Callidus2000/FortiManager/blob/master/LICENSE'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/Callidus2000/FortiManager/'

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			# ReleaseNotes = ''

		} # End of PSData hashtable

	} # End of PrivateData hashtable
}