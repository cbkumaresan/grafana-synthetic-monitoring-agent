# terraform {    
#   required_providers {    
#     kubernetes = {    
#       source  = "hashicorp/kubernetes"    
#       version = "~> 2.0"    
#     }    
#   }    
# }    

# provider "kubernetes" {    
#   config_path = "~/.kube/config"    
# }    

# # Namespace      
# resource "kubernetes_namespace" "synthetic_monitoring" {      
#   metadata {      
#     name = "dara-synthetic-monitoring"  
#   }      
# }      

# # Secret    
# resource "kubernetes_secret" "dara_sm_agent_1" {    
#   metadata {    
#     name      = "dara-sm-agent-1"    
#     namespace = kubernetes_namespace.synthetic_monitoring.metadata[0].name    
#   }    

#   type = "Opaque"    

#   data = {    
#     api-token  = "LyomnbCb8u6MZicdUh/5eLTmC1h3gTe+lxjER5u+vVgZuS8CpPNv39YGTGA9VrwA3hY5ua1Zv/7PDxE8KJaAynY4r7AAJZcjN1STOJgDOHUShHaESFX80CCYBEwk6p5+sop/7D2y+8kBRTP/iAwIxp5MA9icrQqrUD/org4AL/k="  
#     api-server = "synthetic-monitoring-grpc-ap-south-1.grafana.net:443"  
#   }    
# }    

# # Deployment    
# resource "kubernetes_deployment" "dara_sm_agent_1" {    
#   metadata {    
#     name      = "dara-sm-agent-1"    
#     namespace = kubernetes_namespace.synthetic_monitoring.metadata[0].name    
#   }    

#   spec {    
#     min_ready_seconds      = 10    
#     replicas               = 1    
#     revision_history_limit = 10    

#     selector {    
#       match_labels = {    
#         name = "dara-sm-agent-1"    
#       }    
#     }    

#     strategy {    
#       type = "RollingUpdate"    
#       rolling_update {    
#         max_surge       = "0"    
#         max_unavailable = "1"    
#       }    
#     }    

#     template {    
#       metadata {    
#         labels = {    
#           name = "dara-sm-agent-1"    
#         }    
#       }    

#       spec {    
#         container {    
#           name  = "agent"    
#           image = "grafana/synthetic-monitoring-agent:latest"    

#           args = [    
#             "--api-server-address=$(API_SERVER)",    
#             "--api-token=$(API_TOKEN)",    
#             "--verbose=true"    
#           ]    

#           env {    
#             name = "API_TOKEN"    
#             value_from {    
#               secret_key_ref {    
#                 name = kubernetes_secret.dara_sm_agent_1.metadata[0].name    
#                 key  = "api-token"    
#               }    
#             }    
#           }    

#           env {    
#             name = "API_SERVER"    
#             value_from {    
#               secret_key_ref {    
#                 name = kubernetes_secret.dara_sm_agent_1.metadata[0].name    
#                 key  = "api-server"    
#               }    
#             }    
#           }    

#           port {    
#             container_port = 4050    
#             name           = "http-metrics"    
#           }    

#           security_context {    
#             capabilities {    
#               add  = ["NET_RAW"]    
#               drop = ["all"]    
#             }    
#             read_only_root_filesystem = true    
#             run_as_non_root           = true    
#             run_as_user               = 12345    
#           }    

#           resources {    
#             requests = {    
#               cpu    = "200m"    
#               memory = "500Mi"    
#             }    
#           }    

#           volume_mount {    
#             name       = "tmp"    
#             sub_path   = "tmp"    
#             mount_path = "/tmp"    
#           }    
#         }    

#         volume {    
#           name = "tmp"    
#           empty_dir {}    
#         }    
#       }    
#     }    
#   }    
# }  

# # Outputs  
# output "namespace" {    
#   description = "Synthetic Monitoring namespace"    
#   value       = kubernetes_namespace.synthetic_monitoring.metadata[0].name    
# }    

