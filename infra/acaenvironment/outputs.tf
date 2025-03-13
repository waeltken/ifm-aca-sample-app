output "aca_env_resource_group_name" {
  value = azurerm_resource_group.default.name
}

output "aca_env_name" {
  value = azurerm_container_app_environment.default.name
}
