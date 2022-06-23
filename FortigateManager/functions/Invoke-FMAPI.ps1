function Invoke-FMAPI {
    <#
    .SYNOPSIS
    Generic API Call to the Fortigate Manager API.

    .DESCRIPTION
    Generic API Call to the Fortigate Manager API. This function is a wrapper for the usage of Invoke-WebRequest. It handles some annoying repetitive tasks which occur in most use cases. This includes (list may be uncompleted)
    - Connecting to a server with authentication
    - Parsing API parameter
    - Handling $null parameter
    - Paging for API endpoints which do only provide limited amounts of datasets

    .PARAMETER Connection
    Object of Class , stores the authentication Token and the API Base-URL. Can be obtained with Connect-FM.

    .PARAMETER Path
    API Path to the REST function

    .PARAMETER Body
    Parameter for the API call; The hashtable is Converted to the POST body by using ConvertTo-Json

    .PARAMETER Header
    Additional Header Parameter for the API call; currently dropped but needed as a parameter for the *-FMAR* functions

    .PARAMETER URLParameter
    Parameter for the API call; Converted to the GET URL parameter set.
    Example:
    {
        id=4
        name=Jon Doe
    }
    will result in "?id=4&name=Jon%20Doe" being added to the URL Path

    .PARAMETER Method
    HTTP Method, Get/Post/Delete/Put/...

    .PARAMETER ContentType
    HTTP-ContentType, defaults to "application/json;charset=UTF-8"

    .PARAMETER Parameter
    The values for the parameter body part of the API request.

    .PARAMETER LoggingAction
    compare ~\FortigateManager\en-us\strings.psd1
    The given string with the prefix "APICall." will be used for logging purposes.

    .PARAMETER LoggingActionValues
    compare ~\FortigateManager\en-us\strings.psd1
    Array of placeholder values.

    .PARAMETER LoggingLevel
    On which level should die diagnostic Messages be logged?
    Defaults to PSFConfig "FortigateManager.Logging.Api"

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    $result = Invoke-FMAPI -connection $this -path "" -method POST -body @{login = $credentials.UserName; password = $credentials.GetNetworkCredential().Password; language = "1"; authType = "sql" } -hideparameters $true

    Login to the service

    .NOTES
    General notes
    #>
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Medium')]

    param (
        [parameter(ParameterSetName = "pathOnly")]
        [parameter(ParameterSetName = "parameterOnly")]
        [parameter(ParameterSetName = "pathAndParameter")]
        $Connection = (Get-FMLastConnection),
        [parameter(mandatory = $true, ParameterSetName = "pathOnly")]
        [parameter(mandatory = $true, ParameterSetName = "pathAndParameter")]
        [string]$Path,
        [parameter(mandatory = $true, ParameterSetName = "pathAndParameter")]
        [parameter(mandatory = $true, ParameterSetName = "parameterOnly")]
        [Hashtable[]]$Parameter,
        [parameter(mandatory = $true)]
        [ValidateSet("get", "set", "add", "update", "delete", "clone", "exec", "move", "clone")]
        $Method,
        [bool]$EnableException = $true,
        [string]$LoggingAction = "Invoke-FMAPI",
        [ValidateSet("Critical", "Important", "Output", "Host", "Significant", "VeryVerbose", "Verbose", "SomewhatVerbose", "System", "Debug", "InternalComment", "Warning")]
        [string]$LoggingLevel = (Get-PSFConfigValue -FullName "FortigateManager.Logging.Api" -Fallback "Verbose"),
        [string[]]$LoggingActionValues = ""
    )
    if (-not $Connection) {
        Write-PSFMessage "Keine Connection als Parameter erhalten, frage die letzte ab"
        $Connection = Get-FMLastConnection -EnableException $EnableException
        if (-not $Connection) {
            Stop-PSFFunction "No last connection available" -EnableException $EnableException -AlwaysWarning
            return
        }
    }
    $existingSession = $connection.forti.session
    $requestId = $connection.forti.requestId
    $connection.forti.requestId = $connection.forti.requestId + 1

    $apiCallParameter = @{
        EnableException = $true
        Connection      = $Connection
        method          = "Post"
        Path            = "/jsonrpc"
        Body            = @{
            "id"      = $requestId
            "method"  = "$Method"
            "params"  = @(
                # @{
                #     # "data" = @($Parameter                    )
                #     "url" = "$Path"
                # }
            )
            "session" = $existingSession
            "verbose" = 1
        }
    }
    if ($Parameter) {
        # $global:hubba = $apiCallParameter
        $Parameter | ForEach-Object {
            if ([string]::IsNullOrEmpty($_.url)){$_.url=$Path}
            $apiCallParameter.body.params+= $_
        }
        # $apiCallParameter.body.params[0]+=$Parameter
    }else{
        # No parameter given, use only the $Path url
        $apiCallParameter.body.params += @{}
    }
    if (-not [string]::IsNullOrEmpty($Path)){
        $apiCallParameter.body.params | ForEach-Object {
            if ([string]::IsNullOrEmpty($_.url)) { $_.url = $Path }
        }
    }

    # $apiCallParameter.Body.params[0].url=$Path
    # Invoke-PSFProtectedCommand -ActionString "APICall.$LoggingAction" -ActionStringValues $Url -Target $Url -ScriptBlock {
    Invoke-PSFProtectedCommand -ActionString "APICall.$LoggingAction" -ActionStringValues $LoggingActionValues -ScriptBlock {
        $result = Invoke-ARAHRequest @apiCallParameter #-PagingHandler 'FM.PagingHandler'
        # if ($null -eq $result) {
        #     Stop-PSFFunction -Message "ADOM could not be locked" -EnableException $EnableException -AlwaysWarning
        #     return $false
        # }
        # elseif (-not $EnableException) { return $true }

        if ($null -eq $result) {
            Stop-PSFFunction -Message "No Result delivered" -EnableException $true
            return $false
        }
        $statusCode = $result.result.status.code
        if ($statusCode -ne 0) {
            # Write-PSFMessage -Level Warning "Could not get Lockstatus of ADOM $explicitADOM"
            Stop-PSFFunction -Message "API-Error, statusCode: $statusCode, Message $($result.result.status.Message)" -EnableException $true -StepsUpward 3 #-AlwaysWarning
            # Throw "API-Error, statusCode: $statusCode, Message $($result.result.status.Message)" #-EnableException $true -StepsUpward 3 #-AlwaysWarning
            return
        }
        return $result

        # } -PSCmdlet $PSCmdlet  -EnableException $EnableException -Level (Get-PSFConfigValue -FullName "FortigateManager.Logging.Api" -Fallback "Verbose")
    } -PSCmdlet $PSCmdlet  -EnableException $false -Level $LoggingLevel
    if ((Test-PSFFunctionInterrupt) -and $EnableException) {
        Throw "API-Error, statusCode: $statusCode, Message $($result.result.status.Message)" #-EnableException $true -StepsUpward 3 #-AlwaysWarning
    }
}