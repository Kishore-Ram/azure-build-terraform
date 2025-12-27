# Azure AKS Secure Build - Terraform

This repository contains the Terraform Infrastructure-as-Code (IaC) to deploy a production-grade, secure Azure Kubernetes Service (AKS) environment.

# Azure AKS Secure Build - Terraform

This repository contains the Terraform Infrastructure-as-Code (IaC) to deploy a production-grade, secure Azure Kubernetes Service (AKS) environment.

## 🏗️ Architecture Diagram

```mermaid
graph TD
    %% --- The "Who" and "How" ---
    DevOps[DevOps Engineer] -->|Pushes Code| Repo(GitHub Repository)
    Repo -->|Triggers| CICD[CI/CD Pipeline]
    
    subgraph Terraform Execution
        CICD -->|Runs Terraform via| SP[Service Principal 'Robot']
        SP -->|1. Authenticates| ARM[Azure Resource Manager]
        SP -->|2. State Locking| TFState[Azure Storage Account]
    end
    
    %% --- The Infrastructure ---
    ARM -->|Provisions| Sub[Azure Subscription]

    subgraph "Azure Subscription (Region: East US)"
        Sub --> RG[Resource Group: rg-aks-demo-001]

        subgraph RG [Logical Container]
            %% Current State
            VNet[Virtual Network: 10.0.0.0/16]
            
            subgraph VNet [Secure Network]
                SN_AKS[Subnet 1: AKS Nodes <br/> 10.0.1.0/24]
                SN_Mgmt[Subnet 2: Bastion/Mgmt <br/> 10.0.2.0/24]
                
                %% Future State
                FUTURE_AKS[Future: AKS Cluster] -.->|Lives in| SN_AKS
                FUTURE_ILB[Future: Internal Load Balancer] -.->|Created by Service| SN_AKS
                FUTURE_Bastion[Future: Bastion Host] -.->|Lives in| SN_Mgmt
            end

            FUTURE_ACR[Future: Azure Container Registry]
            FUTURE_PLS[Future: Private Link Service] -.->|Connects to| FUTURE_ILB
            
            %% Relationships
            FUTURE_AKS -.->|Pull Image| FUTURE_ACR
        end
        
        %% Global
        FUTURE_FD[Future: Azure Front Door] -.->|Private Traffic| FUTURE_PLS
    end

    classDef existing fill:#d4edda,stroke:#28a745,stroke-width:2px;
    classDef future fill:#f8f9fa,stroke:#6c757d,stroke-width:2px,stroke-dasharray: 5 5;
    class RG,VNet,SN_AKS,SN_Mgmt existing;
    class FUTURE_AKS,FUTURE_ILB,FUTURE_Bastion,FUTURE_ACR,FUTURE_PLS,FUTURE_FD future;


## 🛠️ Prerequisites

Before running the code, ensure you have the following installed:
* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (version 2.40+)
* [Terraform](https://www.terraform.io/downloads) (version 1.3+)
* A valid **Azure Subscription** (User must have `Contributor` access).

## 🚀 Deployment Instructions

### 1. Clone & Initialize
Open your terminal in the repository root and run:
```bash
# Login to Azure
az login

# Initialize Terraform (Downloads the Azure Provider)
terraform init

📂 Directory Structure
.
├── modules/                 # Reusable Terraform Modules
│   ├── resource_group/      # RG Logic
│   └── networking/          # VNet & Subnet Logic
├── main.tf                  # Root Orchestrator
├── variables.tf             # Input Definitions
├── outputs.tf               # ID/Name Outputs
└── terraform.tfvars         # Your Variable Values

