# Scalable Web Architecture on Azure

## Design Choices
* **Networking**: VNet tiers enforce strict isolation. NAT Gateway provides secure outbound-only internet access.
* **Security**: 100% private ingress. APIM is deployed in Internal VNet mode, AppGW utilizes a private frontend IP, and NSGs restrict container traffic exclusively to AppGW.
* **Compute**: Azure Container Apps Environment is VNet-injected and relies on a managed internal load balancer.

## Scaling for Production

* **WAF Integration:** Upgrade Application Gateway to WAF_v2 for Layer 7 threat protection.
* **High Availability:** Upgrade APIM to Premium SKU for true multi-zone redundancy.
* **Private Link:** Implement Private Endpoints for backend PaaS services to keep all dependency traffic on the Azure backbone.
* **Zero Trust:** Implement Azure Key Vault and system-assigned Managed Identities for passwordless authentication between services.

## Deployment Instructions

1. **Prerequisites**: 
   - Azure CLI installed and authenticated (`az login`).
   - Terraform CLI installed (v1.0.0+).
   - An active Azure Subscription.

2. **Initialization**:
   terraform init
   terraform validate
   terraform plan
   terraform apply