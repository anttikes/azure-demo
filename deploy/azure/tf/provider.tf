terraform {
    required_version = ">=1.4.6"
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.59.0"
        }

        azurecaf = {
            source = "aztfmod/azurecaf"
            version = "1.2.25"
        }
    }
}

provider "azurerm" {
    subscription_id = "eb70277e-3c3d-4ee3-ad74-3acceb88f603"
    features {
        resource_group {
            prevent_deletion_if_contains_resources = false
        }
    }
}