# output "deployment_name" {    
#   description = "SM Agent deployment name"    
#   value       = kubernetes_deployment.dara_sm_agent_1.metadata[0].name    
# }  

# output "secret_name" {  
#   description = "SM Agent secret name"  
#   value       = kubernetes_secret.dara_sm_agent_1.metadata[0].name  
# }  


###########################Completely Working Code####################################



locals {  
  common_labels = merge(  
    {  
      "app.kubernetes.io/name"       = "synthetic-monitoring-agent"  
      "app.kubernetes.io/managed-by" = "terraform"  
      "environment"                  = var.environment  
    },  
    var.tags  
  )  
}  

provider "kubernetes" {  
  config_path = var.kubeconfig_path  
}  

# Namespace  
resource "kubernetes_namespace" "synthetic_monitoring" {  
  metadata {  
    name = var.namespace_name  
    labels = merge(  
      local.common_labels,  
      {  
        "app.kubernetes.io/component" = "namespace"  
      }  
    )  
  }  
}  

# Secret  
resource "kubernetes_secret" "sm_agent" {  
  metadata {  
    name      = var.agent_name  
    namespace = kubernetes_namespace.synthetic_monitoring.metadata[0].name  
    labels = merge(  
      local.common_labels,  
      {  
        "app.kubernetes.io/component" = "secret"  
      }  
    )  
  }  

  type = "Opaque"  

  data = {  
    api-token  = var.api_token  
    api-server = var.api_server  
  }  
}  

# Deployment  
resource "kubernetes_deployment" "sm_agent" {  
  metadata {  
    name      = var.agent_name  
    namespace = kubernetes_namespace.synthetic_monitoring.metadata[0].name  
    labels = merge(  
      local.common_labels,  
      {  
        "app.kubernetes.io/component" = "deployment"  
      }  
    )  
  }  

  spec {  
    min_ready_seconds      = 10  
    replicas               = var.agent_replicas  
    revision_history_limit = 10  

    selector {  
      match_labels = {  
        "app.kubernetes.io/name"      = "synthetic-monitoring-agent"  
        "app.kubernetes.io/component" = "agent"  
        "environment"                 = var.environment  
      }  
    }  

    strategy {  
      type = "RollingUpdate"  
      rolling_update {  
        max_surge       = "0"  
        max_unavailable = "1"  
      }  
    }  

    template {  
      metadata {  
        labels = merge(  
          local.common_labels,  
          {  
            "app.kubernetes.io/component" = "agent"  
          }  
        )  
      }  

      spec {  
        container {  
          name  = "agent"  
          image = var.agent_image  

          args = [  
            "--api-server-address=$(API_SERVER)",  
            "--api-token=$(API_TOKEN)",  
            "--verbose=${var.verbose_logging}"  
          ]  

          env {  
            name = "API_TOKEN"  
            value_from {  
              secret_key_ref {  
                name = kubernetes_secret.sm_agent.metadata[0].name  
                key  = "api-token"  
              }  
            }  
          }  

          env {  
            name = "API_SERVER"  
            value_from {  
              secret_key_ref {  
                name = kubernetes_secret.sm_agent.metadata[0].name  
                key  = "api-server"  
              }  
            }  
          }  

          env {  
            name  = "ENVIRONMENT"  
            value = var.environment  
          }  

          port {  
            container_port = 4050  
            name           = "http-metrics"  
          }  

          security_context {  
            capabilities {  
              add  = ["NET_RAW"]  
              drop = ["all"]  
            }  
            read_only_root_filesystem = true  
            run_as_non_root           = true  
            run_as_user               = 12345  
          }  

          resources {  
            requests = {  
              cpu    = var.agent_resources.cpu  
              memory = var.agent_resources.memory  
            }  
          }  

          volume_mount {  
            name       = "tmp"  
            sub_path   = "tmp"  
            mount_path = "/tmp"  
          }  
        }  

        volume {  
          name = "tmp"  
          empty_dir {}  
        }  
      }  
    }  
  }  
}  