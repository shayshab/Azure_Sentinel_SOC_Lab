# 🛠️ Complete Setup Guide: Cybersecurity Home Lab

This guide provides step-by-step instructions to build your complete cybersecurity home lab using Microsoft Sentinel and a honeypot virtual machine.

## 📋 Prerequisites Checklist

- [ ] Azure free account created
- [ ] Credit card added to Azure account
- [ ] Windows 10/11 machine for RDP
- [ ] Stable internet connection
- [ ] Basic familiarity with Azure portal

## ✅ Phase 1: Azure Infrastructure Setup

### Step 1.1 – Create Free Azure Account

1. **Visit Azure Free Tier**
   - Go to: https://azure.microsoft.com/free
   - Click "Start free" or "Free account"

2. **Sign Up Process**
   - Use a personal Gmail/Outlook email
   - Add a credit card (required for verification)
   - Note: You won't be charged unless you exceed free limits

3. **Verify Account**
   - Complete email verification
   - Wait for account activation (usually immediate)

### Step 1.2 – Create Resource Group

1. **Navigate to Resource Groups**
   - Go to Azure Portal: https://portal.azure.com
   - Search for "Resource Groups" in the search bar
   - Click "Resource Groups"

2. **Create New Resource Group**
   - Click "Create" button
   - Fill in the details:
     - **Name**: `rg-soc-lab`
     - **Region**: `East US 2`
     - **Subscription**: Your subscription
   - Click "Review + Create" → "Create"

### Step 1.3 – Create Virtual Network (VNet)

1. **Navigate to Virtual Networks**
   - Search for "Virtual Networks" in Azure portal
   - Click "Virtual Networks"

2. **Create Virtual Network**
   - Click "Create"
   - Fill in the details:
     - **Name**: `vnet-soc-lab`
     - **Resource Group**: `rg-soc-lab`
     - **Region**: `East US 2`
     - **Address Space**: Accept default (e.g., 10.0.0.0/16)
     - **Subnet**: Accept default settings
   - Click "Review + Create" → "Create"

## ✅ Phase 2: Deploy Honeypot Virtual Machine

### Step 2.1 – Create Virtual Machine

1. **Navigate to Virtual Machines**
   - Search for "Virtual Machines" in Azure portal
   - Click "Virtual Machines"

2. **Create VM**
   - Click "Create" → "Azure Virtual Machine"
   - Fill in the details:
     - **Name**: `corpnet-east1`
     - **Region**: `East US 2`
     - **Image**: `Windows 10 Pro`
     - **Size**: `Standard B1s` (low-cost option)
     - **Username**: `labuser`
     - **Password**: `Cyberlab123!`
     - **Public Inbound Ports**: `Allow selected ports`
     - **Selected Inbound Ports**: `RDP (3389)`
     - **Virtual Network**: `vnet-soc-lab`
     - **Subnet**: `default`
     - **Boot Diagnostics**: `Disable`
   - Click "Review + Create" → "Create"

### Step 2.2 – Open NSG to All Traffic

1. **Locate Network Security Group**
   - Go to Resource Group `rg-soc-lab`
   - Find the NSG associated with your VM (usually named `corpnet-east1-nsg`)
   - Click on the NSG name

2. **Configure Inbound Rules**
   - Click "Inbound Security Rules"
   - Delete the existing RDP rule (if present)
   - Click "Add" to create new rule:
     - **Source**: `Any`
     - **Source Port Ranges**: `*`
     - **Destination**: `Any`
     - **Destination Port Ranges**: `*`
     - **Protocol**: `Any`
     - **Action**: `Allow`
     - **Priority**: `100`
     - **Name**: `Danger-AllowAll`
     - **Description**: `⚠️ WARNING: Opens VM to all traffic`
   - Click "Add"

### Step 2.3 – Disable Internal Windows Firewall

1. **Connect to VM**
   - Use Remote Desktop Connection
   - Connect to your VM's public IP
   - Login with: `labuser` / `Cyberlab123!`

2. **Disable Windows Firewall**
   - Press `Windows + R`
   - Type: `wf.msc`
   - Press Enter
   - In Windows Firewall with Advanced Security:
     - Right-click "Windows Firewall Properties"
     - For each profile (Domain, Private, Public):
       - Set "Firewall State" to "Off"
       - Click "Apply"

