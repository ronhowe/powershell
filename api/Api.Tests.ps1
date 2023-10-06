#requires -module "PSPolly"
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
        It "ClientRetries" -Tag @("healthcheck", "ping", "polly") {
            $policy = New-PollyPolicy -Retry -RetryCount 10 -RetryWait (New-TimeSpan -Seconds 1)
            Invoke-PollyCommand -Policy $policy -ScriptBlock {
                # note - the best way to get feedback mid-test is with Write-Host
                Write-Host "`tInvoking Web Request within Polly Policy.." -ForegroundColor DarkGray
                $response = Invoke-WebRequest -Uri "$Uri/health" -SkipCertificateCheck
                $response.StatusCode | Should -Be 200
            }
        }
        It "ApplicationHeaderIsCorrect [<CustomHeader>]" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=false" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Be $CustomHeader
        }
        It "ApplicationRespondsNotFoundFromInvalidRoute" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri" -SkipCertificateCheck -SkipHttpErrorCheck
            $response.StatusCode | Should -Be 404
        }
        It "ApplicationRespondsBadRequestOKFromNullInput" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/service1" -SkipCertificateCheck -SkipHttpErrorCheck
            $response.StatusCode | Should -Be 400
        }
        It "ApplicationRespondsOKFromTrueInput" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=true" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsTrueFromTrueInput" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=true" -SkipCertificateCheck
            $response.Content | Should -Be "true"
        }
        It "ApplicationRespondsOKFromFalseInput" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=false" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "ApplicationReturnsFalseFromFalseInput" -Tag @("application") {
            $response = Invoke-WebRequest -Uri "$Uri/service1?input=false" -SkipCertificateCheck
            $response.Content | Should -Be "false"
        }
        It "HealthCheckRespondsOK" -Tag @("healthcheck", "ping") {
            $response = Invoke-WebRequest -Uri "$Uri/health" -SkipCertificateCheck
            $response.StatusCode | Should -Be 200
        }
        It "HealthCheckReturnsHealthy" -Tag @("healthcheck") {
            $response = Invoke-WebRequest -Uri "$Uri/health" -SkipCertificateCheck
            $response.Content | Should -Be "Healthy"
        }
        It "HealthCheckHeaderIsCorrect [<CustomHeader>]" -Tag @("healthcheck") {
            $response = Invoke-WebRequest -Uri "$Uri/health" -SkipCertificateCheck
            $response.Headers["CustomHeader"] | Should -Be $CustomHeader
        }
    }
    AfterAll {
        Write-Ascii $Name
    }
}
