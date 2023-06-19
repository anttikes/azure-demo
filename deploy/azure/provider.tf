terraform {
  required_version = ">=1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.59.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "2.39.0"
    }

    http = {
      source = "hashicorp/http"
      version = "3.3.0"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.1"
    }
  }
}

provider "null" {
}

provider "http" {
}

provider "azuread" {
}

provider "azurerm" {
  subscription_id = "eb70277e-3c3d-4ee3-ad74-3acceb88f603"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
