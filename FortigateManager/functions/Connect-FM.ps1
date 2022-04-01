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
		Invoke-PSFProtectedCommand -ActionString "Connect-FM.Connecting" -ActionStringValues $Url -Target $Url -ScriptBlock {

			$apiCallParameter = @{
				Connection     = $Connection
				method         = "exec"
				Path           = "sys/login/user"
				Parameter = @{
					"data"=@{
					"passwd" = $Credential.GetNetworkCredential().Password
					"user"   = $Credential.UserName
					}
				}
			}

			$result = Invoke-FMAPI @apiCallParameter
			$connection.authenticatedUser = $Credential.UserName
			if ($result.session) {
				$successFullConnected = $true
				$connection.forti.session= $result.session
			}
			if($ADOM){
				$connection.forti.defaultADOM= $ADOM
			}
		} -PSCmdlet $PSCmdlet  -EnableException $EnableException
		if (Test-PSFFunctionInterrupt) { return }
		if ($successFullConnected) {
			Write-PSFMessage -string "Connect-FM.Connected"
			return $connection
		}
		Write-PSFMessage -string "Connect-FM.NotConnected" -Level Warning
	}
}