# Application Gateway
resource "azurerm_application_gateway" "appgw" {
  name                = "egges and azure"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  zones = ["1", "2", "3"]

  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = azurerm_subnet.private_appgw.id
  }

  frontend_ip_configuration {
    name                          = "frontend-private-ip"
    subnet_id                     = azurerm_subnet.private_appgw.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.4.10"
  }

  frontend_port {
    name = "port_80"
    port = 80
  }

  backend_address_pool {
    name  = "aca-backend-pool"
    fqdns = [azurerm_container_app.app.ingress[0].fqdn]
  }

  backend_http_settings {
    name                                = "https-settings"
    cookie_based_affinity               = "Disabled"
    port                                = 443
    protocol                            = "Https"
    request_timeout                     = 20
    pick_host_name_from_backend_address = true
  }

  http_listener {
    name                           = "http-listener"
    frontend_ip_configuration_name = "frontend-private-ip"
    frontend_port_name             = "port_80"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "rule1"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "http-listener"
    backend_address_pool_name  = "aca-backend-pool"
    backend_http_settings_name = "https-settings"
  }
}