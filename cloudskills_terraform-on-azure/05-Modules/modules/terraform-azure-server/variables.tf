variable "admin_username" {
    type = string
    description = "Virtual machine admin username"
}

variable "admin_password" {
    type = string
    description = "Virtual machine admin password"
    sensitive = true
}

variable "vm_size" {
    type = string
    description = "Virtual machine compute size"
    default = "Standard_B1s"
}

variable os {
    description = "OS image to deploy"
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
    })
}

variable "vm_name" {
    type = string
    description = "Virtual machine name"
}

variable "resource_group_name" {
    type = string
    description = "Name of the Resource Group to deploy the Virtual Machine"
}

variable "location" {
    type = string
    description = "Azure location of network components"
    default = "westus2"
}

variable "vnet_address_space" {
    type = list(any)
    description = "Virtual network address space"
    default = ["10.0.0.0/16"]
}

variable "snet_address_space" {
    type = list(any)
    description = "Subnet address space"
    default = ["10.0.0.0/24"]
}

variable "subnet_id" {
    type = string
    description = "Subnet ID for virtual machine NIC"
}

variable "storage_account_type" {
    type = map
    description = "Disk type for virtual machines"

    default = {
        westus2 = "Standard_LRS"
        westus = "Premium_LRS"
    }
}
