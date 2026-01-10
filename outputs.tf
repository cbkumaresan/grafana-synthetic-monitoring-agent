# output "namespace" {    
#   description = "Synthetic Monitoring namespace"    
#   value       = kubernetes_namespace.synthetic_monitoring.metadata[0].name    
# }    

# output "deployment_name" {    
#   description = "SM Agent deployment name"    
#   value       = kubernetes_deployment.cmod_sm_agent_1.metadata[0].name    
# }  

# output "secret_name" {  
#   description = "SM Agent secret name"  
#   value       = kubernetes_secret.cmod_sm_agent_1.metadata[0].name  
# }  


output "environment" {  
  description = "Deployed environment"  
  value       = var.environment  
}  

output "namespace" {  
  description = "Synthetic Monitoring namespace name"  
  value       = kubernetes_namespace.synthetic_monitoring.metadata[0].name  
}  

output "deployment_name" {  
  description = "Synthetic Monitoring agent deployment name"  
  value       = kubernetes_deployment.sm_agent.metadata[0].name  
}  

output "secret_name" {  
  description = "Synthetic Monitoring agent secret name"  
  value       = kubernetes_secret.sm_agent.metadata[0].name  
  sensitive   = true  
}  

output "agent_endpoint" {  
  description = "Agent metrics endpoint (internal cluster)"  
  value       = "http://${kubernetes_deployment.sm_agent.metadata[0].name}.${kubernetes_namespace.synthetic_monitoring.metadata[0].name}.svc.cluster.local:4050/metrics"  
}  