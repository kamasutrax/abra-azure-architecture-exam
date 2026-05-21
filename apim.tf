# API Management
resource "azurerm_api_management" "apim" {
  name                = "apim-exam-internal-gw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  publisher_name      = "Exam Org"
  publisher_email     = "admin@exam.org"
  sku_name            = "Developer_1"

  virtual_network_type = "Internal"

  virtual_network_configuration {
    subnet_id = azurerm_subnet.private_apim.id
  }

  zones = ["1", "2"]
}

resource "azurerm_api_management_api" "api" {
  name                = "hello-api"
  resource_group_name = azurerm_resource_group.rg.name
  api_management_name = azurerm_api_management.apim.name
  revision            = "1"
  display_name        = "Hello World API"
  path                = "hello"
  protocols           = ["https", "http"]
  service_url         = "http://10.0.4.10"
}