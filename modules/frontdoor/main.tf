resource "azurerm_cdn_frontdoor_profile" "fd" {
  name                = var.frontdoor_name
  resource_group_name = var.rg_name
  sku_name            = "Premium_AzureFrontDoor" # Required for Private Link
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "${var.frontdoor_name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

resource "azurerm_cdn_frontdoor_origin_group" "og" {
  name                     = "aks-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
  
  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }

  health_probe {
    path                = "/healthz"
    protocol            = "Http"
    request_type        = "HEAD"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "aks_origin" {
  name                          = "aks-pls-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.og.id
  enabled                       = true

  # Basic settings (These are dummy values required by API when using Private Link)
  certificate_name_check_enabled = false
  host_name                      = "mylocal.internal" 
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = "mylocal.internal"
  priority                       = 1
  weight                         = 1000

  # THE CRITICAL PART: Private Link Connection
  private_link {
    request_message        = "Request access for Front Door"
    target_type            = "pl" # Private Link
    location               = var.location
    private_link_target_id = var.pls_id # We pass this ID from root main.tf
  }
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                          = "default-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.og.id
  supported_protocols           = ["Http", "Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpOnly" # Speak HTTP to the internal NGINX
  link_to_default_domain        = true
  https_redirect_enabled        = true
}