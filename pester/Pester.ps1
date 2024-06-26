function Get-Planet {
    param(
        [string]$Name = "*"
    )
    $planets = @(
        @{ Name = "Mercury" }
        @{ Name = "Venus" }
        @{ Name = "Earth" }
        @{ Name = "Mars" }
        @{ Name = "Jupiter" }
        @{ Name = "Saturn" }
        @{ Name = "Uranus" }
        @{ Name = "Neptune" }
    ) | ForEach-Object { [pscustomobject] $_ }

    $planets | Where-Object { $_.Name -like $Name }
}
