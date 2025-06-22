#!/bin/bash

# 🛡️ Cybersecurity Home Lab - Azure Infrastructure Setup Script
# This script automates the creation of Azure resources for the honeypot lab

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
RESOURCE_GROUP="rg-soc-lab"
LOCATION="eastus2"
VNET_NAME="vnet-soc-lab"
VM_NAME="corpnet-east1"
WORKSPACE_NAME="law-soc-lab"
VM_SIZE="Standard_B1s"
VM_USERNAME="labuser"
VM_PASSWORD="Cyberlab123!"

echo -e "${BLUE}🛡️  Cybersecurity Home Lab - Azure Setup${NC}"
echo -e "${YELLOW}This script will create all necessary Azure resources for your honeypot lab.${NC}"
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}❌ Azure CLI is not installed. Please install it first:${NC}"
    echo "https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if user is logged in
if ! az account show &> /dev/null; then
    echo -e "${RED}❌ You are not logged in to Azure. Please run:${NC}"
    echo "az login"
    exit 1
fi

echo -e "${GREEN}✅ Azure CLI is installed and you are logged in.${NC}"
echo ""

# Get subscription info
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
SUBSCRIPTION_NAME=$(az account show --query name -o tsv)
echo -e "${BLUE}📋 Using subscription: ${SUBSCRIPTION_NAME} (${SUBSCRIPTION_ID})${NC}"
echo ""

# Confirm before proceeding
echo -e "${YELLOW}⚠️  This will create the following resources:${NC}"
echo "  • Resource Group: ${RESOURCE_GROUP}"
echo "  • Virtual Network: ${VNET_NAME}"
echo "  • Virtual Machine: ${VM_NAME}"
echo "  • Log Analytics Workspace: ${WORKSPACE_NAME}"
echo "  • Network Security Group (open to all traffic)"
echo ""
echo -e "${YELLOW}⚠️  WARNING: This creates an intentionally vulnerable system for educational purposes only.${NC}"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Setup cancelled.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}🚀 Starting Azure resource creation...${NC}"
echo ""

# Step 1: Create Resource Group
echo -e "${BLUE}📦 Creating Resource Group...${NC}"
az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION \
    --output none

echo -e "${GREEN}✅ Resource Group created: ${RESOURCE_GROUP}${NC}"

# Step 2: Create Virtual Network
echo -e "${BLUE}🌐 Creating Virtual Network...${NC}"
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VNET_NAME \
    --address-prefix 10.0.0.0/16 \
    --subnet-name default \
    --subnet-prefix 10.0.0.0/24 \
    --output none

echo -e "${GREEN}✅ Virtual Network created: ${VNET_NAME}${NC}"

# Step 3: Create Network Security Group
echo -e "${BLUE}🔒 Creating Network Security Group...${NC}"
az network nsg create \
    --resource-group $RESOURCE_GROUP \
    --name "${VM_NAME}-nsg" \
    --output none

# Add rule to allow all traffic (⚠️ DANGEROUS - for honeypot only)
echo -e "${YELLOW}⚠️  Adding dangerous rule: Allow all traffic${NC}"
az network nsg rule create \
    --resource-group $RESOURCE_GROUP \
    --nsg-name "${VM_NAME}-nsg" \
    --name "Danger-AllowAll" \
    --protocol "*" \
    --source-address-prefix "*" \
    --source-port-range "*" \
    --destination-address-prefix "*" \
    --destination-port-range "*" \
    --access Allow \
    --priority 100 \
    --output none

echo -e "${GREEN}✅ Network Security Group created with open rules${NC}"

# Step 4: Create Public IP
echo -e "${BLUE}🌍 Creating Public IP...${NC}"
az network public-ip create \
    --resource-group $RESOURCE_GROUP \
    --name "${VM_NAME}-pip" \
    --allocation-method Dynamic \
    --output none

echo -e "${GREEN}✅ Public IP created${NC}"

# Step 5: Create Network Interface
echo -e "${BLUE}🔌 Creating Network Interface...${NC}"
az network nic create \
    --resource-group $RESOURCE_GROUP \
    --name "${VM_NAME}-nic" \
    --vnet-name $VNET_NAME \
    --subnet default \
    --public-ip-address "${VM_NAME}-pip" \
    --network-security-group "${VM_NAME}-nsg" \
    --output none

echo -e "${GREEN}✅ Network Interface created${NC}"

