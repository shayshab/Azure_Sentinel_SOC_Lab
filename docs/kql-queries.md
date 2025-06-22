# 🔍 KQL Queries Reference Guide

This guide provides a comprehensive collection of KQL (Kusto Query Language) queries for analyzing security events in your cybersecurity home lab.

## 📚 Query Categories

- [Basic Security Events](#basic-security-events)
- [Failed Login Analysis](#failed-login-analysis)
- [Geographic Analysis](#geographic-analysis)
- [Attack Pattern Detection](#attack-pattern-detection)
- [Threat Intelligence](#threat-intelligence)
- [Performance & Optimization](#performance--optimization)

## 🔐 Basic Security Events

### View All Security Events
```kql
SecurityEvent
| order by TimeGenerated desc
```

### Recent Security Events (Last 24 Hours)
```kql
SecurityEvent
| where TimeGenerated > ago(24h)
| order by TimeGenerated desc
```

### Security Events by Type
```kql
SecurityEvent
| summarize count() by EventID
| order by count_ desc
```

### Top Event IDs
```kql
SecurityEvent
| where TimeGenerated > ago(7d)
| summarize count() by EventID
| order by count_ desc
| take 10
```

## 🚫 Failed Login Analysis

### All Failed Login Attempts
```kql
SecurityEvent
| where EventID == 4625
| order by TimeGenerated desc
```

### Failed Logins with Details
```kql
SecurityEvent
| where EventID == 4625
| project TimeGenerated, Account, Computer, IpAddress, WorkstationName, LogonType
| order by TimeGenerated desc
```

### Failed Logins by IP Address
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by IpAddress
| order by count_ desc
| take 20
```

### Failed Logins by Account
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by Account
| order by count_ desc
| take 10
```

### Brute Force Detection (5+ attempts in 5 minutes)
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by IpAddress, bin(TimeGenerated, 5m)
| where count_ > 5
| order by count_ desc
```

### Failed Login Timeline
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by bin(TimeGenerated, 1h)
| render timechart
```

## 🌍 Geographic Analysis

### Failed Logins with Geographic Data
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625
| lookup geo on $left.IpAddress == $right.Network
| project TimeGenerated, Account, Computer, IpAddress, CityName, CountryName, Latitude, Longitude
| order by TimeGenerated desc
```

### Attacks by Country
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625
| lookup geo on $left.IpAddress == $right.Network
| summarize count() by CountryName
| order by count_ desc
| take 20
```

### Attacks by City
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625
| lookup geo on $left.IpAddress == $right.Network
| summarize count() by CityName, CountryName
| order by count_ desc
| take 15
```

### Geographic Attack Timeline
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625
| lookup geo on $left.IpAddress == $right.Network
| summarize count() by CountryName, bin(TimeGenerated, 1h)
| render timechart
```

### Top Attacking Countries (Last 7 Days)
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625 and TimeGenerated > ago(7d)
| lookup geo on $left.IpAddress == $right.Network
| summarize count() by CountryName
| order by count_ desc
| take 10
```

## 🎯 Attack Pattern Detection

### Common Attack Patterns
```kql
SecurityEvent
| where EventID == 4625
| summarize 
    TotalAttempts = count(),
    UniqueIPs = dcount(IpAddress),
    UniqueAccounts = dcount(Account)
    by IpAddress
| where TotalAttempts > 10
| order by TotalAttempts desc
```

### Account Enumeration Detection
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by IpAddress, Account
| where count_ > 3
| summarize TotalAccounts = dcount(Account) by IpAddress
| where TotalAccounts > 5
| order by TotalAccounts desc
```

### Time-based Attack Patterns
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by IpAddress, bin(TimeGenerated, 1h)
| where count_ > 10
| order by count_ desc
```

### Suspicious IP Addresses
```kql
SecurityEvent
| where EventID == 4625
| summarize 
    Attempts = count(),
    Accounts = dcount(Account),
    FirstSeen = min(TimeGenerated),
    LastSeen = max(TimeGenerated)
    by IpAddress
| where Attempts > 20
| extend Duration = LastSeen - FirstSeen
| order by Attempts desc
```

## 🕵️ Threat Intelligence

### Known Malicious IPs (Example)
```kql
let maliciousIPs = datatable(IP:string) [
    "192.168.1.100",
    "10.0.0.50"
];
SecurityEvent
| where EventID == 4625
| where IpAddress in (maliciousIPs)
| order by TimeGenerated desc
```

### High-Risk Countries
```kql
let highRiskCountries = datatable(Country:string) [
    "Russia",
    "China",
    "North Korea",
    "Iran"
];
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625
| lookup geo on $left.IpAddress == $right.Network
| where CountryName in (highRiskCountries)
| order by TimeGenerated desc
```

### Suspicious Account Names
```kql
let suspiciousAccounts = datatable(Account:string) [
    "admin",
    "administrator",
    "root",
    "test",
    "guest"
];
SecurityEvent
| where EventID == 4625
| where Account in (suspiciousAccounts)
| order by TimeGenerated desc
```

## ⚡ Performance & Optimization

### Optimized Query with Time Filter
```kql
SecurityEvent
| where EventID == 4625 and TimeGenerated > ago(24h)
| project TimeGenerated, Account, Computer, IpAddress
| order by TimeGenerated desc
| take 100
```

### Efficient Geographic Lookup
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625 and TimeGenerated > ago(7d)
| lookup geo on $left.IpAddress == $right.Network
| project TimeGenerated, IpAddress, CountryName, CityName
| summarize count() by CountryName
| order by count_ desc
```

### Memory-Efficient Large Dataset Query
```kql
SecurityEvent
| where EventID == 4625 and TimeGenerated > ago(30d)
| summarize count() by IpAddress, bin(TimeGenerated, 1d)
| where count_ > 5
| order by count_ desc
```

## 📊 Visualization Queries

### Attack Map Data
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625 and TimeGenerated > ago(24h)
| lookup geo on $left.IpAddress == $right.Network
| summarize count() by Latitude, Longitude, CountryName, CityName
| where isnotempty(Latitude) and isnotempty(Longitude)
| order by count_ desc
```

### Time Series Chart
```kql
SecurityEvent
| where EventID == 4625 and TimeGenerated > ago(7d)
| summarize count() by bin(TimeGenerated, 1h)
| render timechart
```

### Pie Chart by Country
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625 and TimeGenerated > ago(7d)
| lookup geo on $left.IpAddress == $right.Network
| summarize count() by CountryName
| order by count_ desc
| take 10
| render piechart
```

## 🔧 Custom Functions

### Create Reusable Function
```kql
let GetFailedLogins = (timeRange:timespan) {
    SecurityEvent
    | where EventID == 4625 and TimeGenerated > ago(timeRange)
    | order by TimeGenerated desc
};
GetFailedLogins(24h)
```

### Geographic Analysis Function
```kql
let GetGeographicAttacks = (timeRange:timespan) {
    let geo = _GetWatchlist('geoip');
    SecurityEvent
    | where EventID == 4625 and TimeGenerated > ago(timeRange)
    | lookup geo on $left.IpAddress == $right.Network
    | project TimeGenerated, IpAddress, CountryName, CityName, Latitude, Longitude
    | order by TimeGenerated desc
};
GetGeographicAttacks(7d)
```

## 📈 Advanced Analytics

### Attack Velocity Analysis
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by IpAddress, bin(TimeGenerated, 5m)
| where count_ > 5
| summarize 
    TotalBursts = count(),
    MaxAttempts = max(count_),
    AvgAttempts = avg(count_)
    by IpAddress
| order by TotalBursts desc
```

### Account Targeting Analysis
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by Account, IpAddress
| summarize 
    TotalIPs = dcount(IpAddress),
    TotalAttempts = sum(count_)
    by Account
| where TotalIPs > 3
| order by TotalAttempts desc
```

### Time-of-Day Attack Patterns
```kql
SecurityEvent
| where EventID == 4625
| extend HourOfDay = hourofday(TimeGenerated)
| summarize count() by HourOfDay
| order by HourOfDay
| render columnchart
```

## 🚨 Alert Queries

### High-Volume Attack Alert
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by IpAddress, bin(TimeGenerated, 10m)
| where count_ > 20
```

### Geographic Alert
```kql
let geo = _GetWatchlist('geoip');
SecurityEvent
| where EventID == 4625
| lookup geo on $left.IpAddress == $right.Network
| where CountryName in ("Russia", "China", "North Korea")
| summarize count() by IpAddress, CountryName
| where count_ > 5
```

### Account Enumeration Alert
```kql
SecurityEvent
| where EventID == 4625
| summarize count() by IpAddress, Account
| where count_ > 3
| summarize TotalAccounts = dcount(Account) by IpAddress
| where TotalAccounts > 10
```

## 💡 Tips & Best Practices

### Query Optimization
1. **Always use time filters** to limit data scope
2. **Use `project`** to select only needed columns
3. **Add `take` or `limit`** for large result sets
4. **Use `summarize`** early to reduce data volume

### Performance Tips
1. **Cache frequently used data** in variables
2. **Use `bin()`** for time-based aggregations
3. **Avoid `extend`** with complex calculations on large datasets
4. **Test queries** with small time ranges first

### Security Considerations
1. **Never log sensitive data** in queries
2. **Use parameterized queries** for alerts
3. **Validate input data** before processing
4. **Monitor query performance** and costs

---

**🔍 Pro Tip**: Save your most useful queries as favorites in Log Analytics for quick access! 