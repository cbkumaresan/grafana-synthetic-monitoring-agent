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


------------------------------------------------------------------------------------------------------------------------------------------------------------

**1) Responses plan for cloud Region Failure**

Grafana Cloud is a highly available, scalable, and performant observability platform designed for monitoring applications and infrastructure. It is built on distributed backend systems including Grafana Mimir for metrics, Grafana Loki for logs, and Grafana Tempo for traces. These systems are architected as horizontally scalable, distributed services that provide data replication across multiple nodes, durable storage through object storage backends, and fault-tolerant ingestion and querying capabilities, ensuring high availability and resilience within a region.


Official References (Use these links as proof)
Grafana Cloud documentation
https://grafana.com/docs/grafana-cloud/
Grafana Mimir
https://grafana.com/docs/mimir/latest/
Grafana Loki
https://grafana.com/docs/loki/latest/
Grafana Tempo
https://grafana.com/docs/tempo/latest/
