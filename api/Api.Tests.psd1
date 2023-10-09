@{
    Endpoints = @(
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "Application"
                Platform     = "FrontDoor"
                Uri          = "https://rhowe-fwbuh9b9cxbdhrgs.z01.azurefd.net:443"
                CustomHeader = "app-rhowe-000"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "Application"
                Platform     = "Gateway"
                Uri          = "https://api-rhowe-000.azure-api.net:443/httpbin"
                CustomHeader = "app-rhowe-000"
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
                Uri          = "https://app-rhowe-000.azurewebsites.net:443"
                CustomHeader = "app-rhowe-000"
            }
        }
        @{
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-rhowe-001.azurewebsites.net:443"
                CustomHeader = "app-rhowe-001"
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
