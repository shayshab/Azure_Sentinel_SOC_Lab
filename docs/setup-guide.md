# Complete Setup Guide: Azure Sentinel SOC Lab Implementation

This guide provides comprehensive step-by-step instructions for building a cybersecurity home lab using Microsoft Sentinel and a honeypot virtual machine.

## Prerequisites Checklist

- [ ] Azure free account created
- [ ] Credit card added to Azure account
- [ ] Windows 10/11 machine for RDP
- [ ] Stable internet connection
- [ ] Basic familiarity with Azure portal

## Phase 1: Azure Infrastructure Setup

### Step 1.1 – Create Free Azure Account

1. **Access Azure Free Tier**
   - Navigate to: https://azure.microsoft.com/free
   - Select "Start free" or "Free account"

2. **Account Registration**
   - Use personal Gmail/Outlook email
   - Add credit card for verification
   - Note: No charges unless free limits exceeded

3. **Account Verification**
   - Complete email verification process
   - Wait for account activation (typically immediate)

### Step 1.2 – Create Resource Group

1. **Navigate to Resource Groups**
   - Access Azure Portal: https://portal.azure.com
   - Search for "Resource Groups" in search bar
   - Select "Resource Groups"

2. **Resource Group Creation**
   - Click "Create" button
   - Configure details:
     - **Name**: `rg-soc-lab`
     - **Region**: `East US 2`
     - **Subscription**: Your subscription
   - Execute "Review + Create" → "Create"

### Step 1.3 – Create Virtual Network (VNet)

1. **Access Virtual Networks**
   - Search for "Virtual Networks" in Azure portal
   - Select "Virtual Networks"

2. **Virtual Network Creation**
   - Click "Create"
   - Configure parameters:
     - **Name**: `vnet-soc-lab`
     - **Resource Group**: `rg-soc-lab`
     - **Region**: `East US 2`
     - **Address Space**: Accept default (e.g., 10.0.0.0/16)
     - **Subnet**: Accept default settings
   - Execute "Review + Create" → "Create"

## Phase 2: Deploy Honeypot Virtual Machine

### Step 2.1 – Create Virtual Machine

1. **Access Virtual Machines**
   - Search for "Virtual Machines" in Azure portal
   - Select "Virtual Machines"

2. **VM Creation**
   - Click "Create" → "Azure Virtual Machine"
   - Configure parameters:
     - **Name**: `corpnet-east1`
     - **Region**: `East US 2`
     - **Image**: `Windows 10 Pro`
     - **Size**: `Standard B1s` (cost-effective option)
     - **Username**: `labuser`
     - **Password**: `Cyberlab123!`
     - **Public Inbound Ports**: `Allow selected ports`
     - **Selected Inbound Ports**: `RDP (3389)`
     - **Virtual Network**: `vnet-soc-lab`
     - **Subnet**: `default`
     - **Boot Diagnostics**: `Disable`
   - Execute "Review + Create" → "Create"

### Step 2.2 – Configure Network Security Group

1. **Locate Network Security Group**
   - Navigate to Resource Group `rg-soc-lab`
   - Identify NSG associated with VM (typically `corpnet-east1-nsg`)
   - Select NSG

2. **Configure Inbound Rules**
   - Access "Inbound Security Rules"
   - Remove existing RDP rule if present
   - Create new rule via "Add":
     - **Source**: `Any`
     - **Source Port Ranges**: `*`
     - **Destination**: `Any`
     - **Destination Port Ranges**: `*`
     - **Protocol**: `Any`
     - **Action**: `Allow`
     - **Priority**: `100`
     - **Name**: `Danger-AllowAll`
     - **Description**: `WARNING: Opens VM to all traffic`
   - Execute "Add"

### Step 2.3 – Disable Windows Firewall

1. **Establish VM Connection**
   - Use Remote Desktop Connection
   - Connect to VM public IP
   - Authenticate with: `labuser` / `Cyberlab123!`

2. **Firewall Configuration**
   - Press `Windows + R`
   - Execute: `wf.msc`
   - In Windows Firewall with Advanced Security:
     - Right-click "Windows Firewall Properties"
     - For each profile (Domain, Private, Public):
       - Set "Firewall State" to "Off"
       - Apply changes

## Phase 3: Verify Attack Surface Configuration

