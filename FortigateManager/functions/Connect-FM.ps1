function Connect-FM {
	<#
	.SYNOPSIS
	Creates a new Connection Object to a Fortigate Manager instance.

	.DESCRIPTION
	Creates a new Connection Object to a Fortigate Manager instance.

	.PARAMETER Credential
	Credential-Object for direct login.

	.PARAMETER Url
	The server root URL.

	.PARAMETER ADOM
	The default ADOM for the requests.

	.PARAMETER EnableException
	Should Exceptions been thrown?

	.EXAMPLE
	$connection=Connect-FM -Url $url -Credential $cred

	Connect directly with a Credential-Object

	.NOTES
	#>

	# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
	# [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
	[CmdletBinding(DefaultParameterSetName = "credential")]
	Param (
		[parameter(mandatory = $true, ParameterSetName = "credential")]
		[PSFramework.TabExpansion.PsfArgumentCompleterAttribute("FM.url")]
		[string]$Url,
		[parameter(mandatory = $false, ParameterSetName = "credential")]
		[string]$ADOM,
		[parameter(mandatory = $true, ParameterSetName = "credential")]
		[pscredential]$Credential,
		[bool]$EnableException = $true
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

		$apiCallParameter = @{
			Connection      = $Connection
			EnableException = $EnableException
			method          = "exec"
			Path            = "sys/login/user"
			LoggingAction   = "Connect-FM"
			LoggingActionValues = @($Url, $Credential.UserName)
			Parameter       = @{
				"data" = @{
					"passwd" = $Credential.GetNetworkCredential().Password
					"user"   = $Credential.UserName
				}
			}
		}

		# Invoke-PSFProtectedCommand -ActionString "Connect-FM.Connecting" -ActionStringValues $Url -Target $Url -ScriptBlock {
			$result = Invoke-FMAPI @apiCallParameter
			if ($null -eq $result) {
				Stop-PSFFunction -Message "No API Results" -EnableException $EnableException
			}
		# } -PSCmdlet $PSCmdlet  -EnableException $EnableException
		if (Test-PSFFunctionInterrupt) {
			Write-PSFMessage "Test-PSFFunctionInterrupt"
			return
		}
		$connection.authenticatedUser = $Credential.UserName
		if ($result.session) {
			$successFullConnected = $true
			$connection.forti.session = $result.session
		}
		if ($ADOM) {
			$connection.forti.defaultADOM = $ADOM
		}
		if ($successFullConnected) {
			Write-PSFMessage -string "Connect-FM.Connected"
			return $connection
		}
		Write-PSFMessage -string "Connect-FM.NotConnected" -Level Warning
	}
}