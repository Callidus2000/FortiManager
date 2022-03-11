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
		$connection = Get-ARAHConnection -Url $Url -APISubPath "/jsonrpc"
		$connection.ContentType = "application/json;charset=UTF-8"

		Write-PSFMessage "Stelle Verbindung her zu $Url" -Target $Url
		Invoke-PSFProtectedCommand -ActionString "Connect-FMgr.Connecting" -ActionStringValues $Url -Target $Url -ScriptBlock {
			$apiCallParameter = @{
				Connection = $Connection
				method     = "Post"
				Path       = ""
				Body       =
				@{
					"id"      = 1
					"method"  = "exec"
					"params"  = @(
						@{
							"data" = @(
								@{
									"passwd" = $Credential.GetNetworkCredential().Password
									"user"   = $Credential.UserName
								}
							)
							"url"  = "sys/login/user"
						}
					)
					"session" = $null
					"verbose" = 1
				}

			}
			$result = Invoke-FMgrAPI @apiCallParameter
			$connection.authenticatedUser = $Credential.UserName
			if ($result.session) {
				$successFullConnected = $true
				$connection.headers.Add("session", $result.session)
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