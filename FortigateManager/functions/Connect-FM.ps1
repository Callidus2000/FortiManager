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

    .PARAMETER SkipCheck
    Array of checks which should be skipped while using Invoke-WebRequest.
    Possible Values 'CertificateCheck', 'HttpErrorCheck', 'HeaderValidation'.
    If neccessary by default for the connection set $connection.SkipCheck

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
		[ValidateSet('CertificateCheck', 'HttpErrorCheck', 'HeaderValidation')]
		[String[]]$SkipCheck,
		[bool]$EnableException = $true
	)
	begin {
	}
	end {
		$connection = Get-ARAHConnection -Url $Url -APISubPath ""
		if ($SkipCheck) { $connection.SkipCheck = $SkipCheck}
		Add-Member -InputObject $connection -MemberType NoteProperty -Name "forti" -Value @{
			requestId = 1
			session   = $null
			EnableException=$EnableException
		}
		$connection.credential = $Credential
		$connection.ContentType = "application/json;charset=UTF-8"
		$connection.authenticatedUser = $Credential.UserName
		if ($ADOM) {
			$connection.forti.defaultADOM = $ADOM
		}

		Add-Member -InputObject $connection -MemberType ScriptMethod -Name "Refresh" -Value {
			$functionName = "Connect-FM>Refresh"
			Write-PSFMessage "Stelle Verbindung her zu $($this.ServerRoot)" -Target $this.ServerRoot -FunctionName $functionName

			$apiCallParameter = @{
				Connection          = $this
				EnableException     = $this.forti.EnableException
				method              = "exec"
				Path                = "sys/login/user"
				LoggingAction       = "Connect-FM"
				LoggingActionValues = @($this.ServerRoot, $this.Credential.UserName)
				Parameter           = @{
					"data" = @{
						"passwd" = $this.Credential.GetNetworkCredential().Password
						"user"   = $this.Credential.UserName
					}
				}
			}

			# Invoke-PSFProtectedCommand -ActionString "Connect-FM.Connecting" -ActionStringValues $Url -Target $Url -ScriptBlock {
			$result = Invoke-FMAPI @apiCallParameter
			if ($null -eq $result) {
				Stop-PSFFunction -Message "No API Results" -EnableException $EnableException -FunctionName $functionName
			}
			# } -PSCmdlet $PSCmdlet  -EnableException $EnableException
			if (Test-PSFFunctionInterrupt) {
				Write-PSFMessage "Test-PSFFunctionInterrupt" -FunctionName $functionName
				return
			}
			if ($result.session) {
				$this.forti.session = $result.session
			}
		}
		$connection.Refresh()
		if ($connection.forti.session) {
			Write-PSFMessage -string "Connect-FM.Connected"
			Set-PSFConfig -Module 'FortigateManager' -Name 'LastConnection' -Value $connection -Description "Last known Connection" -AllowDelete
			return $connection
		}
		Write-PSFMessage -string "Connect-FM.NotConnected" -Level Warning
	}
}