# Step 6: Create Virtual Machine
echo -e "${BLUE}🖥️  Creating Virtual Machine...${NC}"
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --location $LOCATION \
    --size $VM_SIZE \
    --nics "${VM_NAME}-nic" \
    --image "MicrosoftWindowsDesktop:windows-10:21h2-pro:latest" \
    --admin-username $VM_USERNAME \
    --admin-password $VM_PASSWORD \
    --disable-boot-diagnostics \
    --output none

echo -e "${GREEN}✅ Virtual Machine created: ${VM_NAME}${NC}"

# Step 7: Create Log Analytics Workspace
echo -e "${BLUE}📊 Creating Log Analytics Workspace...${NC}"
az monitor log-analytics workspace create \
    --resource-group $RESOURCE_GROUP \
    --workspace-name $WORKSPACE_NAME \
    --location $LOCATION \
    --output none

echo -e "${GREEN}✅ Log Analytics Workspace created: ${WORKSPACE_NAME}${NC}"

# Get workspace ID for future use
WORKSPACE_ID=$(az monitor log-analytics workspace show \
    --resource-group $RESOURCE_GROUP \
    --workspace-name $WORKSPACE_NAME \
    --query customerId -o tsv)

# Step 8: Install Azure Monitor Agent on VM
echo -e "${BLUE}📡 Installing Azure Monitor Agent...${NC}"
az vm extension set \
    --resource-group $RESOURCE_GROUP \
    --vm-name $VM_NAME \
    --name AzureMonitorWindowsAgent \
    --publisher Microsoft.Azure.Monitor \
    --output none

echo -e "${GREEN}✅ Azure Monitor Agent installed${NC}"

# Step 9: Get VM Public IP
echo -e "${BLUE}🌐 Getting VM Public IP...${NC}"
VM_PUBLIC_IP=$(az vm show \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --show-details \
    --query publicIps -o tsv)

echo -e "${GREEN}✅ VM Public IP: ${VM_PUBLIC_IP}${NC}"

# Step 10: Create Data Collection Rule
echo -e "${BLUE}📋 Creating Data Collection Rule...${NC}"
az monitor data-collection rule create \
    --resource-group $RESOURCE_GROUP \
    --name "dcr-win-logs" \
    --location $LOCATION \
    --data-sources windows-event-logs="[{\"streams\":[\"Microsoft-SecurityEvent\"],\"xPathQueries\":[\"*\"],\"name\":\"SecurityEvents\"}]" \
    --destinations log-analytics="[{\"workspaceResourceId\":\"/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.OperationalInsights/workspaces/${WORKSPACE_NAME}\",\"name\":\"law-soc-lab\"}]" \
    --data-flows streams="[\"Microsoft-SecurityEvent\"]" destinations="[\"law-soc-lab\"]" \
    --output none

echo -e "${GREEN}✅ Data Collection Rule created${NC}"

# Step 11: Associate VM with Data Collection Rule
echo -e "${BLUE}🔗 Associating VM with Data Collection Rule...${NC}"
az monitor data-collection rule association create \
    --resource-group $RESOURCE_GROUP \
    --name "dcr-association" \
    --rule-id "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Insights/dataCollectionRules/dcr-win-logs" \
    --resource "/subscriptions/${SUBSCRIPTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Compute/virtualMachines/${VM_NAME}" \
    --output none

echo -e "${GREEN}✅ VM associated with Data Collection Rule${NC}"

echo ""
echo -e "${GREEN}🎉 Azure infrastructure setup completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Resource Summary:${NC}"
echo "  • Resource Group: ${RESOURCE_GROUP}"
echo "  • Virtual Machine: ${VM_NAME}"
echo "  • Public IP: ${VM_PUBLIC_IP}"
echo "  • Log Analytics Workspace: ${WORKSPACE_NAME}"
echo "  • Workspace ID: ${WORKSPACE_ID}"
echo ""
echo -e "${YELLOW}⚠️  Important Security Notes:${NC}"
echo "  • VM is intentionally open to all internet traffic"
echo "  • Windows Firewall should be disabled manually via RDP"
echo "  • This configuration is for educational purposes only"
echo ""
echo -e "${BLUE}🔧 Next Steps:${NC}"
echo "  1. RDP to VM: ${VM_PUBLIC_IP}"
echo "  2. Username: ${VM_USERNAME}"
echo "  3. Password: ${VM_PASSWORD}"
echo "  4. Disable Windows Firewall"
echo "  5. Enable Microsoft Sentinel in Azure portal"
echo "  6. Upload GeoIP watchlist"
echo "  7. Import attack map dashboard"
echo ""
echo -e "${GREEN}📚 For detailed instructions, see: docs/setup-guide.md${NC}"
echo ""
echo -e "${YELLOW}💡 Pro Tip: Monitor your Azure costs regularly!${NC}" 