BeforeAll {
    # . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}

Describe "Integration Tests" {
    Context "Kestrel" -Tag "kestrel" {
        BeforeAll{
            New-Variable -Name "endpoint" -Value "localhost:444"
        }
        It "NullStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.StatusCode | Should -Be 200
        }
        It "NullContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.Content | Should -Be "false"
        }
        It "TrueStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.StatusCode | Should -Be 200
        }
        It "TrueContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.Content | Should -Be "true"
        }
        It "FalseStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.StatusCode | Should -Be 200
        }
        It "FalseContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.Content | Should -Be "false"
        }
    }
    Context "Docker" -Tag "docker" {
        BeforeAll{
            New-Variable -Name "endpoint" -Value "localhost:32768"
        }
        It "NullStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.StatusCode | Should -Be 200
        }
        It "NullContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.Content | Should -Be "false"
        }
        It "TrueStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.StatusCode | Should -Be 200
        }
        It "TrueContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.Content | Should -Be "true"
        }
        It "FalseStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.StatusCode | Should -Be 200
        }
        It "FalseContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.Content | Should -Be "false"
        }
    }
    Context "AppService" -tag "appservice" {
        BeforeAll{
            New-Variable -Name "endpoint" -Value "app-ronhowe-000.azurewebsites.net"
        }
        It "NullStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.StatusCode | Should -Be 200
        }
        It "NullContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.Content | Should -Be "false"
        }
        It "TrueStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.StatusCode | Should -Be 200
        }
        It "TrueContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.Content | Should -Be "true"
        }
        It "FalseStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.StatusCode | Should -Be 200
        }
        It "FalseContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.Content | Should -Be "false"
        }
    }
    Context "ApiGateway" -tag "apigateway" {
        BeforeAll{
            New-Variable -Name "endpoint" -Value "apim-ronhowe-000.azure-api.net/httpbin/v1"
        }
        It "NullStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.StatusCode | Should -Be 200
        }
        It "NullContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/"
            $response.Content | Should -Be "false"
        }
        It "TrueStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.StatusCode | Should -Be 200
        }
        It "TrueContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=true"
            $response.Content | Should -Be "true"
        }
        It "FalseStatusCode" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.StatusCode | Should -Be 200
        }
        It "FalseContent" {
            $response = Invoke-WebRequest -Uri "https://$endpoint/?input=false"
            $response.Content | Should -Be "false"
        }
    }
}