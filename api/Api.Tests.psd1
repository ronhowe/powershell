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
            Enabled  = $true
            Endpoint = @{
                Name         = "WebApplication1"
                Platform     = "AppService"
                Uri          = "https://app-rhowe-000.azurewebsites.net:443"
                CustomHeader = "config-rhowe-000"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "FunctionApp1"
                Platform     = "Kestrel"
                Uri          = "TBD"
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
                CustomHeader = "func-rhowe-000"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "Gateway"
                Uri          = "TBD"
                CustomHeader = "apim-rhowe-000"
            }
        }
        @{
            Enabled  = $false
            Endpoint = @{
                Name         = "Application"
                Platform     = "FrontDoor"
                Uri          = "TBD"
                CustomHeader = "apim-rhowe-000"
            }
        }
    )
}