## ✅ Phase 3: Test & Confirm Open Attack Surface

### Step 3.1 – Verify VM Accessibility

1. **Get Public IP**
   - Go to your VM in Azure portal
   - Copy the public IP address

2. **Test Connectivity**
   ```bash
   # On your local machine
   ping <your-vm-public-ip>
   ```
   
   **Expected Result**: Successful ping responses = VM is attack-ready

## ✅ Phase 4: Log Analytics & Sentinel Setup

### Step 4.1 – Create Log Analytics Workspace

1. **Navigate to Log Analytics**
   - Search for "Log Analytics Workspaces"
   - Click "Log Analytics Workspaces"

2. **Create Workspace**
   - Click "Create"
   - Fill in details:
     - **Name**: `law-soc-lab`
     - **Region**: `East US 2`
     - **Resource Group**: `rg-soc-lab`
   - Click "Review + Create" → "Create"

### Step 4.2 – Enable Microsoft Sentinel

1. **Navigate to Sentinel**
   - Search for "Microsoft Sentinel"
   - Click "Microsoft Sentinel"

2. **Add Sentinel**
   - Click "+ Add"
   - Select workspace: `law-soc-lab`
   - Click "Add"

### Step 4.3 – Enable Windows Security Event Connector

1. **Access Content Hub**
   - In Sentinel, go to "Content Hub"
   - Search for "Windows Security Events"

2. **Install Connector**
   - Click on "Windows Security Events"
   - Click "Install" → "Manage"
   - Select "Windows Security Events via Azure Monitoring Agent"
   - Click "Open Connector Page"

### Step 4.4 – Create Data Collection Rule (DCR)

1. **Create DCR**
   - Click "Create Data Collection Rule"
   - Fill in details:
     - **Name**: `dcr-win-logs`
     - **Resource Group**: `rg-soc-lab`
     - **Platform Type**: `Windows`
     - **Data Sources**: Select your VM `corpnet-east1`
     - **Event Types**: `All security events`
   - Click "Review + Create" → "Create"

### Step 4.5 – Verify Log Collection

1. **Check Log Analytics**
   - Go to Log Analytics workspace `law-soc-lab`
   - Click "Logs"
   - Run query:
   ```kql
   SecurityEvent
   ```
   
   **Note**: It may take 10-30 minutes for logs to appear initially.

## ✅ Phase 5: Analyze Attacks with KQL

### Step 5.1 – View Failed Logins

Run this query in Log Analytics:

```kql
SecurityEvent
| where EventID == 4625
```

This shows all failed login attempts (brute force attacks).

### Step 5.2 – Enhanced Query with Details

```kql
SecurityEvent
| where EventID == 4625
| project TimeGenerated, Account, Computer, IpAddress, WorkstationName
| order by TimeGenerated desc
```

## ✅ Phase 6: Enrich Logs with Geolocation

### Step 6.1 – Upload GeoIP Watchlist

1. **Access Watchlists**
   - In Sentinel, go to "Configuration" → "Watchlist"
   - Click "+ Add"

2. **Create Watchlist**
   - **Name**: `geoip`
   - **Alias**: `geoip`
   - **Description**: `IP to Country mapping`
   - **Search Key**: `Network`
   - Upload the CSV file from `data/geoip-sample.csv`

### Step 6.2 – Query with Geographic Data

```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625
| lookup geo on $left.IpAddress == $right.Network
| project TimeGenerated, Account, Computer, IpAddress, CityName, CountryName, Latitude, Longitude
| order by TimeGenerated desc
```

## ✅ Phase 7: Visual Attack Map Dashboard

### Step 7.1 – Create Workbook

1. **Access Workbooks**
   - In Sentinel, go to "Workbooks"
   - Click "Add Workbook"

2. **Import Attack Map**
   - Click "Edit"
   - Remove default content
   - Click "Advanced Editor"
   - Paste the JSON from `workbooks/attack-map.json`
   - Save as "Windows VM Attack Map"

## ✅ Phase 8: Optional – Add Alerts & Incidents

### Step 8.1 – Create Analytics Rule

