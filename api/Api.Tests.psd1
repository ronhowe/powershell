@{
    Endpoints = @(
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "Kestrel"
                Uri          = "https://localhost:444"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "Docker"
                Uri          = "http://localhost:82"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-ronhowe-000.azurewebsites.net:443"
                CustomHeader = "appcs-ronhowe-000"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "Kestrel"
                Uri          = "http://localhost:83/api"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "Docker"
                Uri          = "http://localhost:84/api"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "FunctionApp"
                Uri          = "https://func-ronhowe-000.azurewebsites.net/api"
                CustomHeader = "func-ronhowe-000"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "Application"
                Platform     = "Gateway"
                Uri          = "https://apim-ronhowe-000.azure-api.net:443/httpbin/v1"
                CustomHeader = "apim-ronhowe-000"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "Application"
                Platform     = "FrontDoor"
                Uri          = "https://fd-rhowe-000-fsaheecndqcvbthb.z01.azurefd.net/httpbin/v1"
                CustomHeader = "apim-ronhowe-000"
            }
        }
    )
}
