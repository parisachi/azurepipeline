variable "storage_account_name1"{
    type=string
    default="skbondstorage00712786"
}
variable "storage_account_name2"{
    type=string
    default="skbondstorage007127865"
}
variable "resource_group_name"{
    type=string
    default="skbond_terraform_grouping"
}

provider "azurerm"{
    subscription_id = "d17b9f91-eed8-4d43-a145-425b72328e03"
    tenant_id = "492d497d-d2d7-4be9-9894-383d70fcf395"
    features {}

}

resource "azurerm_resource_group" "rgtest"{
    name = var.resource_group_name
    location = "westus2"

}
resource "azurerm_storage_account" "example1"{
    name = var.storage_account_name1
    resource_group_name = azurerm_resource_group.rgtest.name
    location = azurerm_resource_group.rgtest.location
    account_tier = "Standard"
    account_replication_type = "LRS"

}

resource "azurerm_storage_account" "example2"{
    name = var.storage_account_name2
    resource_group_name = azurerm_resource_group.rgtest.name
    location = azurerm_resource_group.rgtest.location
    account_tier = "Standard"
    account_replication_type = "LRS"

}