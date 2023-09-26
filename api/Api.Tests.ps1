param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $true)]
    [string]$Platform,

    [Parameter(Mandatory = $true)]
    [Uri]$Uri,

    [Parameter(Mandatory = $true)]
    [string]$CustomHeader
)
Describe "IntegrationTests" {
    BeforeAll {
        Write-Host (Get-Date).ToString() -ForegroundColor Yellow
    }
    Context "<Name> (<Platform>) @ <Uri>" {
        It "ApplicationHeaderExists" -Tag "application" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=false" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Not -BeNullOrEmpty
        }
        It "ApplicationHeaderIsCorrect [<CustomHeader>]" -Tag @("application", "ping") {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=false" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Be $CustomHeader
        }
        It "ApplicationRespondsBadRequestOKFromNullInput" -Tag "application" {
            $response = Invoke-WebRequest -Uri "$Uri/service1" -SkipCertificateCheck -SkipHttpErrorCheck
            $response.StatusCode | Should -Be 400
        }
        It "ApplicationRespondsOKFromTrueInput" -Tag "application" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=true" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsTrueFromTrueInput" -Tag "application" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=true" -SkipCertificateCheck
            $response.Content | Should -Be "true"
        }
        It "ApplicationRespondsOKFromFalseInput" -Tag "application" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=false" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsFalseFromFalseInput" -Tag "application" {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=false" -SkipCertificateCheck
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
