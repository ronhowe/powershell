BeforeAll {
    # . $PSCommandPath.Replace(".Tests.ps1", ".ps1")
}

Describe "Integration Tests" {
    Context "Kestrel" -Tag "kestrel" {
        It "NullStatusCode" {
            $response = Invoke-WebRequest -Uri "https://localhost:444/"
            $response.StatusCode | Should -Be 200
        }
        It "NullContent" {
            $response = Invoke-WebRequest -Uri "https://localhost:444/"
            $response.Content | Should -Be "false"
        }
        It "TrueStatusCode" {
            $response = Invoke-WebRequest -Uri "https://localhost:444/?input=true"
            $response.StatusCode | Should -Be 200
        }
        It "TrueContent" {
            $response = Invoke-WebRequest -Uri "https://localhost:444/?input=true"
            $response.Content | Should -Be "true"
        }
        It "FalseStatusCode" {
            $response = Invoke-WebRequest -Uri "https://localhost:444/?input=false"
            $response.StatusCode | Should -Be 200
        }
        It "FalseContent" {
            $response = Invoke-WebRequest -Uri "https://localhost:444/?input=false"
            $response.Content | Should -Be "false"
        }
    }
    Context "AppService" -tag "appservice" {
        It "NullStatusCode" {
            $response = Invoke-WebRequest -Uri "https://app-ronhowe-000.azurewebsites.net/"
            $response.StatusCode | Should -Be 200
        }
        It "NullContent" {
            $response = Invoke-WebRequest -Uri "https://app-ronhowe-000.azurewebsites.net/"
            $response.Content | Should -Be "false"
        }
        It "TrueStatusCode" {
            $response = Invoke-WebRequest -Uri "https://app-ronhowe-000.azurewebsites.net/?input=true"
            $response.StatusCode | Should -Be 200
        }
        It "TrueContent" {
            $response = Invoke-WebRequest -Uri "https://app-ronhowe-000.azurewebsites.net/?input=true"
            $response.Content | Should -Be "true"
        }
        It "FalseStatusCode" {
            $response = Invoke-WebRequest -Uri "https://app-ronhowe-000.azurewebsites.net/?input=false"
            $response.StatusCode | Should -Be 200
        }
        It "FalseContent" {
            $response = Invoke-WebRequest -Uri "https://app-ronhowe-000.azurewebsites.net/?input=false"
            $response.Content | Should -Be "false"
        }
    }
}