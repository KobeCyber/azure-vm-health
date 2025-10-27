# Azure VM Health  

Terraform project that deploys and monitors Azure Virtual Machines with automated CI/CD using **Spacelift**.  

---

## Overview  

This project provisions a complete Azure VM monitoring environment using **Terraform**.  
It automates deployment through **Spacelift**, which handles:  

- **CI/CD** — automatic Terraform plan and apply on code changes  
- **Secret management** — secure storage of sensitive values (e.g., credentials)  
- **Remote state** — managed natively by Spacelift (no Azure Storage backend required)  

### Components Deployed  
- Resource Group 
- Virtual Network & Subnet  
- Network Security Group  
- Linux Virtual Machine  
- Network Interface  
- Log Analytics Workspace  
- Metric and Log Alerts for VM health  

---

## Features  

- **Infrastructure as Code (IaC)** with Terraform  
- **Automated deployment** via Spacelift pipelines  
- **Secure secrets** stored in Spacelift (no hardcoded credentials)  
- **Spacelift-managed remote state** (no manual backend configuration)  
- **VM monitoring** through Azure Log Analytics and alert rules  

---

## Architecture  

- Terraform code resides in this repo (`/terraform` directory).  
- Spacelift monitors the GitHub repository for changes and triggers runs.  
- All sensitive values (Azure credentials, client secrets, etc.) are stored as **Spacelift secret variables**.  
- Spacelift manages **Terraform remote state** automatically — providing versioning, locking, and drift detection without external backend configuration.  
- Deployed Azure resources send metrics to **Log Analytics**, which trigger alert rules when performance thresholds are breached.  

---

## Prerequisites  

- Azure Subscription with resource creation permissions  
- Azure Service Principal (for Terraform authentication)  
- Spacelift account linked to this GitHub repository  
- Azure CLI and Terraform installed locally for testing  

---

## Getting Started  

### 1. Connect GitHub Repo to Spacelift  

- In Spacelift, create a **stack** (e.g., `azure-vm-health`).  
- Connect it to your GitHub repository.  

### 2. Configure Secret Variables in Spacelift  

In the **Spacelift → Environment** tab, add the following secrets:  

| Variable | Description |
|-----------|-------------|
| `ARM_CLIENT_ID` | Azure Service Principal client ID |
| `ARM_CLIENT_SECRET` | Azure Service Principal client secret |
| `ARM_SUBSCRIPTION_ID` | Azure subscription ID |
| `ARM_TENANT_ID` | Azure tenant ID |

### 3. Trigger a Run  

Spacelift automatically runs `terraform plan` on pull requests and `terraform apply` when changes are merged to the main branch.  
