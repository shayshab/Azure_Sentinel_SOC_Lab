# 🚀 Beginner's Complete Guide: Azure Sentinel SOC Lab

## 📋 What You'll Learn
This guide will teach you how to build a complete cybersecurity lab using Microsoft Azure Sentinel. You'll learn:
- How to set up a virtual machine that attracts hackers (honeypot)
- How to monitor and analyze cyber attacks in real-time
- How to create security dashboards and reports
- Basic cybersecurity concepts and tools

## ⏱️ Time Required
- **Total Time**: 4-6 hours (spread over 2-3 days)
- **Phase 1**: 1-2 hours (Azure setup)
- **Phase 2**: 1-2 hours (Honeypot setup)
- **Phase 3**: 1-2 hours (Sentinel configuration)
- **Phase 4**: 1 hour (Analysis and reporting)

## 💰 Cost Estimate
- **Azure Free Tier**: $0 for first 12 months
- **After Free Tier**: ~$50-100/month (depending on usage)
- **Total First Year**: $0 (if using free tier properly)

---

# 🎯 PHASE 1: Azure Account Setup (Day 1)

## Step 1: Create Azure Account
**Time**: 30 minutes

### What You're Doing:
Setting up a Microsoft Azure account to host your cybersecurity lab.

### Detailed Steps:

1. **Go to Azure Website**
   - Open your web browser
   - Go to: https://azure.microsoft.com/
   - Click "Start free" or "Free account"

2. **Sign Up Process**
   - Enter your email address
   - Click "Next"
   - Enter a password (make it strong!)
   - Click "Create account"

3. **Verify Your Identity**
   - Microsoft will send a verification code to your email
   - Check your email and enter the code
   - Click "Verify"

4. **Add Payment Information**
   - Don't worry! You won't be charged during the free period
   - Enter your credit card information
   - This is just for verification purposes

5. **Complete Profile**
   - Enter your name and phone number
   - Click "Next"

6. **Verify Phone Number**
   - Microsoft will send a text message with a code
   - Enter the code and click "Verify"

7. **Agree to Terms**
   - Read the terms (or just check the box)
   - Click "Sign up"

### ✅ What You Should See:
- A welcome message from Azure
- Access to the Azure portal

### 🚨 Important Notes:
- Keep your login credentials safe
- You'll need a credit card, but won't be charged during free tier
- The free tier gives you $200 credit for 30 days

---

## Step 2: Navigate Azure Portal
**Time**: 15 minutes

### What You're Doing:
Learning how to use the Azure portal interface.

### Detailed Steps:

1. **Access Azure Portal**
   - Go to: https://portal.azure.com
   - Sign in with your new account

2. **Explore the Dashboard**
   - You'll see a dashboard with various tiles
   - This is your main control center for Azure

3. **Find the Search Bar**
   - At the top of the page, you'll see a search bar
   - This is how you'll find and create resources

4. **Check Your Subscription**
   - Click on "Subscriptions" in the left menu
   - You should see "Free Trial" or similar

### ✅ What You Should See:
- Azure portal dashboard
- Your subscription listed
- Search functionality working

---

## Step 3: Create Resource Group
**Time**: 10 minutes

### What You're Doing:
Creating a container to organize all your lab resources.

### Detailed Steps:

1. **Search for Resource Groups**
   - In the search bar, type "Resource groups"
   - Click on "Resource groups" from the results

2. **Create New Resource Group**
   - Click the "+ Create" button
   - You'll see a form to fill out

3. **Fill in the Details**
   - **Subscription**: Leave as default
   - **Resource group name**: `sentinel-soc-lab-rg`
   - **Region**: Choose the closest to you (e.g., "East US" for US East Coast)

4. **Create the Resource Group**
   - Click "Review + create"
   - Click "Create"
   - Wait for it to complete (usually 1-2 minutes)

### ✅ What You Should See:
- A new resource group created
- Status showing "Succeeded"

---

# 🎯 PHASE 2: Create Virtual Machine (Honeypot) (Day 1-2)

## Step 4: Create Virtual Machine
**Time**: 45 minutes

### What You're Doing:
Creating a virtual computer that will act as a honeypot (a system designed to attract hackers).

### Detailed Steps:

1. **Search for Virtual Machines**
   - In the search bar, type "Virtual machines"
   - Click on "Virtual machines"

