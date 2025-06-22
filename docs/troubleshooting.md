# 🆘 Troubleshooting Guide

This guide helps you resolve common issues encountered while setting up your cybersecurity home lab.

## 🔍 Common Issues & Solutions

### Issue 1: VM Not Responding to Ping

**Symptoms:**
- `ping` command fails
- VM appears offline
- Cannot RDP to VM

**Solutions:**

1. **Check VM Status**
   ```bash
   # In Azure CLI
   az vm show --name corpnet-east1 --resource-group rg-soc-lab --show-details
   ```

2. **Verify NSG Rules**
   - Go to VM → Networking
   - Ensure "Danger-AllowAll" rule exists
   - Priority should be 100 or lower

3. **Check VM Power State**
   - In Azure portal, verify VM is "Running"
   - If stopped, start the VM

4. **Verify Public IP**
   - Ensure VM has a public IP assigned
   - Check if IP is dynamic or static

### Issue 2: No Security Events in Log Analytics

**Symptoms:**
- `SecurityEvent` query returns no results
- No logs appearing after 30+ minutes

**Solutions:**

1. **Verify Data Collection Rule**
   ```bash
   # Check DCR status
   az monitor data-collection rule show --name dcr-win-logs --resource-group rg-soc-lab
   ```

2. **Check Agent Status**
   - Go to VM → Extensions
   - Verify "Azure Monitor Agent" is installed and running
   - If not, install it manually

3. **Verify Workspace Connection**
   - Go to Log Analytics workspace
   - Check "Agents" section for your VM
   - Ensure VM appears in connected agents

4. **Test Event Generation**
   - RDP to VM
   - Try logging in with wrong credentials
   - This should generate EventID 4625

### Issue 3: Sentinel Not Showing Data

**Symptoms:**
- Sentinel dashboard empty
- No incidents or alerts
- Data not flowing from Log Analytics

**Solutions:**

1. **Verify Sentinel Connection**
   - Go to Sentinel → Data Connectors
   - Check "Windows Security Events" status
   - Should show "Connected"

2. **Check Workspace Permissions**
   - Ensure you have "Contributor" access to workspace
   - Verify Sentinel is enabled on correct workspace

3. **Restart Data Collection**
   - Disable and re-enable Windows Security Events connector
   - Wait 15-30 minutes for data to flow

### Issue 4: GeoIP Watchlist Not Working

**Symptoms:**
- Geographic data not appearing in queries
- Lookup fails in KQL
- Watchlist shows errors

**Solutions:**

1. **Verify Watchlist Format**
   ```csv
   Network,CountryName,CityName,Latitude,Longitude
   192.168.1.0/24,United States,New York,40.7128,-74.0060
   ```

2. **Check Search Key**
   - Ensure search key is set to "Network"
   - Verify IP ranges are in CIDR notation

3. **Test Lookup Query**
   ```kql
   let geo = _GetWatchlist('geoip');
   geo
   | take 10
   ```

### Issue 5: High Azure Costs

**Symptoms:**
- Unexpected charges on Azure account
- Costs exceeding free tier limits

**Solutions:**

1. **Check Resource Usage**
   ```bash
   # List all resources in resource group
   az resource list --resource-group rg-soc-lab --output table
   ```

2. **Monitor Costs**
   - Go to Cost Management + Billing
   - Set up budget alerts
   - Review resource usage

3. **Optimize Resources**
   - Use B1s VM size (cheapest)
   - Disable boot diagnostics
   - Delete resources when not in use

### Issue 6: Attack Map Dashboard Not Working

**Symptoms:**
- Dashboard shows no data
- Map not displaying
- JSON import errors

**Solutions:**

1. **Verify Data Source**
   - Ensure KQL query in workbook returns data
   - Test query separately in Log Analytics

2. **Check JSON Format**
   - Validate JSON syntax
   - Ensure all required fields are present

3. **Refresh Data**
   - Click refresh button in workbook
   - Wait for data to load

### Issue 7: RDP Connection Issues

**Symptoms:**
- Cannot connect to VM via RDP
- Connection timeout
- Authentication errors

**Solutions:**

1. **Check Network Connectivity**
   ```bash
   # Test connectivity
   telnet <vm-public-ip> 3389
   ```

2. **Verify Credentials**
   - Username: `labuser`
   - Password: `Cyberlab123!`
   - Check for typos

3. **Reset Password**
   ```bash
   # Reset VM password
   az vm user update --name corpnet-east1 --resource-group rg-soc-lab --username labuser --password NewPassword123!
   ```

### Issue 8: KQL Query Errors

**Symptoms:**
- Query syntax errors
- Unexpected results
- Performance issues

**Solutions:**

1. **Check Syntax**
   ```kql
   // Basic syntax check
   SecurityEvent
   | where EventID == 4625
   | take 10
   ```

2. **Verify Table Names**
   - Use `SecurityEvent` for Windows security events
   - Check table exists in workspace

3. **Optimize Queries**
   - Add time filters: `| where TimeGenerated > ago(24h)`
   - Use `project` to limit columns
   - Add `limit` for large result sets

## 🔧 Diagnostic Commands

### Azure CLI Commands

```bash
# Check VM status
az vm show --name corpnet-east1 --resource-group rg-soc-lab

# List all resources
az resource list --resource-group rg-soc-lab --output table

# Check NSG rules
az network nsg rule list --resource-group rg-soc-lab --nsg-name <nsg-name>

# Check Log Analytics workspace
az monitor log-analytics workspace show --resource-group rg-soc-lab --workspace-name law-soc-lab
```

### PowerShell Commands

```powershell
# Test RDP connectivity
Test-NetConnection -ComputerName <vm-public-ip> -Port 3389

# Check Windows Firewall status
Get-NetFirewallProfile | Select-Object Name, Enabled
```

## 📞 Getting Help

### Before Asking for Help

1. **Check this guide** for your specific issue
2. **Search Azure documentation** for official solutions
3. **Verify all prerequisites** are met
4. **Test with minimal configuration**

### Useful Resources

- [Azure Status Page](https://status.azure.com/)
- [Microsoft Sentinel Documentation](https://docs.microsoft.com/en-us/azure/sentinel/)
- [KQL Query Reference](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
- [Azure Support](https://azure.microsoft.com/en-us/support/)

### When to Contact Support

- Azure service outages
- Billing issues
- Security concerns
- Complex technical problems

## 🚨 Emergency Procedures

### If VM is Compromised

1. **Immediate Actions**
   - Disconnect from internet (delete NSG rules)
   - Take VM snapshot for analysis
   - Document incident details

2. **Recovery Steps**
   - Delete compromised VM
   - Create new VM with updated security
   - Review and update procedures

### If Costs are Excessive

1. **Immediate Actions**
   - Stop all VMs
   - Delete unnecessary resources
   - Set up spending limits

2. **Prevention**
   - Use Azure Advisor for cost optimization
   - Set up budget alerts
   - Regular cost monitoring

## 📋 Maintenance Checklist

### Daily
- [ ] Check VM status
- [ ] Review recent security events
- [ ] Monitor costs

### Weekly
- [ ] Review attack patterns
- [ ] Update GeoIP data
- [ ] Backup important configurations

### Monthly
- [ ] Review and update security rules
- [ ] Analyze cost trends
- [ ] Update documentation

---

**💡 Pro Tip**: Keep a lab journal to document issues and solutions for future reference! 