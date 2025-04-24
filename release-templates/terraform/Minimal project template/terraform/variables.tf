###  Common tags ####
variable "CreatedBy" {
  type        = string
  default     = "userEmail@CompanyName.com"
  description = "Name of the person who created the resource"
}

variable "department" {
  type        = string
  default     = "de2-de-vnet"
  description = "Department ower of this infrastructure"
}

variable "environment" {
  type        = string
  default     = "de2-de-vnet"
  description = "Environments that could be dev, stag, prod"
}

variable "primaryOwner" {
  type        = string
  default     = "de2-de-vnet"
  description = "Name of the primary owner of this resources in Azure"
}

variable "secondaryOwner" {
  type        = string
  default     = "de2-de-vnet"
  description = "Name of the primary owner of this resources in Azure"
}

variable "LastDateDeployed" {
  type        = string
  default     = "de2-de-vnet"
  description = "The last day that was attempted to deployed"
}

### Generic ###
variable "location" {
  type        = string
  default     = "eastus2"
  description = "Region in where resources will be created"
}


### Log analytics workspace ### 
variable "logAnaliticsName" {
  type        = string
  description = "The name of the Log Analytics Workspace in Azure"
}

variable "logAnaliticsRG" {
  type        = string
  description = "The name of the Resource Group where Log Analytics Workspace is in Azure"
}