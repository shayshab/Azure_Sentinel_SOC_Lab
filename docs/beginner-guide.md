# Azure Sentinel SOC Lab: Implementation Notes

## Project Overview
Implementation notes for building a complete cybersecurity lab using Microsoft Azure Sentinel. This project demonstrates real-time attack monitoring, threat intelligence integration, and enterprise-grade security operations.

## Time Requirements
- **Total Implementation Time**: 4-6 hours (spread over 2-3 days)
- **Phase 1**: 1-2 hours (Azure infrastructure setup)
- **Phase 2**: 1-2 hours (Honeypot deployment and configuration)
- **Phase 3**: 1-2 hours (Sentinel configuration and data collection)
- **Phase 4**: 1 hour (Analysis, visualization, and reporting)

## Cost Analysis
- **Azure Free Tier**: $0 for first 12 months
- **Post Free Tier**: ~$50-100/month (depending on usage patterns)
- **First Year Total**: $0 (with proper free tier utilization)

---

## Phase 1: Azure Infrastructure Setup

### Step 1: Azure Account Creation
**Duration**: 30 minutes

**Objective**: Establish Azure tenant for lab environment

**Implementation Steps**:

1. **Portal Access**
   - Navigate to https://azure.microsoft.com/
   - Select "Start free" or "Free account"

2. **Account Registration**
   - Input email address
   - Create strong password
   - Complete identity verification via email

3. **Payment Verification**
   - Add credit card information (no charges during free period)
   - Complete phone verification
   - Accept terms of service

**Expected Outcome**: Active Azure subscription with $200 credit for 30 days

**Notes**: Keep credentials secure. Free tier provides adequate resources for lab environment.

---

### Step 2: Azure Portal Navigation
**Duration**: 15 minutes

**Objective**: Familiarize with Azure portal interface

**Implementation Steps**:

1. **Portal Access**
   - Navigate to https://portal.azure.com
   - Authenticate with new account

2. **Interface Exploration**
   - Review dashboard layout
   - Locate search functionality
   - Verify subscription status

3. **Resource Management**
   - Access subscription details
   - Review available services

**Expected Outcome**: Functional understanding of Azure portal navigation

---

### Step 3: Resource Group Creation
**Duration**: 10 minutes

**Objective**: Establish resource container for lab components

**Implementation Steps**:

1. **Resource Group Search**
   - Use portal search: "Resource groups"
   - Select "Resource groups" service

2. **Group Configuration**
   - Click "+ Create"
   - **Subscription**: Default selection
   - **Resource group name**: `sentinel-soc-lab-rg`
   - **Region**: Select nearest geographic location

3. **Deployment**
   - Review configuration
   - Execute creation
   - Verify successful deployment

**Expected Outcome**: Resource group ready for lab components

---

## Phase 2: Honeypot Virtual Machine Deployment

### Step 4: VM Creation
**Duration**: 45 minutes

**Objective**: Deploy honeypot virtual machine

**Implementation Steps**:

1. **VM Service Access**
   - Search: "Virtual machines"
   - Select "Virtual machines" service

2. **VM Configuration**
   - Click "+ Create" → "Virtual machine"
   - **Subscription**: Default
   - **Resource group**: `sentinel-soc-lab-rg`
   - **VM name**: `honeypot-vm`
   - **Region**: Match resource group
   - **Availability**: "No infrastructure redundancy required"
   - **Image**: Ubuntu Server 20.04 LTS
   - **Size**: B1s (1 vCPU, 1 GiB memory)

3. **Authentication Setup**
   - **Type**: Password
   - **Username**: `azureuser`
   - **Password**: Generate strong password
   - **Confirm password**: Match

4. **Network Configuration**
   - **Public inbound ports**: "Allow selected ports"
   - **Selected ports**: SSH (22), HTTP (80)
   - **Public IP**: Create new
   - **Public IP name**: `honeypot-vm-ip`

5. **Deployment**
   - Review configuration
   - Execute deployment
   - Monitor completion

**Expected Outcome**: Deployed VM with public IP address

**Security Note**: Public IP is intentional for honeypot functionality

---

### Step 5: Honeypot Configuration
**Duration**: 30 minutes

**Objective**: Configure VM as attack target

**Implementation Steps**:

1. **SSH Connection**
   - Access VM in portal
   - Navigate to "Connect" → "SSH"
   - Copy connection command

2. **Terminal Access**
   - Windows: Win+R → "cmd"
   - macOS: Terminal application
   - Linux: Terminal

3. **VM Access**
   - Execute SSH command
   - Authenticate with credentials