1. **Navigate to Analytics**
   - In Sentinel, go to "Analytics"
   - Click "Create" → "Scheduled query rule"

2. **Configure Rule**
   - **Name**: `Brute Force Attack Detection`
   - **Description**: `Detects multiple failed login attempts`
   - **Tactics**: `Credential Access`
   - **Severity**: `Medium`

3. **Query**
   ```kql
   SecurityEvent
   | where EventID == 4625
   | summarize count() by IpAddress, bin(TimeGenerated, 5m)
   | where count_ > 5
   ```

4. **Alert Logic**
   - **Query scheduling**: Every 5 minutes
   - **Alert threshold**: Greater than 0
   - **Suppression**: 5 minutes

## 🔧 Post-Setup Verification

### Checklist for Success

- [ ] VM responds to ping from internet
- [ ] Security events appear in Log Analytics
- [ ] Failed login attempts are visible
- [ ] GeoIP data enriches attack logs
- [ ] Attack map dashboard displays data
- [ ] Alerts trigger on brute force attempts

### Expected Results

Within 24-48 hours, you should see:
- Failed login attempts from various countries
- Geographic attack patterns
- Real-time dashboard updates
- Automated alerts for suspicious activity

## 🚨 Important Notes

1. **Security Warning**: This setup intentionally creates an open attack surface
2. **Cost Monitoring**: Check Azure costs regularly
3. **Resource Cleanup**: Delete resources when not in use
4. **Lab Environment Only**: Never use this configuration in production

## 🆘 Troubleshooting

If you encounter issues, see the [Troubleshooting Guide](troubleshooting.md) for common solutions.

## 📞 Next Steps

- Explore the [KQL Queries Reference](kql-queries.md)
- Customize the attack map dashboard
- Set up additional alert rules
- Monitor and analyze attack patterns

---

**🎉 Congratulations! Your cybersecurity home lab is now operational and capturing real-world attacks!**

---

# 🎯 DETAILED STEP-BY-STEP PROCESS

## 📋 Complete Resource Naming Convention

**Resource Group**: `rg-soc-lab`
**Virtual Network**: `vnet-soc-lab`
**Virtual Machine**: `corpnet-east1`
**Log Analytics Workspace**: `law-soc-lab`
**Microsoft Sentinel**: Enabled on `law-soc-lab`
**Data Collection Rule**: `dcr-win-logs`
**GeoIP Watchlist**: `geoip`
**Network Security Group**: `corpnet-east1-nsg`
**Public IP**: `corpnet-east1-pip`
**Network Interface**: `corpnet-east1-nic`

## 🔧 Step-by-Step Azure Portal Navigation

### Step 1: Create Resource Group
1. **Open Azure Portal**: https://portal.azure.com
2. **Search**: Type "Resource Groups" in search bar
3. **Click**: "Resource Groups" service
4. **Click**: "+ Create" button
5. **Fill Details**:
   - **Subscription**: Select your subscription
   - **Resource Group**: `rg-soc-lab`
   - **Region**: `East US 2`
6. **Click**: "Review + Create"
7. **Click**: "Create"
8. **Wait**: For deployment to complete

### Step 2: Create Virtual Network
1. **Search**: "Virtual Networks" in search bar
2. **Click**: "Virtual Networks" service
3. **Click**: "+ Create"
4. **Fill Details**:
   - **Subscription**: Select your subscription
   - **Resource Group**: `rg-soc-lab`
   - **Name**: `vnet-soc-lab`
   - **Region**: `East US 2`
   - **Address Space**: `10.0.0.0/16`
   - **Subnet Name**: `default`
   - **Subnet Address Range**: `10.0.0.0/24`
5. **Click**: "Review + Create"
6. **Click**: "Create"
7. **Wait**: For deployment to complete

### Step 3: Create Virtual Machine
1. **Search**: "Virtual Machines" in search bar
2. **Click**: "Virtual Machines" service
3. **Click**: "+ Create" → "Azure Virtual Machine"
4. **Fill Basics Tab**:
   - **Subscription**: Select your subscription
   - **Resource Group**: `rg-soc-lab`
   - **Virtual Machine Name**: `corpnet-east1`
   - **Region**: `East US 2`
   - **Availability Options**: "No infrastructure redundancy required"
   - **Image**: "Windows 10 Pro, version 21H2 - Gen2"
   - **Size**: "Standard_B1s (1 vcpu, 1 GiB memory)"
   - **Username**: `labuser`
   - **Password**: `Cyberlab123!`
   - **Confirm Password**: `Cyberlab123!`
   - **Public Inbound Ports**: "Allow selected ports"
   - **Selected Inbound Ports**: "RDP (3389)"
