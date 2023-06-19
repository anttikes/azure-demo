variable "location" {
  type        = string
  description = "Azure location for the resources"
  default     = "northeurope"
}

variable "subscription_id" {
    type        = string
    description = "Azure Subcription ID to deploy resources to"
}

data "azurerm_client_config" "current" {}

data "azuread_user" "current_user" {
  object_id = data.azurerm_client_config.current.object_id
}