2. **Create New VM**
   - Click the "+ Create" button
   - Select "Virtual machine"

3. **Fill in Basic Information**
   - **Subscription**: Leave as default
   - **Resource group**: Select `sentinel-soc-lab-rg` (the one you created)
   - **Virtual machine name**: `honeypot-vm`
   - **Region**: Same as your resource group
   - **Availability options**: "No infrastructure redundancy required"
   - **Image**: Click "See all images" → Search for "Ubuntu" → Select "Ubuntu Server 20.04 LTS"
   - **Size**: Click "See all sizes" → Search for "B1s" → Select "B1s" (1 vcpu, 1 GiB memory)

4. **Set Up Administrator Account**
   - **Authentication type**: "Password"
   - **Username**: `azureuser`
   - **Password**: Create a strong password (write it down!)
   - **Confirm password**: Enter the same password

5. **Configure Networking**
   - **Public inbound ports**: "Allow selected ports"
   - **Select inbound ports**: Check "SSH (22)" and "HTTP (80)"
   - **Public IP**: "Create new"
   - **Public IP name**: `honeypot-vm-ip`

6. **Review and Create**
   - Click "Review + create"
   - Review the summary
   - Click "Create"
   - Wait for deployment (5-10 minutes)

### ✅ What You Should See:
- Deployment status showing "Succeeded"
- A new virtual machine in your resource group

### 🚨 Important Notes:
- Save your username and password!
- The VM will have a public IP address (this is intentional for the honeypot)

---

## Step 5: Configure VM Security (Make it a Honeypot)
**Time**: 30 minutes

### What You're Doing:
Making your VM attractive to hackers by opening ports and installing vulnerable services.

### Detailed Steps:

1. **Connect to Your VM**
   - Go to your VM in Azure portal
   - Click "Connect" → "SSH"
   - Copy the SSH command shown

2. **Open Terminal/Command Prompt**
   - On Windows: Press Win+R, type "cmd", press Enter
   - On Mac: Open Terminal app
   - On Linux: Open terminal

3. **SSH into Your VM**
   - Paste the SSH command you copied
   - Press Enter
   - Enter your password when prompted

4. **Install Vulnerable Services**
   ```bash
   # Update the system
   sudo apt update
   
   # Install Apache web server
   sudo apt install apache2 -y
   
   # Install SSH server (if not already installed)
   sudo apt install openssh-server -y
   
   # Start and enable services
   sudo systemctl start apache2
   sudo systemctl enable apache2
   sudo systemctl start ssh
   sudo systemctl enable ssh
   ```

5. **Create a Fake Website**
   ```bash
   # Create a simple website
   sudo nano /var/www/html/index.html
   ```
   
   Add this content:
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
   
   Save and exit: Press Ctrl+X, then Y, then Enter

6. **Exit SSH**
   ```bash
   exit
   ```

### ✅ What You Should See:
- Apache web server running
- A fake company website accessible via HTTP
- SSH access working

---

# 🎯 PHASE 3: Set Up Microsoft Sentinel (Day 2)

## Step 6: Create Log Analytics Workspace
**Time**: 20 minutes

### What You're Doing:
Creating a workspace to collect and analyze security logs.

### Detailed Steps:

1. **Search for Log Analytics Workspace**
   - In Azure search bar, type "Log Analytics workspaces"
   - Click on "Log Analytics workspaces"

2. **Create New Workspace**
   - Click "+ Create"
   - Fill in the details:
     - **Subscription**: Leave as default
     - **Resource group**: Select `sentinel-soc-lab-rg`
     - **Name**: `sentinel-workspace`
     - **Region**: Same as your resource group

3. **Create the Workspace**
   - Click "Review + create"
   - Click "Create"
   - Wait for completion (2-3 minutes)

### ✅ What You Should See:
- A new Log Analytics workspace created
- Status showing "Succeeded"

---

## Step 7: Deploy Microsoft Sentinel
**Time**: 15 minutes

### What You're Doing:
Installing Microsoft Sentinel, which is your security monitoring system.

### Detailed Steps:

1. **Search for Microsoft Sentinel**
   - In Azure search bar, type "Microsoft Sentinel"
   - Click on "Microsoft Sentinel"

2. **Add Sentinel to Workspace**
   - Click "+ Add"
   - Select your workspace: `sentinel-workspace`
   - Click "Add Microsoft Sentinel"

