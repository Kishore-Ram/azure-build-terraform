# azure-build-terraform

# Azure AKS Secure Build - Terraform

This repository contains the Terraform Infrastructure-as-Code (IaC) to deploy a production-grade, secure Azure Kubernetes Service (AKS) environment.

## 🏗️ Architecture Diagram

The following diagram illustrates the deployment flow and the target architecture.

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
    
Brief Introduction & Status Update
The Architectural Goal
We are building a secure, production-grade Azure Kubernetes Service (AKS) environment. The key characteristic of this architecture is security through isolation.

The AKS cluster will not be exposed directly to the public internet.

Ingress traffic will flow through a global pathway (Front Door) into a private connection (PLS), finally reaching an internal receiver (ILB) inside the AKS subnet.

Management access will be separate via a Bastion host in its own dedicated subnet.

Current Status: The Foundation (Modules 1 & 2)
We have successfully scripted the "digital land" and the "plumbing" using a modular Terraform approach.

1. The Resource Group Module (RG)

What it is: The fundamental container in Azure.

Why we need it: It groups all our related resources together for lifecycle management, billing, and access control. If we delete this RG, the entire VNet and future AKS cluster disappears cleanly.

Current Status: Coded and ready. It defines where (Region) and under what name the project lives.

2. The Networking Module (VNet & Subnets)

What it is: A private network isolated within the Azure cloud.

Why we need it: This is critical for the security requirement. We created one large network divided into two smaller "rooms" (subnets):

AKS Subnet: This is where the Kubernetes worker nodes will live. We made it relatively large because every Pod (container) might get its own IP address depending on the networking plugin we choose later.

Bastion Subnet: A separate, smaller subnet for management tools. This ensures management traffic is segregated from application traffic.

Current Status: Coded and ready. It establishes the IP addressing scheme (CIDR blocks) and subnet structure that AKS and Bastion will plug into later.