4. **Service Installation**
   ```bash
   # System update
   sudo apt update
   
   # Apache web server installation
   sudo apt install apache2 -y
   
   # SSH server verification
   sudo apt install openssh-server -y
   
   # Service activation
   sudo systemctl start apache2
   sudo systemctl enable apache2
   sudo systemctl start ssh
   sudo systemctl enable ssh
   ```

5. **Web Content Creation**
   ```bash
   # Create honeypot website
   sudo nano /var/www/html/index.html
   ```
   
   **Content**:
   ```html
   <html>
   <head><title>Company Internal Portal</title></head>
   <body>
   <h1>Welcome to Internal Company Portal</h1>
   <p>Employee login and sensitive data access</p>
   <form>
   <input type="text" placeholder="Username">
   <input type="password" placeholder="Password">
   <button type="submit">Login</button>
   </form>
   </body>
   </html>
   ```
   
   **Save**: Ctrl+X, Y, Enter

6. **Session Termination**
   ```bash
   exit
   ```

**Expected Outcome**: Functional honeypot with web interface

---

## Phase 3: Microsoft Sentinel Configuration

### Step 6: Log Analytics Workspace
**Duration**: 20 minutes

**Objective**: Create log collection workspace

**Implementation Steps**:

1. **Workspace Service**
   - Search: "Log Analytics workspaces"
   - Select service

2. **Workspace Creation**
   - Click "+ Create"
   - **Subscription**: Default
   - **Resource group**: `sentinel-soc-lab-rg`
   - **Name**: `sentinel-workspace`
   - **Region**: Match resource group

3. **Deployment**
   - Review configuration
   - Execute creation
   - Verify completion

**Expected Outcome**: Log Analytics workspace ready for Sentinel

---

### Step 7: Sentinel Deployment
**Duration**: 15 minutes

**Objective**: Enable Microsoft Sentinel

**Implementation Steps**:

1. **Sentinel Service**
   - Search: "Microsoft Sentinel"
   - Select service

2. **Sentinel Addition**
   - Click "+ Add"
   - Select workspace: `sentinel-workspace`
   - Click "Add Microsoft Sentinel"

3. **Deployment Monitoring**
   - Wait for completion (5-10 minutes)
   - Verify successful deployment

**Expected Outcome**: Active Microsoft Sentinel instance

---

### Step 8: Data Source Connection
**Duration**: 20 minutes

**Objective**: Connect honeypot to Sentinel

**Implementation Steps**:

1. **Sentinel Access**
   - Navigate to Microsoft Sentinel
   - Access workspace

2. **Data Connector Configuration**
   - Navigate to "Data connectors"
   - Search for "Linux"
   - Select "Linux" → "Open connector page"

3. **Agent Installation**
   - Click "Install agents"
   - Select VM: `honeypot-vm`
   - Click "Add"

4. **VM Agent Installation**
   - Return to VM
   - Access "Connect" → "SSH"
   - Copy installation command
   - Execute in SSH session

5. **Connection Verification**
   - Return to Sentinel
   - Check "Data connectors" → "Linux"
   - Verify "Connected" status

**Expected Outcome**: Honeypot sending logs to Sentinel

---

## Phase 4: Attack Monitoring and Analysis

### Step 9: Attack Traffic Generation
**Duration**: 30 minutes

**Objective**: Generate test attack traffic

**Implementation Steps**:

1. **IP Address Identification**
   - Access VM in portal
   - Copy "Public IP address"

2. **Port Scanning**
   - Navigate to https://www.yougetsignal.com/tools/open-ports/
   - Input VM IP address
   - Scan ports 22 (SSH) and 80 (HTTP)

3. **Web Access Testing**
   - Open browser
   - Navigate to `http://<VM_IP_ADDRESS>`
   - Verify website accessibility

4. **Authentication Testing**
   - Attempt login with invalid credentials
   - Generate failed authentication events

**Expected Outcome**: Attack traffic for analysis

---

### Step 10: Security Incident Review
**Duration**: 20 minutes

**Objective**: Analyze detected security events

**Implementation Steps**:

1. **Sentinel Access**
   - Navigate to Microsoft Sentinel

2. **Incident Review**
   - Access "Incidents"
   - Review any detected security incidents
   - Examine incident details

3. **Log Analysis**
   - Navigate to "Logs"
   - Access query interface

4. **Basic Query Execution**
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | summarize count() by Computer, TimeGenerated
   ```

**Expected Outcome**: Security event visibility and analysis

---

### Step 11: Dashboard Creation
**Duration**: 30 minutes

**Objective**: Create security monitoring dashboard

**Implementation Steps**:

1. **Workbook Access**
   - Navigate to "Workbooks"
   - Click "+ Add workbook"

2. **Dashboard Configuration**
   - Click "Edit"
   - Add security metrics

3. **Query Integration**
   - Click "+ Add" → "Add query"
   - **Query for failed logins**:
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | summarize FailedLogins = count() by bin(TimeGenerated, 1h)
   | render timechart
   ```

