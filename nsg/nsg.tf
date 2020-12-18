variable "idFrontEndSbn" {
  type        = string
}
variable "idBackEndSbn" {
  type        = string
}
variable "idmanagerSbn" {
  type        = string
}
variable "loc"{
    type        = string
}

variable "sbw10" {
  type        = string
}

resource "azurerm_resource_group" "rg-nsg" {
  name = "rgt-nsg"
  location = var.loc
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-acceso"
  location = var.loc
  resource_group_name = azurerm_resource_group.rg-nsg.name

   security_rule {
    name                       = "ReglaAcceso"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Labs"
  }
}

resource "azurerm_subnet_network_security_group_association" "vinculo1" {
  subnet_id                 = var.idFrontEndSbn
  network_security_group_id = azurerm_resource_group.rg-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "vinculo2" {
  subnet_id                 = var.idmanagerSbn
  network_security_group_id = azurerm_resource_group.rg-nsg.id
}
resource "azurerm_subnet_network_security_group_association" "vinculo3" {
  subnet_id                 = var.idBackEndSbn
  network_security_group_id = azurerm_resource_group.rg-nsg.id
}

resource "azurerm_subnet_network_security_group_association" "vinculo4" {
  subnet_id                 = var.sbw10
  network_security_group_id = azurerm_resource_group.rg-nsg.id
}

output "gruposeguridad" {
  value = azurerm_network_security_group.nsg.id
}
output "rgnsg" {
  value = azurerm_resource_group.rg-nsg.name
}