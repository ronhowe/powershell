param(
    [Parameter(Mandatory)]
    [Uri]$Uri
)
Describe "Integration Tests" {
    BeforeAll {
        Write-Host "Testing $Uri" -ForegroundColor Yellow
    }
    Context "WebApplication1" {
        It "ApplicationHeaderExists" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Headers["x-custom-header"] | Should -Not -BeNullOrEmpty
        }
        It "ApplicationHeaderIsCorrect" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Headers["x-custom-header"] | Should -Be "webApplication1"
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
}