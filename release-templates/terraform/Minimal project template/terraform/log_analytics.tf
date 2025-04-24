data "azurerm_log_analytics_workspace" "de_log_analytics" {
  name                = var.logAnaliticsName
  resource_group_name = var.logAnaliticsRG
}

output "log_analytics_workspace_id" {
  value = data.azurerm_log_analytics_workspace.de_log_analytics.workspace_id
}