3. **Wait for Deployment**
   - This takes 5-10 minutes
   - You'll see a notification when it's done

### ✅ What You Should See:
- Microsoft Sentinel added to your workspace
- Access to Sentinel dashboard

---

## Step 8: Connect VM to Sentinel
**Time**: 20 minutes

### What You're Doing:
Making your honeypot VM send security logs to Sentinel.

### Detailed Steps:

1. **Go to Microsoft Sentinel**
   - In Azure portal, search for "Microsoft Sentinel"
   - Click on your Sentinel workspace

2. **Add Data Connector**
   - In the left menu, click "Data connectors"
   - Search for "Linux"
   - Click on "Linux" → "Open connector page"

3. **Configure Linux Agent**
   - Click "Install agents"
   - Select your VM: `honeypot-vm`
   - Click "Add"

4. **Install Agent on VM**
   - Go back to your VM
   - Click "Connect" → "SSH"
   - Copy the installation command
   - SSH into your VM and run the command

5. **Verify Connection**
   - Go back to Sentinel
   - Check "Data connectors" → "Linux"
   - Status should show "Connected"

### ✅ What You Should See:
- Linux agent installed on your VM
- Data connector showing "Connected" status

---

# 🎯 PHASE 4: Monitor and Analyze Attacks (Day 2-3)

## Step 9: Generate Attack Traffic
**Time**: 30 minutes

### What You're Doing:
Creating fake attack traffic to test your monitoring system.

### Detailed Steps:

1. **Find Your VM's Public IP**
   - Go to your VM in Azure portal
   - Copy the "Public IP address"

2. **Use Online Port Scanner**
   - Go to: https://www.yougetsignal.com/tools/open-ports/
   - Enter your VM's IP address
   - Scan ports 22 (SSH) and 80 (HTTP)

3. **Try to Access Your Website**
   - Open a new browser tab
   - Go to: `http://YOUR_VM_IP_ADDRESS`
   - You should see your fake company website

4. **Simulate Login Attempts**
   - Try entering fake usernames and passwords
   - This will generate failed login events

### ✅ What You Should See:
- Your fake website accessible from the internet
- Port scan results showing open ports

---

## Step 10: View Security Incidents
**Time**: 20 minutes

### What You're Doing:
Checking if Sentinel detected the attack activities.

### Detailed Steps:

1. **Go to Microsoft Sentinel**
   - In Azure portal, open Microsoft Sentinel

2. **Check Incidents**
   - In the left menu, click "Incidents"
   - Look for any security incidents
   - Click on any incidents to see details

3. **Check Logs**
   - In the left menu, click "Logs"
   - This opens the query interface

4. **Run Basic Queries**
   - Try this query to see failed logins:
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | summarize count() by Computer, TimeGenerated
   ```

### ✅ What You Should See:
- Security incidents (if any attacks were detected)
- Log data from your VM
- Query results showing activity

---

## Step 11: Create Security Dashboard
**Time**: 30 minutes

### What You're Doing:
Creating a visual dashboard to monitor your security environment.

### Detailed Steps:

1. **Go to Workbooks**
   - In Sentinel, click "Workbooks" in the left menu

2. **Create New Workbook**
   - Click "+ Add workbook"
   - Click "Edit" to customize

3. **Add Security Metrics**
   - Click "+ Add" → "Add query"
   - Add this query for failed logins:
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | summarize FailedLogins = count() by bin(TimeGenerated, 1h)
   | render timechart
   ```

4. **Save Your Dashboard**
   - Click "Save"
   - Name it "Honeypot Security Dashboard"
   - Click "Save"

### ✅ What You Should See:
- A visual dashboard with security metrics
- Charts showing failed login attempts
- Real-time monitoring capabilities

---

# 🎯 PHASE 5: Advanced Analysis (Day 3)

## Step 12: Use Pre-built KQL Queries
**Time**: 30 minutes

### What You're Doing:
Using advanced queries to analyze security data.

### Detailed Steps:

1. **Open Logs in Sentinel**
   - Go to Sentinel → "Logs"

2. **Try Attack Geography Query**
   - Copy and paste this query:
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | extend IPAddress = extract("from ([0-9.]+)", 1, Message)
   | where isnotempty(IPAddress)
   | summarize AttackCount = count() by IPAddress
   | order by AttackCount desc
   ```

3. **Try Failed Logins Query**
   - Copy and paste this query:
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | extend Username = extract("user ([^ ]+)", 1, Message)
   | where isnotempty(Username)
   | summarize FailedAttempts = count() by Username
   | order by FailedAttempts desc
   ```

