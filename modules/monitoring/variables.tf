variable "workspace_name" {
  type        = string
  description = "Name of the Log Analytics workspace"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "vm_id" {
  type        = string
  description = "ID of the virtual machine to enable diagnostics"
  default     = ""
}

variable "enable_vm_diagnostics" {
  type        = bool
  description = "Whether to enable diagnostics settings for the VM"
  default     = false
}

variable "action_group_name" {
  type        = string
  description = "Name of the action group for alerts"
}

variable "alert_email" {
  type        = string
  description = "Email address to receive alerts"
}

variable "alert_name" {
  type        = string
  description = "Name of the CPU alert"
}

variable "cpu_threshold" {
  type        = number
  description = "CPU usage threshold for alerting"
}
