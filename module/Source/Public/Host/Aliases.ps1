# CLI entries should automatically be exported by the module build.
New-Alias -Name "catfact" -Value "Get-CatFact" -Force -Scope Global
New-Alias -Name "date" -Value "Show-Date" -Force -Scope Global
New-Alias -Name "kernel" -Value "Start-Kernel" -Scope Global -Force
New-Alias -Name "logo" -Value "Show-Logo" -Force -Scope Global
New-Alias -Name "quote" -Value "Get-Quote" -Force -Scope Global
New-Alias -Name "ready" -Value "Show-Ready" -Force -Scope Global
New-Alias -Name "version" -Value "Show-Version" -Force -Scope Global
New-Alias -Name "weather" -Value "Get-Weather" -Force -Scope Global
