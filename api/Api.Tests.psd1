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
            Enabled  = $false
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "Docker"
                Uri          = "TBD"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-rhowe-000.azurewebsites.net:443"
                CustomHeader = "app-rhowe-000"
            }
        }
        @{
            Enabled  = $false
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
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "Gateway"
                Uri          = "TBD"
                CustomHeader = "default"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "FrontDoor"
                Uri          = "rhowe-fwbuh9b9cxbdhrgs.z01.azurefd.net"
                CustomHeader = "default"
            }
        }
    )
}
