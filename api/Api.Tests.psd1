@{
    Endpoints = @(
        @{ Enabled = $true ; Endpoint = @{ Name = "Front Door" ; Uri = "https://fd-rhowe-000-fsaheecndqcvbthb.z01.azurefd.net/httpbin/v1" ; CustomHeader = "apim-ronhowe-000" } }
        @{ Enabled = $true ; Endpoint = @{ Name = "Gateway" ; Uri = "https://apim-ronhowe-000.azure-api.net:443/httpbin/v1"; CustomHeader = "apim-ronhowe-000" } }
        @{ Enabled = $true ; Endpoint = @{ Name = "App Service" ; Uri = "https://app-ronhowe-000.azurewebsites.net:443"; CustomHeader = "app-ronhowe-000" } }
        @{ Enabled = $true ; Endpoint = @{ Name = "Kestrel" ; Uri = "https://localhost:444"; CustomHeader = "default" } }
        # @{ Enabled = $true ; Endpoint = @{ Name = "Docker (Web Application)" ; Uri = "http://localhost:82"; CustomHeader = "default" } }
        # @{ Enabled = $true ; Endpoint = @{ Name = "Docker (Function App)" ; Uri = "http://localhost:84/api"; CustomHeader = "default" } }
        @{ Enabled = $true ; Endpoint = @{ Name = "Function App" ; Uri = "http://localhost:83/api"; CustomHeader = "default" } }
    )
}
