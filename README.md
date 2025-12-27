# azure-build-terraform

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