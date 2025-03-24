function Invoke-Request {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline)]
        [uri]
        $Uri,

        [Parameter()]
        [switch]
        $ContentOnly
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        $response = Invoke-WebRequest -Uri $Uri -UseBasicParsing

        if ($ContentOnly.IsPresent) {
            return $response.Content
        }
        else {
            return $response
        }
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}