### Step 3.1 – Validate VM Accessibility

1. **Retrieve Public IP**
   - Access VM in Azure portal
   - Copy public IP address

2. **Test Connectivity**
   ```bash
   # Local machine execution
   ping <your-vm-public-ip>
   ```
   
   **Expected Result**: Successful ping responses indicate VM readiness

## Phase 4: Log Analytics and Sentinel Configuration

### Step 4.1 – Create Log Analytics Workspace

1. **Access Log Analytics**
   - Search for "Log Analytics Workspaces"
   - Select "Log Analytics Workspaces"

2. **Workspace Creation**
   - Click "Create"
   - Configure parameters:
     - **Name**: `law-soc-lab`
     - **Region**: `East US 2`
     - **Resource Group**: `rg-soc-lab`
   - Execute "Review + Create" → "Create"

### Step 4.2 – Enable Microsoft Sentinel

1. **Access Sentinel**
   - Search for "Microsoft Sentinel"
   - Select "Microsoft Sentinel"

2. **Sentinel Activation**
   - Click "+ Add"
   - Select workspace: `law-soc-lab`
   - Execute "Add"

### Step 4.3 – Configure Windows Security Event Connector

1. **Access Content Hub**
   - In Sentinel, navigate to "Content Hub"
   - Search for "Windows Security Events"

2. **Connector Installation**
   - Select "Windows Security Events"
   - Execute "Install" → "Manage"
   - Select "Windows Security Events via Azure Monitoring Agent"
   - Execute "Open Connector Page"

### Step 4.4 – Create Data Collection Rule (DCR)

1. **DCR Creation**
   - Click "Create Data Collection Rule"
   - Configure parameters:
     - **Name**: `dcr-win-logs`
     - **Resource Group**: `rg-soc-lab`
     - **Platform Type**: `Windows`
     - **Data Sources**: Select VM `corpnet-east1`
     - **Event Types**: `All security events`
   - Execute "Review + Create" → "Create"

### Step 4.5 – Verify Log Collection

1. **Log Analytics Verification**
   - Access Log Analytics workspace `law-soc-lab`
   - Navigate to "Logs"
   - Execute query:
   ```kql
   SecurityEvent
   ```
   
   **Expected Result**: Security events should appear within 5-10 minutes

## Phase 5: GeoIP Integration and Attack Mapping

### Step 5.1 – Create GeoIP Watchlist

1. **Access Watchlists**
   - In Sentinel, navigate to "Watchlists"
   - Click "+ Add"

2. **Watchlist Configuration**
   - **Name**: `GeoIP-Data`
   - **Description**: `Geographic IP data for attack mapping`
   - **Provider**: `Microsoft`
   - **Source Type**: `Local file`
   - **Upload File**: Use provided `geoip-sample.csv`

### Step 5.2 – Import Sample Data

1. **Data Import**
   - Download sample data from project repository
   - Upload to watchlist
   - Verify data import

2. **Data Validation**
   - Check watchlist contents
   - Verify IP and location data

## Phase 6: KQL Query Implementation

### Step 6.1 – Basic Security Queries

1. **Failed Login Analysis**
   ```kql
   SecurityEvent
   | where EventID == 4625
   | extend IPAddress = extract("Source Network Address: ([^,]+)", 1, EventData)
   | summarize FailedLogins = count() by IPAddress, bin(TimeGenerated, 1h)
   | order by FailedLogins desc
   ```

2. **Geographic Attack Mapping**
   ```kql
   SecurityEvent
   | where EventID == 4625
   | extend IPAddress = extract("Source Network Address: ([^,]+)", 1, EventData)
   | join kind=leftouter (Watchlist("GeoIP-Data") | project IPAddress, Country, City) on IPAddress
   | summarize AttackCount = count() by Country, City
   | order by AttackCount desc
   ```

### Step 6.2 – Advanced Threat Queries

1. **Brute Force Detection**
   ```kql
   SecurityEvent
   | where EventID == 4625
   | extend IPAddress = extract("Source Network Address: ([^,]+)", 1, EventData)
   | summarize FailedAttempts = count() by IPAddress, bin(TimeGenerated, 5m)
   | where FailedAttempts > 5
   | order by FailedAttempts desc
   ```

