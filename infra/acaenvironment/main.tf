locals {
  location            = var.location
  resource_group_name = "${var.environment_name}-rg"
  tags = {
    environment = var.environment_name
    Company     = "REPLACEME"
    CostCenter  = "REPLACEME"
    Owner       = "REPLACEME"
    Purpose     = "REPLACEME"
    ContactMail = "REPLACEME"
  }
}

resource "random_string" "random" {
  length  = 4
  special = false
  lower   = true
  upper   = false
}

# Deploy resource group
resource "azurerm_resource_group" "default" {
  name     = local.resource_group_name
  location = local.location

  tags = local.tags
}

resource "azurerm_virtual_network" "default" {
  name                = "${var.environment_name}-vnet"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "${var.environment_name}-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/21"]
}

# resource "azurerm_network_security_group" "default" {
#   name                = "${var.environment_name}-nsg"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
# }

# resource "azurerm_network_security_rule" "https" {
#   name                        = "${var.environment_name}-https"
#   priority                    = 100
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "443"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.default.name
#   network_security_group_name = azurerm_network_security_group.default.name
# }

# resource "azurerm_network_security_rule" "http" {
#   name                        = "${var.environment_name}-http"
#   priority                    = 101
#   direction                   = "Inbound"
#   access                      = "Allow"
#   protocol                    = "Tcp"
#   source_port_range           = "*"
#   destination_port_range      = "80"
#   source_address_prefix       = "*"
#   destination_address_prefix  = "*"
#   resource_group_name         = azurerm_resource_group.default.name
#   network_security_group_name = azurerm_network_security_group.default.name
# }

# resource "azurerm_subnet_network_security_group_association" "default" {
#   subnet_id                 = azurerm_subnet.default.id
#   network_security_group_id = azurerm_network_security_group.default.id
# }

resource "azurerm_log_analytics_workspace" "default" {
  name                = "${var.environment_name}-log-analytics"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_container_app_environment" "default" {
  name                     = "${var.environment_name}-aca-env"
  location                 = azurerm_resource_group.default.location
  resource_group_name      = azurerm_resource_group.default.name
  infrastructure_subnet_id = azurerm_subnet.default.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.environment_name}acr${random_string.random.result}"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  sku                 = "Basic"
}

# resource "azurerm_user_assigned_identity" "acr" {
#   name                = "${var.environment_name}-acr-identity"
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
# }

# resource "azurerm_role_assignment" "acr_reader" {
#   scope                = azurerm_container_registry.acr.id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_user_assigned_identity.acr.principal_id
# }
