# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-exam-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
}

# Container Apps Environment
resource "azurerm_container_app_environment" "cae" {
  name                           = "cae-exam-internal"
  location                       = azurerm_resource_group.rg.location
  resource_group_name            = azurerm_resource_group.rg.name
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.law.id
  infrastructure_subnet_id       = azurerm_subnet.private_aca.id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = true
}

# Container App
resource "azurerm_container_app" "app" {
  name                         = "ca-hello-world"
  container_app_environment_id = azurerm_container_app_environment.cae.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "hello-world"
      image  = "nginxdemos/hello"
      cpu    = 0.5
      memory = "1.0Gi"
    }
    min_replicas = 2
    max_replicas = 10
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}