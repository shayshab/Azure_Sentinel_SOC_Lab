# Azure Sentinel SOC Lab: Cybersecurity Home Lab Implementation

A comprehensive implementation guide for building a cybersecurity home lab using Microsoft Sentinel and a honeypot virtual machine to monitor and analyze real-world cyber attacks. Designed for developers and security professionals with enterprise-grade features suitable for mid-size company environments.

## Project Overview

This project demonstrates how to set up a complete Security Operations Center (SOC) lab environment that captures, analyzes, and visualizes real cyber attacks in real-time. The implementation is designed for cybersecurity professionals, developers, and mid-size companies looking to gain hands-on experience with enterprise-grade security tools.

## Architecture

```
Azure Tenant
 └── Subscription
      └── rg-soc-lab (Resource Group)
           ├── vnet-soc-lab (Virtual Network)
           │    └── Subnet + Virtual Machine (Honeypot)
           ├── law-soc-lab (Log Analytics Workspace)
           └── Microsoft Sentinel
                ├── GeoIP Watchlist
                ├── KQL Queries
                ├── Attack Map Dashboard
                ├── Alert Rules
                ├── Playbooks (Automation)
                └── Threat Intelligence
```

## Features

- **Real-time Attack Monitoring**: Capture live cyber attacks from around the world
- **Geolocation Analysis**: Map attack origins with detailed geographic data
- **Interactive Dashboard**: Visualize attacks on an interactive world map
- **KQL Query Library**: Pre-built queries for threat analysis
- **Automated Alerting**: Configure alerts for specific attack patterns
- **Cost-Effective**: Uses Azure free tier and low-cost resources
- **Enterprise Ready**: Includes compliance, automation, and threat intelligence
- **Scalable Design**: Easy to expand for production environments

## Prerequisites

