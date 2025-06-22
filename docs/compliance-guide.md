# 📋 Simple Compliance Guide for Small/Mid-Size Companies

A straightforward guide to meet basic compliance requirements using your cybersecurity home lab.

## 🎯 Overview

This guide covers essential compliance frameworks that small and mid-size companies commonly need:
- **SOC 2 Type II** (Basic)
- **GDPR** (Basic)
- **ISO 27001** (Basic)
- **NIST Cybersecurity Framework** (Basic)

## 🔒 SOC 2 Type II (Basic)

### What is SOC 2?
SOC 2 is a security framework that ensures your company properly manages customer data.

### Basic Requirements
1. **Access Control**: Monitor who accesses your systems
2. **Authentication**: Track login attempts and failures
3. **Audit Logging**: Keep records of security events
4. **Change Management**: Monitor system changes

### Implementation with Your Lab
```kql
// SOC 2 Access Control Monitoring
SecurityEvent
| where EventID in (4624, 4625, 4634)
| where TimeGenerated > ago(24h)
| summarize 
    SuccessfulLogins = countif(EventID == 4624),
    FailedLogins = countif(EventID == 4625),
    Logoffs = countif(EventID == 4634)
    by bin(TimeGenerated, 1h)
```

### Daily Tasks
- [ ] Review failed login attempts
- [ ] Check for unusual access patterns
- [ ] Monitor account changes
- [ ] Document any security incidents

## 🔐 GDPR (Basic)

### What is GDPR?
GDPR protects personal data of EU citizens. Even small companies need basic compliance.

### Basic Requirements
1. **Data Access Monitoring**: Track who accesses personal data
2. **Consent Management**: Monitor data processing
3. **Breach Detection**: Detect unauthorized data access
4. **Audit Trail**: Keep records of data access

### Implementation with Your Lab
```kql
// GDPR Data Access Monitoring
SecurityEvent
| where EventID in (4663, 4660, 4656)
| where ObjectName contains "customer" or ObjectName contains "personal"
| project TimeGenerated, Account, ObjectName, AccessMask
```

### Daily Tasks
- [ ] Monitor data access patterns
- [ ] Check for unauthorized access
- [ ] Review data processing logs
- [ ] Document any data incidents

## 🛡️ ISO 27001 (Basic)

### What is ISO 27001?
ISO 27001 is an information security management standard.

### Basic Requirements
1. **Information Security Policy**: Monitor policy compliance
2. **Asset Management**: Track system assets
3. **Access Control**: Monitor user access
4. **Incident Management**: Detect and respond to incidents

### Implementation with Your Lab
```kql
// ISO 27001 Access Control
SecurityEvent
| where EventID in (4720, 4722, 4724, 4728, 4732, 4738, 4740)
| where TimeGenerated > ago(24h)
| project TimeGenerated, EventID, Account, Computer
```

### Daily Tasks
- [ ] Review access control events
- [ ] Monitor system changes
- [ ] Check for security incidents
- [ ] Update security policies

## 🏛️ NIST Cybersecurity Framework (Basic)

### What is NIST?
NIST provides a framework for managing cybersecurity risk.

### Basic Requirements
1. **Identify**: Know your systems and data
2. **Protect**: Implement security controls
3. **Detect**: Monitor for security events
4. **Respond**: Handle security incidents
5. **Recover**: Restore systems after incidents

### Implementation with Your Lab
```kql
// NIST Framework Monitoring
SecurityEvent
| where TimeGenerated > ago(24h)
| summarize 
    TotalEvents = count(),
    FailedLogins = countif(EventID == 4625),
    AccountChanges = countif(EventID in (4720, 4722, 4724))
| extend RiskLevel = case(
    FailedLogins > 20, "High",
    FailedLogins > 10, "Medium",
    "Low"
  )
```

## 📊 Compliance Dashboard

### What to Monitor Daily
1. **Security Events**: Total number of security events
2. **Failed Logins**: Authentication failures
3. **Account Changes**: User account modifications
4. **Data Access**: Access to sensitive data
5. **Compliance Score**: Overall security posture

### Simple Compliance Score
```kql
// Calculate Compliance Score
SecurityEvent
| where TimeGenerated > ago(24h)
| summarize 
    FailedLogins = countif(EventID == 4625),
    AccountChanges = countif(EventID in (4720, 4722, 4724))
| extend ComplianceScore = case(
    FailedLogins > 50, "High Risk",
    FailedLogins > 20, "Medium Risk",
    "Low Risk"
  )
```

## 📋 Compliance Checklist

### Daily Tasks (5 minutes)
- [ ] Check compliance dashboard
- [ ] Review failed login attempts
- [ ] Monitor data access events
- [ ] Document any incidents

### Weekly Tasks (15 minutes)
- [ ] Review security trends
- [ ] Update threat intelligence
- [ ] Check compliance score
- [ ] Review access patterns

### Monthly Tasks (1 hour)
- [ ] Compliance assessment
- [ ] Update security policies
- [ ] Staff training review
- [ ] Audit trail verification

## 📈 Simple Reporting

### Weekly Report Template
```
Week of: [Date]
Compliance Score: [Score]
Failed Logins: [Number]
Account Changes: [Number]
Data Access Events: [Number]
Incidents: [Number]
Actions Taken: [List]
```

### Monthly Report Template
```
Month: [Month/Year]
Overall Compliance: [Score]
Security Incidents: [Number]
Policy Updates: [List]
Training Completed: [Yes/No]
Next Month Goals: [List]
```

## 🚨 Incident Response (Simple)

### When to Act
- **High Risk**: More than 50 failed logins in 24 hours
- **Medium Risk**: More than 20 failed logins in 24 hours
- **Low Risk**: Normal activity levels

### Simple Response Steps
1. **Detect**: Monitor your dashboard
2. **Assess**: Check the threat level
3. **Respond**: Block IPs if needed
4. **Document**: Record the incident
5. **Review**: Learn from the incident

## 💡 Tips for Small Companies

### Keep It Simple
- Start with basic monitoring
- Focus on high-impact events
- Use automated dashboards
- Regular but brief reviews

### Cost-Effective Approach
- Use free Azure tier
- Start with essential monitoring
- Scale up as needed
- Focus on biggest risks

### Documentation
- Keep simple records
- Use templates
- Regular updates
- Easy to understand

## 🔧 Quick Setup

### Step 1: Import Compliance Dashboard
1. Go to Sentinel Workbooks
2. Import `compliance-dashboard.json`
3. Save as "Compliance Dashboard"

### Step 2: Set Up Alerts
1. Create basic alert rules
2. Set appropriate thresholds
3. Configure notifications
4. Test the alerts

### Step 3: Regular Monitoring
1. Check dashboard daily
2. Review alerts weekly
3. Update monthly
4. Document everything

## 📞 Getting Help

### Resources
- [SOC 2 Guide](https://www.aicpa.org/interestareas/frc/assuranceadvisoryservices/aicpasoc2report.html)
- [GDPR Guide](https://gdpr.eu/)
- [ISO 27001 Guide](https://www.iso.org/isoiec-27001-information-security.html)
- [NIST Framework](https://www.nist.gov/cyberframework)

### Support
- Use the troubleshooting guide
- Check community forums
- Contact Microsoft support
- Consult with security experts

---

**🎯 Remember: Start simple, be consistent, and build up over time. Compliance is a journey, not a destination!** 