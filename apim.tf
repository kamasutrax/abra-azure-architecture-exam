# Public IP required for APIM in External VNet mode
resource "azurerm_public_ip" "apim_pip" {
  name                = "pip-apim-exam"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2"]
}

# API Management deployed in External mode for user ingress
resource "azurerm_api_management" "apim" {
  name                 = "apim-exam-gw"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  publisher_name       = "Exam Org"
  publisher_email      = "admin@exam.org"
  sku_name             = "Developer_1"
  
  virtual_network_type = "External"
  public_ip_address_id = azurerm_public_ip.apim_pip.id

  virtual_network_configuration {
    subnet_id = azurerm_subnet.private_apim.id
  }

  zones = ["1", "2"]
}

# API configuration routing traffic to the Application Gateway, enforcing HTTPS
resource "azurerm_api_management_api" "api" {
  name                = "hello-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Hello World API"
  path                = "hello"
  protocols           = ["https"]
  service_url         = "http://10.0.4.10"
}
