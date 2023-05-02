param(
    [Parameter(Mandatory)]
    [Uri]$Uri
)
Describe "Integration Tests" {
    BeforeAll {
        Write-Host "Testing $Uri" -ForegroundColor Yellow
    }
    Context "WebApplication1" {
        It "HeaderExists" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Headers["x-custom-header"] | Should -Not -BeNullOrEmpty
        }
        It "HeaderIsCorrect" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Headers["x-custom-header"] | Should -Be "webApplication1"
        }
        It "NullStatusCode" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "NullContent" {
            $response = Invoke-WebRequest -Uri "$Uri/" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
        It "TrueStatusCode" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=true" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "TrueContent" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=true" -SkipCertificateCheck
            $response.Content | Should -Be "true"
        }
        It "FalseStatusCode" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=false" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "FalseContent" {
            $response = Invoke-WebRequest -Uri "$Uri/?input=false" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
    }
}