5. **Click**: "Next: Disks"
6. **Disk Tab**:
   - **OS Disk Type**: "Standard SSD"
   - **Enable Encryption**: Leave default
7. **Click**: "Next: Networking"
8. **Networking Tab**:
   - **Virtual Network**: `vnet-soc-lab`
   - **Subnet**: `default (10.0.0.0/24)`
   - **Public IP**: "Create new" → Name: `corpnet-east1-pip`
   - **NIC Network Security Group**: "Advanced"
   - **Network Security Group**: "Create new" → Name: `corpnet-east1-nsg`
   - **Load Balancing**: "No"
9. **Click**: "Next: Management"
10. **Management Tab**:
    - **Boot Diagnostics**: "Disable"
    - **OS Guest Diagnostics**: "Disable"
    - **System Assigned Managed Identity**: "Off"
11. **Click**: "Next: Advanced"
12. **Advanced Tab**: Leave defaults
13. **Click**: "Next: Tags"
14. **Tags Tab**: Leave empty
15. **Click**: "Next: Review + Create"
16. **Review**: Verify all settings
17. **Click**: "Create"
18. **Wait**: For deployment to complete (5-10 minutes)

### Step 4: Configure Network Security Group
1. **Go to**: Resource Group `rg-soc-lab`
2. **Find**: Network Security Group `corpnet-east1-nsg`
3. **Click**: On the NSG name
4. **Click**: "Inbound Security Rules" in left menu
5. **Delete**: Any existing RDP rule (if present)
6. **Click**: "+ Add" button
7. **Fill Rule Details**:
    - **Source**: "Any"
    - **Source Port Ranges**: `*`
    - **Destination**: "Any"
    - **Destination Port Ranges**: `*`
    - **Protocol**: "Any"
    - **Action**: "Allow"
    - **Priority**: `100`
    - **Name**: `Danger-AllowAll`
    - **Description**: `⚠️ WARNING: Opens VM to all traffic`
8. **Click**: "Add"
9. **Wait**: For rule to be created

### Step 5: Get VM Public IP
1. **Go to**: Virtual Machine `corpnet-east1`
2. **Click**: "Overview" in left menu
3. **Copy**: Public IP address
4. **Note**: This IP for RDP connection

### Step 6: Connect to VM and Disable Firewall
1. **Open**: Remote Desktop Connection (Windows) or RDP client
2. **Enter**: VM Public IP address
3. **Click**: "Connect"
4. **Enter Credentials**:
    - **Username**: `labuser`
    - **Password**: `Cyberlab123!`
5. **Accept**: Certificate warning (if any)
6. **Wait**: For desktop to load
7. **Open Windows Firewall**:
    - Press `Windows + R`
    - Type: `wf.msc`
    - Press Enter
8. **Disable All Profiles**:
    - Right-click "Windows Firewall Properties"
    - **Domain Profile**: Set "Firewall State" to "Off"
    - **Private Profile**: Set "Firewall State" to "Off"
    - **Public Profile**: Set "Firewall State" to "Off"
    - Click "Apply" for each
9. **Close**: Windows Firewall window

### Step 7: Test VM Accessibility
1. **Open**: Command Prompt or Terminal
2. **Run**: `ping <VM-PUBLIC-IP>`
3. **Verify**: Successful ping responses
4. **Note**: If successful, VM is attack-ready

### Step 8: Create Log Analytics Workspace
1. **Search**: "Log Analytics Workspaces" in Azure portal
2. **Click**: "Log Analytics Workspaces" service
3. **Click**: "+ Create"
4. **Fill Details**:
    - **Subscription**: Select your subscription
    - **Resource Group**: `rg-soc-lab`
    - **Name**: `law-soc-lab`
    - **Region**: `East US 2`
5. **Click**: "Review + Create"
6. **Click**: "Create"
7. **Wait**: For deployment to complete

