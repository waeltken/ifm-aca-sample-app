locals {
  resource_group_name = "${var.application_name}-rg"
}

data "azurerm_resource_group" "environment" {
  name = var.aca_env_resource_group_name
}

data "azurerm_container_app_environment" "default" {
  name                = var.aca_env_name
  resource_group_name = var.aca_env_resource_group_name
}

resource "azurerm_resource_group" "default" {
  name     = local.resource_group_name
  location = data.azurerm_resource_group.environment.location
}

resource "azurerm_container_app" "default" {
  name                         = var.application_name
  container_app_environment_id = data.azurerm_container_app_environment.default.id
  resource_group_name          = azurerm_resource_group.default.name
  revision_mode                = "Single"

  template {
    container {
      name   = var.application_name
      image  = "nginx:latest"
      cpu    = 2
      memory = "4Gi"
      readiness_probe {
        transport = "TCP"
        port      = 80
      }
    }
  }

  # Allow public ingress traffic
  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  lifecycle {
    ignore_changes = [template.0.container.0.image]
  }
}
