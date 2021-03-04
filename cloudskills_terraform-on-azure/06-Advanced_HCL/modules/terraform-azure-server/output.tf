output "pip" {
  description = "Public IP Address of Virtual Machine"
  value       = azurerm_public_ip.pip.ip_address
}