### Step 9: Enable Microsoft Sentinel
1. **Search**: "Microsoft Sentinel" in Azure portal
2. **Click**: "Microsoft Sentinel" service
3. **Click**: "+ Add"
4. **Select Workspace**:
    - Choose: `law-soc-lab`
    - Click "Add"
5. **Wait**: For Sentinel to be enabled (2-3 minutes)

### Step 10: Configure Windows Security Events Connector
1. **In Sentinel**: Go to "Content Hub"
2. **Search**: "Windows Security Events"
3. **Click**: On "Windows Security Events" connector
4. **Click**: "Install" button
5. **Click**: "Manage" button
6. **Select**: "Windows Security Events via Azure Monitoring Agent"
7. **Click**: "Open Connector Page"
8. **Click**: "Create Data Collection Rule"

### Step 11: Create Data Collection Rule
1. **Fill DCR Details**:
    - **Name**: `dcr-win-logs`
    - **Resource Group**: `rg-soc-lab`
    - **Platform Type**: "Windows"
    - **Data Sources**: Select VM `corpnet-east1`
    - **Event Types**: "All security events"
2. **Click**: "Review + Create"
3. **Click**: "Create"
4. **Wait**: For DCR to be created

### Step 12: Verify Log Collection
1. **Go to**: Log Analytics Workspace `law-soc-lab`
2. **Click**: "Logs" in left menu
3. **Run Query**:
   ```kql
   SecurityEvent
   ```
4. **Note**: May take 10-30 minutes for first logs to appear

### Step 13: Upload GeoIP Watchlist
1. **In Sentinel**: Go to "Configuration" → "Watchlist"
2. **Click**: "+ Add"
3. **Fill Details**:
    - **Name**: `geoip`
    - **Alias**: `geoip`
    - **Description**: "IP to Country mapping"
    - **Search Key**: `Network`
4. **Upload File**: Select `data/geoip-sample.csv`
5. **Click**: "Create"
6. **Wait**: For watchlist to be created

### Step 14: Create Attack Map Dashboard
1. **In Sentinel**: Go to "Workbooks"
2. **Click**: "Add Workbook"
3. **Click**: "Edit" button
4. **Remove**: All default content
5. **Click**: "Advanced Editor"
6. **Paste**: Content from `workbooks/attack-map.json`
7. **Click**: "Apply"
8. **Save**: As "Windows VM Attack Map"

### Step 15: Create Alert Rule (Optional)
1. **In Sentinel**: Go to "Analytics"
2. **Click**: "Create" → "Scheduled query rule"
3. **Fill Details**:
    - **Name**: "Brute Force Attack Detection"
    - **Description**: "Detects multiple failed login attempts"
    - **Tactics**: "Credential Access"
    - **Severity**: "Medium"
4. **Query**:
   ```kql
   SecurityEvent
   | where EventID == 4625
   | summarize count() by IpAddress, bin(TimeGenerated, 5m)
   | where count_ > 5
   ```
5. **Alert Logic**:
    - **Query scheduling**: Every 5 minutes
    - **Alert threshold**: Greater than 0
    - **Suppression**: 5 minutes
6. **Click**: "Create"

## 🎯 Verification Steps

### Step 16: Test Complete Setup
1. **Check VM Status**: VM should be running and accessible
2. **Verify Logs**: Run `SecurityEvent` query in Log Analytics
3. **Test GeoIP**: Run geographic query with watchlist
4. **Check Dashboard**: Attack map should display data
5. **Monitor Alerts**: Check if alert rules are working

## 📊 Expected Timeline

- **Immediate**: VM accessible via ping
- **10-30 minutes**: First security logs appear
- **1-2 hours**: Significant attack data visible
- **24-48 hours**: Full attack patterns emerge
- **1 week**: Comprehensive geographic analysis possible

## 🔍 Resource Monitoring

### Daily Checks
- [ ] VM is running
- [ ] Logs are flowing
- [ ] Dashboard is updating
- [ ] Costs are within budget

### Weekly Checks
- [ ] Review attack patterns
- [ ] Update GeoIP data
- [ ] Analyze cost trends
- [ ] Backup configurations

---

**🎉 Your cybersecurity home lab is now fully operational!** 