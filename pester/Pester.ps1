function Get-Planet {
    param(
        [string]$Name = "*"
    )
    @(
        @{ Name = "Mercury" }
        @{ Name = "Venus" }
        @{ Name = "Earth" }
        @{ Name = "Mars" }
        @{ Name = "Jupiter" }
        @{ Name = "Saturn" }
        @{ Name = "Uranus" }
        @{ Name = "Neptune" }
    ) |
    ForEach-Object { [PSCustomObject] $_ } |
    Where-Object { $_.Name -like $Name }
}