- Azure free account (https://azure.microsoft.com/free)
- Basic understanding of Azure services
- Windows 10/11 for RDP connection
- Internet connection

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/shayshab/Azure_Sentinel_SOC_Lab.git
cd Azure_Sentinel_SOC_Lab
```

### 2. Follow the Setup Guide
- [Complete Setup Guide](docs/setup-guide.md)
- [Troubleshooting](docs/troubleshooting.md)
- [KQL Queries Reference](docs/kql-queries.md)
- [Enterprise Features](docs/enterprise-features.md)

### 3. Deploy Infrastructure
Use the provided Azure CLI scripts or follow the manual setup guide.

## Project Structure

```
Azure_Sentinel_SOC_Lab/
├── docs/                          # Documentation
│   ├── setup-guide.md            # Complete setup instructions
│   ├── troubleshooting.md        # Common issues and solutions
│   ├── kql-queries.md            # KQL query reference
│   ├── enterprise-features.md    # Enterprise enhancements
│   └── compliance-guide.md       # Compliance considerations
├── scripts/                       # Automation scripts
│   ├── azure-setup.sh            # Azure infrastructure setup
│   ├── deploy-honeypot.ps1       # Honeypot deployment
│   ├── configure-sentinel.ps1    # Sentinel configuration
│   └── compliance-checks.ps1     # Compliance validation
├── data/                          # Sample data and watchlists
│   ├── geoip-sample.csv          # Sample GeoIP data
│   ├── threat-intel.csv          # Threat intelligence data
│   └── compliance-templates/     # Compliance templates
├── queries/                       # KQL query library
│   ├── failed-logins.kql         # Failed login analysis
│   ├── attack-geography.kql      # Geographic attack analysis
│   ├── threat-intelligence.kql   # Threat intel queries
│   ├── compliance-monitoring.kql # Compliance queries
│   └── advanced-analytics.kql    # Advanced analytics
├── workbooks/                     # Sentinel workbooks
│   ├── attack-map.json           # Interactive attack map
│   ├── compliance-dashboard.json # Compliance dashboard
│   └── executive-summary.json    # Executive dashboard
├── alerts/                        # Alert rules
│   ├── brute-force-alert.json    # Brute force detection
│   ├── geo-based-alert.json      # Geographic-based alerts
│   ├── compliance-alerts.json    # Compliance monitoring
│   └── threat-intel-alerts.json  # Threat intelligence alerts
├── playbooks/                     # Automation playbooks
│   ├── incident-response.json    # Incident response automation
│   └── threat-hunting.json       # Threat hunting automation
└── README.md                      # This file
```

## Setup Phases

### Phase 1: Azure Infrastructure
- Create Azure account and resource group
- Deploy virtual network
- Set up Log Analytics workspace

### Phase 2: Honeypot Deployment
- Deploy Windows VM as honeypot
- Configure network security (open to all traffic)
- Disable Windows Firewall

### Phase 3: Sentinel Configuration
- Enable Microsoft Sentinel
- Configure data collection rules
- Set up Windows Security Events connector

### Phase 4: Analysis & Visualization
- Import GeoIP watchlist
- Create KQL queries
- Build interactive dashboard

### Phase 5: Enterprise Features
- Configure compliance monitoring
- Set up threat intelligence
- Create automation playbooks
- Implement alert rules

## What You'll Learn

- **Azure Security Services**: Hands-on experience with Microsoft's security stack
- **Threat Intelligence**: Real-world attack patterns and indicators
- **SIEM Operations**: Log analysis, alerting, and incident response
- **KQL (Kusto Query Language)**: Advanced querying for security data
- **Geographic Threat Analysis**: Understanding attack origins and patterns
- **Dashboard Creation**: Building interactive security visualizations
- **Compliance Monitoring**: Meeting regulatory requirements
- **Automation**: Streamlining security operations

## Sample Outputs

### Attack Map Dashboard
![Attack Map](docs/images/attack-map.png)

### Failed Login Analysis
```
TimeGenerated          | Account    | IpAddress    | CountryName | CityName
2024-01-15 10:30:15   | admin      | 192.168.1.1  | Russia      | Moscow
2024-01-15 10:31:22   | root       | 45.67.89.123 | China       | Beijing
```

### Compliance Dashboard
```
Compliance Status      | Score | Last Check
SOC 2 Type II         | 95%   | 2024-01-15
GDPR Compliance       | 92%   | 2024-01-15
ISO 27001             | 88%   | 2024-01-15
```

## Security Considerations

**Important**: This lab intentionally creates an open attack surface. Never deploy this configuration in production environments.

- Use only in isolated lab environments
- Monitor costs regularly
- Delete resources when not in use
- Never use real credentials or sensitive data
- Follow enterprise security policies

## Cost Management

- **Estimated Monthly Cost**: $5-15 USD (lab environment)
- **Enterprise Scaling**: $50-200 USD (production-ready)
- **Free Tier Usage**: 750 hours/month for B1s VM
- **Log Analytics**: 5GB free ingestion per month
- **Sentinel**: Free for first 30 days

## Enterprise Features

### Compliance & Governance
- **SOC 2 Type II** monitoring templates
- **GDPR** compliance tracking
- **ISO 27001** security controls
- **NIST Cybersecurity Framework** alignment
- **Audit trail** and reporting

### Threat Intelligence
- **IOC (Indicators of Compromise)** integration
- **Threat feed** aggregation
- **Reputation scoring** for IPs
- **Malware analysis** integration
- **Threat hunting** capabilities

### Automation & Orchestration
- **Incident response** playbooks
- **Automated threat blocking**
- **Escalation workflows**
- **Integration** with ticketing systems
- **Custom automation** scripts

### Advanced Analytics
- **Machine learning** anomaly detection
- **Behavioral analysis** of users
- **Predictive threat modeling**
- **Risk scoring** algorithms
- **Advanced correlation** rules

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

### How to Contribute
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Additional Resources

- [Microsoft Sentinel Documentation](https://docs.microsoft.com/en-us/azure/sentinel/)
- [KQL Query Reference](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)
- [Honeypot Security Research](https://www.honeynet.org/)
- [Enterprise Security Frameworks](https://www.nist.gov/cyberframework)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This project is for educational and research purposes only. The authors are not responsible for any misuse of this information. Always follow your organization's security policies and local laws.

## Support

- **Issues**: [GitHub Issues](https://github.com/shayshab/Azure_Sentinel_SOC_Lab/issues)
- **Discussions**: [GitHub Discussions](https://github.com/shayshab/Azure_Sentinel_SOC_Lab/discussions)
- **Wiki**: [Project Wiki](https://github.com/shayshab/Azure_Sentinel_SOC_Lab/wiki)

## Acknowledgments

- Microsoft Azure for providing the platform
- The cybersecurity community for continuous research
- Contributors and beta testers

---

**If this project helped you, please give it a star!**
