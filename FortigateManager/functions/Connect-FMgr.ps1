function Connect-FMgr {
	<#
	.SYNOPSIS
	Creates a new Connection Object to a Fortigate Manager instance.

	.DESCRIPTION
	Creates a new Connection Object to a Fortigate Manager instance.

	.PARAMETER Credential
	Credential-Object for direct login.

	.PARAMETER Url
	The server root URL.

	.PARAMETER EnableException
	Should Exceptions been thrown?

	.EXAMPLE
	$connection=Connect-FMgr -Url $url -Credential $cred

	Connect directly with a Credential-Object

	.NOTES
	#>

	# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
	# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
	[CmdletBinding(DefaultParameterSetName = "credential")]
	Param (
		[parameter(mandatory = $true, ParameterSetName = "credential")]
		[PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FMgr.url")]
		[string]$Url,
		[parameter(mandatory = $true, ParameterSetName = "credential")]
		[pscredential]$Credential,
		[switch]$EnableException
	)
	begin {
	}
	end {
		$successFullConnected = $false
		$connection = Get-ARAHConnection -Url $Url -APISubPath ""
		Add-Member -InputObject $connection -MemberType NoteProperty -Name "forti" -Value @{
			requestId = 1
			session   = $null
		}
		$connection.ContentType = "application/json;charset=UTF-8"

		Write-PSFMessage "Stelle Verbindung her zu $Url" -Target $Url
		Invoke-PSFProtectedCommand -ActionString "Connect-FMgr.Connecting" -ActionStringValues $Url -Target $Url -ScriptBlock {

			$apiCallParameter = @{
				Connection     = $Connection
				method         = "exec"
				Path           = "sys/login/user"
				ParameterData = @{
					"passwd" = $Credential.GetNetworkCredential().Password
					"user"   = $Credential.UserName
				}
			}

			$result = Invoke-FMgrAPI @apiCallParameter
			$connection.authenticatedUser = $Credential.UserName
			if ($result.session) {
				$successFullConnected = $true
				$connection.forti.session= $result.session
			}
		} -PSCmdlet $PSCmdlet  -EnableException $EnableException
		if (Test-PSFFunctionInterrupt) { return }
		if ($successFullConnected) {
			Write-PSFMessage -string "Connect-FMgr.Connected"
			return $connection
		}
		Write-PSFMessage -string "Connect-FMgr.NotConnected" -Level Warning
	}
}