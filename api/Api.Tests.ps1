param(
    [Parameter(Mandatory)]
    [string]$Name,
    [Parameter(Mandatory)]
    [Uri]$Uri,
    [Parameter(Mandatory)]
    [string]$CustomHeader
)
Describe "IntegrationTests" {
    BeforeAll {
        Write-Host (Get-Date).ToString() -ForegroundColor Yellow
    }
    Context "[<Name>] @ [<Uri>]" {
        It "ApplicationHeaderExists" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Not -BeNullOrEmpty
        }
        It "ApplicationHeaderIsCorrect [<CustomHeader>]" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Be $CustomHeader
        }
        It "ApplicationRespondsOKFromNullInput" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsFalseFromNullInput" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
        It "ApplicationRespondsOKFromTrueInput" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=true" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsTrueFromTrueInput" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=true" -SkipCertificateCheck
            $response.Content | Should -Be "true"
        }
        It "ApplicationRespondsOKFromFalseInput" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=false" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsFalseFromFalseInput" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=false" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
    }
    AfterAll {
        Write-Ascii $Name
    }
}