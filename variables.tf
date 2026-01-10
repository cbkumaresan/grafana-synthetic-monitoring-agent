variable "environment" {  
  description = "Environment name (dev, staging, prod)"  
  type        = string  
  validation {  
    condition     = contains(["dev", "staging", "prod"], var.environment)  
    error_message = "Environment must be dev, staging, or prod."  
  }  
}  

variable "namespace_name" {  
  description = "Kubernetes namespace for Synthetic Monitoring agent"  
  type        = string  
}  

variable "agent_name" {  
  description = "Name for the Synthetic Monitoring agent resources"  
  type        = string  
}  

variable "api_token" {  
  description = "Synthetic Monitoring API token from Grafana Cloud"  
  type        = string  
  sensitive   = true  
}  

variable "api_server" {  
  description = "Synthetic Monitoring API server endpoint"  
  type        = string  
}  

variable "agent_image" {  
  description = "Synthetic Monitoring agent container image"  
  type        = string  
  default     = "grafana/synthetic-monitoring-agent:latest"  
}  

variable "agent_replicas" {  
  description = "Number of agent replicas"  
  type        = number  
  default     = 1  
}  

variable "agent_resources" {  
  description = "Resource requests for the agent"  
  type = object({  
    cpu    = string  
    memory = string  
  })  
  default = {  
    cpu    = "200m"  
    memory = "500Mi"  
  }  
}  

variable "verbose_logging" {  
  description = "Enable verbose logging for the agent"  
  type        = bool  
  default     = true  
}  

variable "kubeconfig_path" {  
  description = "Path to kubeconfig file"  
  type        = string  
  default     = "~/.kube/config"  
}  

variable "tags" {  
  description = "Additional tags/labels for resources"  
  type        = map(string)  
  default     = {}  
}  