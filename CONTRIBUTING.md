# 🤝 Contributing to Cybersecurity Home Lab

Thank you for your interest in contributing to the Cybersecurity Home Lab project! This document provides guidelines for contributing to this educational cybersecurity project.

## 🎯 Project Goals

This project aims to:
- Provide hands-on cybersecurity learning experiences
- Demonstrate real-world attack patterns and defense strategies
- Create accessible, cost-effective security lab environments
- Share knowledge with the cybersecurity community

## 📋 How to Contribute

### 🐛 Reporting Issues

Before creating an issue, please:
1. Check the [troubleshooting guide](docs/troubleshooting.md)
2. Search existing issues to avoid duplicates
3. Provide detailed information about your environment

**Issue Template:**
```
**Environment:**
- OS: [Windows/Mac/Linux]
- Azure CLI Version: [version]
- Region: [Azure region]

**Problem:**
[Describe the issue]

**Steps to Reproduce:**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected vs Actual:**
[What you expected vs what happened]

**Logs/Error Messages:**
[Paste any relevant logs]
```

### 💡 Suggesting Enhancements

We welcome suggestions for:
- New KQL queries
- Additional security scenarios
- Cost optimization strategies
- Documentation improvements
- Dashboard enhancements

### 🔧 Code Contributions

#### Prerequisites
- Basic knowledge of Azure services
- Familiarity with KQL (Kusto Query Language)
- Understanding of cybersecurity concepts

#### Development Setup
1. Fork the repository
2. Clone your fork locally
3. Create a feature branch
4. Make your changes
5. Test thoroughly
6. Submit a pull request

#### Code Style Guidelines

**KQL Queries:**
- Use descriptive comments
- Include time filters for performance
- Add error handling where appropriate
- Test with sample data

**Documentation:**
- Use clear, concise language
- Include code examples
- Add screenshots for UI changes
- Update related documentation

**Scripts:**
- Add error handling
- Include usage examples
- Use consistent formatting
- Add safety checks

## 📁 Project Structure

```
cybersecurity-homelab/
├── docs/              # Documentation
├── scripts/           # Automation scripts
├── data/              # Sample data files
├── queries/           # KQL query library
├── workbooks/         # Sentinel workbooks
├── alerts/            # Alert rules
└── README.md          # Main documentation
```

## 🔒 Security Guidelines

### ⚠️ Important Security Notes

1. **Lab Environment Only**: This project creates intentionally vulnerable systems
2. **Never Deploy in Production**: These configurations are for educational purposes only
3. **Monitor Costs**: Azure resources can incur charges
4. **Clean Up**: Delete resources when not in use

### Security Best Practices

- Never commit real credentials or sensitive data
- Use parameterized queries for alerts
- Validate all input data
- Follow the principle of least privilege
- Document security considerations

## 🧪 Testing Guidelines

### Before Submitting

1. **Test in Isolated Environment**: Use Azure free tier for testing
2. **Verify KQL Queries**: Test all queries in Log Analytics
3. **Check Documentation**: Ensure all links work and instructions are clear
4. **Cost Validation**: Verify scripts don't create expensive resources
5. **Security Review**: Ensure no sensitive data is exposed

### Testing Checklist

- [ ] Azure CLI script runs without errors
- [ ] KQL queries return expected results
- [ ] Documentation is clear and accurate
- [ ] No hardcoded credentials
- [ ] Resources can be cleaned up easily
- [ ] Cost estimates are reasonable

## 📝 Pull Request Process

### Before Submitting a PR

1. **Fork and Clone**: Create your own fork and clone it
2. **Create Branch**: Use descriptive branch names (e.g., `feature/new-kql-query`)
3. **Make Changes**: Follow the coding guidelines
4. **Test Thoroughly**: Test all changes in a lab environment
5. **Update Documentation**: Update relevant documentation
6. **Commit Messages**: Use clear, descriptive commit messages

### PR Template

```
## Description
[Describe your changes]

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Query enhancement
- [ ] Script improvement

## Testing
- [ ] Tested in lab environment
- [ ] Verified KQL queries work
- [ ] Checked documentation accuracy
- [ ] Validated cost implications

## Security Considerations
[Describe any security implications]

## Screenshots (if applicable)
[Add screenshots for UI changes]
```

### Review Process

1. **Automated Checks**: Ensure all automated checks pass
2. **Code Review**: Address reviewer feedback
3. **Testing**: Maintainer will test in lab environment
4. **Documentation**: Ensure documentation is updated
5. **Merge**: Once approved, changes will be merged

## 🏷️ Issue Labels

We use the following labels to categorize issues:

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to documentation
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `question` - Further information is requested
- `security` - Security-related issues
- `cost-optimization` - Cost-related improvements

## 📚 Resources

### Learning Resources
- [Microsoft Sentinel Documentation](https://docs.microsoft.com/en-us/azure/sentinel/)
- [KQL Query Reference](https://docs.microsoft.com/en-us/azure/data-explorer/kusto/query/)
- [Azure Security Best Practices](https://docs.microsoft.com/en-us/azure/security/)

### Community
- [GitHub Discussions](https://github.com/yourusername/cybersecurity-homelab/discussions)
- [Issues](https://github.com/yourusername/cybersecurity-homelab/issues)
- [Wiki](https://github.com/yourusername/cybersecurity-homelab/wiki)

## 🙏 Recognition

Contributors will be recognized in:
- Project README
- Release notes
- Contributor hall of fame
- GitHub contributors page

## 📞 Getting Help

If you need help contributing:
1. Check the documentation
2. Search existing issues
3. Ask in GitHub Discussions
4. Contact maintainers

## 🎉 Thank You!

Thank you for contributing to the cybersecurity community! Your contributions help make cybersecurity education more accessible to everyone.

---

**Remember**: This project is for educational purposes. Always follow your organization's security policies and local laws. 