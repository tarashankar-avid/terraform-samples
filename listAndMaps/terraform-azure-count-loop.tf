variable "vm_name_pfx" {
  description = "VM Names"
  default     = "test-vm-"
  type        = string
}

variable "vm_count" {
  description = "Number of Virtual Machines"
  default     = 3
  type        = string
}

resource "azurerm_windows_virtual_machine" "vm" {
  count               = var.vm_count # Count Value read from variable
  name                = "${var.vm_name_pfx}-${count.index}" # Name constructed using count and pfx
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.vm_admin_login
  admin_password      = var.vm_admin_password
  tags = var.tags
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  
   source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
