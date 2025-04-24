terraform {
  backend "azurerm" {
    // Template blob to storage the state files.
    storage_account_name = "StorageAccountName"
    container_name       = "projectName-terraform-state"
    key                  = "environment-projectName-type-terraform.state"
    sas_token            = "SASToken"
  }
}