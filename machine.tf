variable "storage_account_name" {
    type=string
    default="skbondstorage777"
}

variable "resource_group_name"{
    type=string
    default="skbond_terraform_group"
}
 
variable "network_name" {
    type=string
    default="skbondnetwork"
}
 
variable "vm_name" {
    type=string
    default="skbondvm"
}
 
provider "azurerm"{
    version = ">=2.26"
    subscription_id = "1991b061-17ce-4f0e-bec7-6560e4931d30"
    tenant_id = "492d497d-d2d7-4be9-9894-383d70fcf395"
    features {}

}
 
resource "azurerm_resource_group" "rg"{
    name = var.resource_group_name
    location = "North Europe"

}

resource "azurerm_virtual_network" "staging" {
  name                = var.network_name
  address_space       = ["10.0.0.0/16"]
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.rg.name
}
 
resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.staging.name
  address_prefix     = "10.0.0.0/24"
}
 
resource "azurerm_network_interface" "interface" {
  name                = "default-interface"
  location            = "North Europe"
  resource_group_name = azurerm_resource_group.rg.name
 
  ip_configuration {
    name                          = "interfaceconfiguration"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
  }
}
 
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = "North Europe"
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.interface.id]
  vm_size               = "Standard_DS1_v2"
 
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "skbondvm"
    admin_username = "demousr"
    admin_password = "Password@123"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }  
}