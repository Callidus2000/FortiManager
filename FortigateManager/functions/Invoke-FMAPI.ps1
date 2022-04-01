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

    .PARAMETER EnablePaging
    If the API makes use of paging (therefor of limit/offset URLParameter) setting EnablePaging to $true will not return the raw data but a combination of all data sets.

    .PARAMETER EnableException
    If set to true, inner exceptions will be rethrown. Otherwise the an empty result will be returned.

    .EXAMPLE
    $result = Invoke-FMAPI -connection $this -path "" -method POST -body @{login = $credentials.UserName; password = $credentials.GetNetworkCredential().Password; language = "1"; authType = "sql" } -hideparameters $true

    Login to the service

    .NOTES
    General notes
    #>

    param (
        [parameter(Mandatory)]
        $Connection,
        [parameter(Mandatory)]
        [string]$Path,
        [Hashtable[]]$Parameter,
        [parameter(Mandatory)]
        [ValidateSet("get", "set", "add", "update", "delete", "clone", "exec")]
        $Method,
        [bool]$EnableException=$true,
        [switch]$EnablePaging
    )
    $existingSession = $connection.forti.session
    $requestId = $connection.forti.requestId
    $connection.forti.requestId = $connection.forti.requestId + 1

    $apiCallParameter = @{
        Connection = $Connection
        method     = "Post"
        Path       = "/jsonrpc"
        Body       =  @{
            "id"      = $requestId
            "method"  = "$Method"
            "params"  = @(
                @{
                    # "data" = @($Parameter                    )
                    "url"  = "$Path"
                }
            )
            "session" = $existingSession
            "verbose" = 1
        }
    }
    if ($Parameter){
        $global:hubba=$apiCallParameter
        $Parameter | ForEach-Object { $apiCallParameter.body.params[0] += $_}
        # $apiCallParameter.body.params[0]+=$Parameter
    }

    # $apiCallParameter.Body.params[0].url=$Path
    return Invoke-ARAHRequest @apiCallParameter #-PagingHandler 'FM.PagingHandler'
}