### ✅ What You Should See:
- Lists of IP addresses attempting attacks
- Usernames with failed login attempts
- Attack patterns and trends

---

## Step 13: Create Alerts
**Time**: 20 minutes

### What You're Doing:
Setting up automatic alerts for suspicious activities.

### Detailed Steps:

1. **Go to Analytics**
   - In Sentinel, click "Analytics" in the left menu

2. **Create New Rule**
   - Click "+ Create" → "Scheduled query rule"

3. **Configure Alert**
   - **Name**: "Multiple Failed Logins Alert"
   - **Description**: "Alert when multiple failed logins detected"
   - **Tactics**: Select "Credential Access"
   - **Severity**: "Medium"

4. **Set Query**
   ```kql
   Syslog
   | where Facility == "auth" and SeverityLevel == "Error"
   | summarize FailedLogins = count() by Computer, bin(TimeGenerated, 5m)
   | where FailedLogins > 5
   ```

5. **Set Schedule**
   - **Query scheduling**: Every 5 minutes
   - **Alert threshold**: Greater than 0

6. **Create the Alert**
   - Click "Review and create"
   - Click "Create"

### ✅ What You Should See:
- A new alert rule created
- Automatic monitoring of failed logins

---

# 🎯 PHASE 6: Clean Up and Documentation (Day 3)

## Step 14: Document Your Findings
**Time**: 30 minutes

### What You're Doing:
Creating a report of what you learned and discovered.

### Detailed Steps:

1. **Create a Report Document**
   - Open a text editor or Google Docs
   - Create a new document

2. **Document Your Setup**
   - List all resources you created
   - Note IP addresses and usernames
   - Document any issues you encountered

3. **Record Attack Data**
   - Copy any interesting query results
   - Screenshot your dashboards
   - Note any security incidents

4. **Save Your Documentation**
   - Save the file as "SOC_Lab_Report.docx" or similar

### ✅ What You Should See:
- A complete report of your lab setup
- Documentation of any attacks detected
- Screenshots of your dashboards

---

## Step 15: Clean Up Resources (Optional)
**Time**: 15 minutes

### What You're Doing:
Removing Azure resources to avoid charges (only if you want to stop using the lab).

### Detailed Steps:

1. **Delete Resource Group**
   - Go to "Resource groups" in Azure portal
   - Click on `sentinel-soc-lab-rg`
   - Click "Delete resource group"
   - Type the resource group name to confirm
   - Click "Delete"

2. **Wait for Deletion**
   - This takes 5-10 minutes
   - All resources will be removed

### ⚠️ Important:
- Only do this if you want to stop using the lab
- This will delete everything you created
- You can always recreate it later

---

# 🎉 Congratulations!

## What You've Accomplished:
✅ Created a complete cybersecurity lab in Azure  
✅ Set up a honeypot virtual machine  
✅ Deployed Microsoft Sentinel for monitoring  
✅ Generated and analyzed attack traffic  
✅ Created security dashboards and alerts  
✅ Learned basic cybersecurity concepts  

## Next Steps:
1. **Keep Learning**: Try different types of attacks
2. **Expand**: Add more VMs or services
3. **Practice**: Use the KQL queries in the `queries/` folder
4. **Share**: Show your lab to others interested in cybersecurity

## Resources for Further Learning:
- Microsoft Learn: Azure Security courses
- YouTube: Azure Sentinel tutorials
- Books: "Blue Team Handbook" by Don Murdoch
- Online: TryHackMe, HackTheBox for hands-on practice

---

# 🆘 Troubleshooting

## Common Issues and Solutions:

### "I can't connect to my VM"
- Check if the VM is running
- Verify your username and password
- Make sure SSH port (22) is open

### "No data in Sentinel"
- Verify the Linux agent is installed
- Check data connector status
- Wait 5-10 minutes for data to appear

### "I'm getting charged"
- Check your Azure billing
- Make sure you're using free tier resources
- Delete resources when not in use

### "Queries aren't working"
- Check the syntax carefully
- Make sure you're in the right workspace
- Try simpler queries first

---

**Remember**: This is a learning lab. Take your time, experiment, and don't worry about making mistakes. Every cybersecurity professional started as a beginner! 