#requires -module "WriteAscii"

Write-Ascii "az" -ForegroundColor Green
az --version

Write-Ascii "bicep" -ForegroundColor Green
bicep --version

Write-Ascii "code" -ForegroundColor Green
code --version

Write-Ascii "dotnet" -ForegroundColor Green
dotnet --version

Write-Ascii "gh" -ForegroundColor Green
gh --version

Write-Ascii "git" -ForegroundColor Green
git --version

Write-Ascii "nuget" -ForegroundColor Green
nuget | Select-String -SimpleMatch "NuGet Version"

Write-Ascii "pwsh" -ForegroundColor Green
pwsh --version

Write-Ascii "python" -ForegroundColor Green
python --version

Write-Ascii "wsl" -ForegroundColor Green
wsl --version
