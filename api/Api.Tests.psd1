@{
    Endpoints = @(
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "FrontDoor"
                Uri          = "https://ronhowe-fwbuh9b9cxbdhrgs.z01.azurefd.net:443"
                CustomHeader = "app-ronhowe-000"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "Gateway"
                Uri          = "https://api-ronhowe-000.azure-api.net:443/httpbin"
                CustomHeader = "app-ronhowe-000"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "Kestrel"
                Uri          = "https://localhost:444"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "Docker"
                Uri          = "TBD"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-ronhowe-0.azurewebsites.net:443"
                CustomHeader = "app-ronhowe-0"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-ronhowe-1.azurewebsites.net:443"
                CustomHeader = "app-ronhowe-1"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "Kestrel"
                Uri          = "http://localhost:83/api"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "Docker"
                Uri          = "TBD"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "FunctionApp"
                Uri          = "TBD"
                CustomHeader = "default"
            }
        }
    )
}
