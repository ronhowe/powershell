param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $true)]
    [string]$Platform,

    [Parameter(Mandatory = $true)]
    [Uri]$Uri,

    [Parameter(Mandatory = $true)]
    [string]$CustomHeader,

    [Parameter(Mandatory = $false)]
    [string]$Code = (Get-Secret -Name "function-app-code" -Vault "ronhowe-secret-vault" -AsPlainText)
)
Describe "IntegrationTests" {
    BeforeAll {
        Write-Host (Get-Date).ToString() -ForegroundColor Yellow
    }
    Context "<Name> (<Platform>) @ <Uri>" {
        It "ApplicationHeaderExists" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Not -BeNullOrEmpty
        }
        It "ApplicationHeaderIsCorrect [<CustomHeader>]" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Be $CustomHeader
        }
        It "ApplicationRespondsOKFromNullInput" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsFalseFromNullInput" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
        It "ApplicationRespondsOKFromTrueInput" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code&input=true" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsTrueFromTrueInput" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code&input=true" -SkipCertificateCheck
            $response.Content | Should -Be "true"
        }
        It "ApplicationRespondsOKFromFalseInput" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code&input=false" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsFalseFromFalseInput" -Tag "api" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?code=$Code&input=false" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
        It "HealthCheckRespondsOK" -Tag "healthcheck" {
            $response = Invoke-WebRequest -Uri "$Uri/health" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "HealthCheckReturnsHealthy" -Tag "healthcheck" {
            $response = Invoke-WebRequest -Uri "$Uri/health" -SkipCertificateCheck
            $response.Content | Should -Be "Healthy"
        }
    }
    AfterAll {
        Write-Ascii $Name
    }
}