2. **Attack Pattern Analysis**
   ```kql
   SecurityEvent
   | where EventID == 4625
   | extend IPAddress = extract("Source Network Address: ([^,]+)", 1, EventData)
   | summarize 
       TotalAttempts = count(),
       UniqueIPs = dcount(IPAddress),
       TimeSpan = max(TimeGenerated) - min(TimeGenerated)
   by bin(TimeGenerated, 1h)
   | order by TotalAttempts desc
   ```

## Phase 7: Dashboard and Visualization

### Step 7.1 – Create Attack Map Dashboard

1. **Workbook Creation**
   - In Sentinel, navigate to "Workbooks"
   - Click "+ Add workbook"

2. **Dashboard Configuration**
   - Add geographic visualization
   - Configure data sources
   - Set up real-time updates

### Step 7.2 – Security Metrics Dashboard

1. **Metrics Implementation**
   - Failed login trends
   - Geographic attack distribution
   - Top attacking IP addresses
   - Attack frequency over time

## Phase 8: Alert Configuration

### Step 8.1 – Brute Force Alert

1. **Alert Rule Creation**
   - Navigate to "Analytics"
   - Click "+ Create" → "Scheduled query rule"

2. **Rule Configuration**
   - **Name**: `Brute Force Attack Alert`
   - **Description**: `Detect multiple failed login attempts`
   - **Query**: Use brute force detection query
   - **Schedule**: Every 5 minutes
   - **Threshold**: Greater than 0

### Step 8.2 – Geographic Alert

1. **Geographic Rule**
   - Create alert for attacks from specific regions
   - Configure severity levels
   - Set up notification channels

## Phase 9: Testing and Validation

### Step 9.1 – Attack Simulation

1. **Port Scanning**
   - Use online port scanner
   - Target VM public IP
   - Verify open ports

2. **Authentication Testing**
   - Attempt failed logins
   - Monitor alert generation
   - Verify log collection

### Step 9.2 – Dashboard Validation

1. **Data Verification**
   - Check dashboard updates
   - Verify geographic mapping
   - Confirm alert functionality

## Phase 10: Enterprise Features (Optional)

### Step 10.1 – Compliance Monitoring

1. **Compliance Framework Integration**
   - SOC 2 Type II monitoring
   - GDPR compliance tracking
   - ISO 27001 controls

### Step 10.2 – Threat Intelligence

1. **IOC Integration**
   - Threat feed aggregation
   - Reputation scoring
   - Malware analysis

### Step 10.3 – Automation

1. **Playbook Implementation**
   - Incident response automation
   - Threat hunting workflows
   - Integration with ticketing systems

## Troubleshooting

### Common Issues

1. **No Logs in Sentinel**
   - Verify DCR configuration
   - Check agent installation
   - Allow 5-10 minutes for data propagation

2. **VM Connection Issues**
   - Verify NSG rules
   - Check VM status
   - Confirm credentials

3. **Dashboard Not Updating**
   - Verify query syntax
   - Check data sources
   - Refresh dashboard

### Performance Optimization

1. **Query Optimization**
   - Use appropriate time ranges
   - Limit result sets
   - Optimize KQL syntax

2. **Cost Management**
   - Monitor data ingestion
   - Use appropriate VM sizes
   - Clean up unused resources

## Security Considerations

**Important**: This lab creates an intentionally vulnerable environment. Never deploy this configuration in production.

- Use only in isolated lab environments
- Monitor costs regularly
- Delete resources when not in use
- Never use real credentials or sensitive data
- Follow organizational security policies

## Cost Management

- **Estimated Monthly Cost**: $5-15 USD (lab environment)
- **Free Tier Usage**: 750 hours/month for B1s VM
- **Log Analytics**: 5GB free ingestion per month
- **Sentinel**: Free for first 30 days

## Next Steps

1. **Advanced Queries**: Develop custom KQL queries
2. **Integration**: Connect external threat feeds
3. **Automation**: Implement advanced playbooks
4. **Scaling**: Expand to multiple VMs and services

## Resources

- [Microsoft Sentinel Documentation](https://docs.microsoft.com/en-us/azure/sentinel/)
- [KQL Query Reference](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)
- [Honeypot Security Research](https://www.honeynet.org/)

---

**Implementation Notes**: This lab environment is designed for educational and research purposes. The open attack surface is intentional for honeypot functionality. Always follow organizational security policies and local regulations. 