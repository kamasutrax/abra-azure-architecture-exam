<img width="1024" height="559" alt="Unknown" src="https://github.com/user-attachments/assets/7520d612-6d7f-41e0-9b85-337ca11f4406" />

# Scalable Web Architecture on Azure

## Design Choices
* **Networking:** VNet tiers enforce strict isolation. 3 private subnets were provisioned (exceeding the minimum of 2) as APIM, AppGW, and ACA each strictly require dedicated subnets. NAT Gateway provides secure outbound-only internet access.
* **Security:** APIM is deployed in `External` VNet mode to allow external user traffic while maintaining internal routing to the backend. Ingress protocol at the APIM layer is restricted to HTTPS.
* **Compute:** Azure Container Apps Environment is VNet-injected and relies on a managed internal load balancer.

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
   - terraform init
   - terraform validate
   - terraform plan
   - terraform apply