4. **Dashboard Persistence**
   - Click "Save"
   - **Name**: "Honeypot Security Dashboard"
   - Execute save

**Expected Outcome**: Functional security monitoring dashboard

---

## Phase 5: Advanced Analysis Implementation

### Step 12: KQL Query Implementation
**Duration**: 30 minutes

**Objective**: Execute advanced security queries

**Implementation Steps**:

1. **Query Interface Access**
   - Navigate to Sentinel → "Logs"

2. **Attack Geography Analysis**
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | extend IPAddress = extract("from ([0-9.]+)", 1, Message)
   | where isnotempty(IPAddress)
   | summarize AttackCount = count() by IPAddress
   | order by AttackCount desc
   ```

3. **Failed Authentication Analysis**
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | extend Username = extract("user ([^ ]+)", 1, Message)
   | where isnotempty(Username)
   | summarize FailedAttempts = count() by Username
   | order by FailedAttempts desc
   ```

**Expected Outcome**: Advanced threat analysis capabilities

---

### Step 13: Alert Rule Configuration
**Duration**: 20 minutes

**Objective**: Implement automated security alerting

**Implementation Steps**:

1. **Analytics Access**
   - Navigate to "Analytics"

2. **Rule Creation**
   - Click "+ Create" → "Scheduled query rule"

3. **Alert Configuration**
   - **Name**: "Multiple Failed Logins Alert"
   - **Description**: "Alert when multiple failed logins detected"
   - **Tactics**: "Credential Access"
   - **Severity**: "Medium"

4. **Query Definition**
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | summarize FailedLogins = count() by Computer, bin(TimeGenerated, 5m)
   | where FailedLogins > 5
   ```

5. **Schedule Configuration**
   - **Query scheduling**: Every 5 minutes
   - **Alert threshold**: Greater than 0

6. **Rule Deployment**
   - Review configuration
   - Execute creation

**Expected Outcome**: Automated security alerting system

---

## Phase 6: Documentation and Cleanup

### Step 14: Implementation Documentation
**Duration**: 30 minutes

**Objective**: Document lab implementation and findings

**Implementation Steps**:

1. **Document Creation**
   - Open text editor or document application
   - Create new document

2. **Implementation Documentation**
   - List deployed resources
   - Document IP addresses and credentials
   - Record implementation issues

3. **Analysis Documentation**
   - Copy query results
   - Screenshot dashboards
   - Document security incidents

4. **Document Persistence**
   - Save as "SOC_Lab_Implementation_Report.docx"

**Expected Outcome**: Complete implementation documentation

---

### Step 15: Resource Cleanup (Optional)
**Duration**: 15 minutes

**Objective**: Remove Azure resources to prevent charges

**Implementation Steps**:

1. **Resource Group Deletion**
   - Navigate to "Resource groups"
   - Select `sentinel-soc-lab-rg`
   - Click "Delete resource group"
   - Confirm deletion

2. **Deletion Monitoring**
   - Wait for completion (5-10 minutes)
   - Verify resource removal

**Important**: Only execute if lab environment is no longer needed

---

## Implementation Summary

### Accomplished Objectives
- Complete Azure Sentinel SOC lab deployment
- Honeypot virtual machine configuration
- Real-time attack monitoring implementation
- Security dashboard creation
- Automated alerting system
- Advanced threat analysis capabilities

### Next Steps
1. **Advanced Implementation**: Deploy additional VMs and services
2. **Query Development**: Create custom KQL queries
3. **Integration**: Connect with external threat feeds
4. **Automation**: Implement advanced playbooks

### Learning Resources
- Microsoft Learn: Azure Security courses
- Azure Sentinel documentation
- KQL query reference
- Enterprise security frameworks

---

## Troubleshooting Reference

### Common Implementation Issues

**VM Connection Failures**
- Verify VM running status
- Confirm credential accuracy
- Check SSH port accessibility

**Sentinel Data Issues**
- Verify Linux agent installation
- Check data connector status
- Allow 5-10 minutes for data propagation

**Billing Concerns**
- Monitor Azure billing dashboard
- Verify free tier resource usage
- Delete unused resources

**Query Execution Errors**
- Verify KQL syntax
- Confirm workspace selection
- Test with simplified queries

---

**Implementation Notes**: This lab environment is designed for educational and research purposes. The open attack surface is intentional for honeypot functionality. Always follow organizational security policies and local regulations. 