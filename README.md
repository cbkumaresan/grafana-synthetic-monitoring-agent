# Synthetic Monitoring Agent - Terraform  

Deploy Grafana Synthetic Monitoring agent to Kubernetes using Terraform.  

## Prerequisites  

- Terraform >= 1.0  
- kubectl configured with cluster access  
- Synthetic Monitoring API token from Grafana Cloud  

## Usage  

1. **Initialize Terraform**  
   


## Development

terraform init
terraform plan -var-file environments/dev.tfvars  
terraform apply -var-file environments/dev.tfvars  