function Get-Version {
    [CmdletBinding()]
    param ()
    begin {
    }
    process {
        return (Get-Module -Name "Shell").Version.ToString()
    }
    end {
    }
}