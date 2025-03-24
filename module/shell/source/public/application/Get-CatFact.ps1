function Get-CatFact {
    [CmdletBinding()]
    param(
    )
    begin {
        Write-Debug "Beginning $($MyInvocation.MyCommand.Name)"
    }
    process {
        Write-Debug "Processing $($MyInvocation.MyCommand.Name)"

        $result = Invoke-Request -Uri "https://catfact.ninja/fact" -ContentOnly |
        ConvertFrom-Json |
        Select-Object -ExpandProperty "fact"

        return $result
    }
    end {
        Write-Debug "Ending $($MyInvocation.MyCommand.Name)"
    }
}

New-Alias -Name "catfact" -Value "Get-CatFact" -Force -Scope Global
