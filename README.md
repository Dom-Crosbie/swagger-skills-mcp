# Smartbear Swagger API Development Skill for Claude Code

A comprehensive VS Code skill that enables Claude Code to build, validate, and publish APIs with full Smartbear Swagger integration.

## What This Skill Does

This skill provides Claude Code with a complete end-to-end API development workflow:

1. **Generate API Code** - Production-ready REST API implementations
2. **Validate & Standardize** - Automatic governance compliance checking using Smartbear rules
3. **Fix Issues** - AI-powered auto-correction of governance violations
4. **Update SwaggerHub** - Publish OpenAPI specs to SwaggerHub Registry
5. **Sync Documentation** - Update Swagger Portal with latest docs
6. **Publish to GitHub** - Commit and push changes to version control

## Quick Start

### Installation
1. Ensure the Smartbear MCP server is running and configured
2. Place `SKILL.md` in your workspace's `.vscode` or `.github` directory
3. Open VS Code and start a conversation with Claude

### First Usage
Simply ask Claude:
```
Build a REST API for [your use case]
```

Claude will automatically:
- Generate the code
- Create an OpenAPI specification
- Validate against your organization's governance rules
- Fix any issues
- Upload to SwaggerHub
- Update your portal documentation
- Push to GitHub

## Documentation

- **[SKILL.md](./SKILL.md)** - Complete skill definition and workflow details
- **[SETUP-GUIDE.md](./SETUP-GUIDE.md)** - Step-by-step setup instructions, examples, and troubleshooting

## Features

### 🔄 Complete Workflow Automation
- End-to-end API lifecycle management
- Automatic validation and standardization
- Seamless integration with Smartbear ecosystem

### 🛡️ Governance & Compliance
- Scans OpenAPI specs against organization rules
- AI-powered auto-fix for governance violations
- Ensures consistency across all APIs

### 📚 Documentation Sync
- Automatic portal updates
- API reference linking
- Documentation versioning

### 🚀 CI/CD Ready
- Git integration
- Atomic commits (code + spec + docs)
- Version control best practices

## Requirements

- VS Code with Claude Code extension
- Smartbear MCP server (running locally)
- SwaggerHub account with appropriate permissions
- GitHub repository access
- Git configured and authenticated

## File Structure

```
swaqgger-skills-mcp/
├── SKILL.md           # Main skill definition (place in .vscode/)
├── SETUP-GUIDE.md     # Comprehensive setup and usage guide
└── README.md          # This file
```

## Example Commands

### Create New API
```
Build a REST API for customer orders with CRUD operations
```

### Update Existing API
```
Add pagination to the GET /customers endpoint
```

### Validate Spec Only
```
Validate my OpenAPI spec at specs/openapi.yaml against Smartbear governance rules
```

### Update Documentation
```
Update the portal documentation for the payments API
```

## Workflow Phases

1. **API Code Generation** - Write implementation code with best practices
2. **Validation & Standardization** - Check governance compliance
3. **Code Refinement** - Apply fixes and improvements
4. **SwaggerHub Update** - Publish to registry
5. **Portal Documentation** - Sync documentation
6. **GitHub Publication** - Version control

## Supported Languages

The skill works with any language that can implement REST APIs:
- Node.js (Express, Fastify, Koa)
- Python (FastAPI, Flask, Django)
- Java (Spring Boot)
- C# (.NET Core)
- Go
- Ruby (Rails, Sinatra)
- PHP (Laravel)

## MCP Tools Used

This skill leverages 20+ Smartbear MCP tools including:

- `scan_api_standardization` - Validate governance compliance
- `standardize_api` - Auto-fix violations
- `create_or_update_api` - Publish to SwaggerHub
- `list_portals` - Find documentation portals
- `publish_portal_product` - Publish documentation
- And many more...

## Troubleshooting

See [SETUP-GUIDE.md](./SETUP-GUIDE.md#troubleshooting) for detailed troubleshooting steps.

Common issues:
- **MCP tools not found**: Ask Claude to "Load Smartbear MCP tools"
- **Organization errors**: Verify organization name (case-sensitive)
- **Portal not found**: List portals first to get correct identifier
- **Git errors**: Check remote configuration and credentials

## Best Practices

1. **Commit specs with code** - Keep them in sync
2. **Use semantic versioning** - Track API changes properly
3. **Validate early** - Catch issues before review
4. **Document thoroughly** - Include examples in specs
5. **Test comprehensively** - Validate against schemas

## Customization

The skill can be customized by editing `SKILL.md`:
- Adjust `applyTo` patterns to change when it activates
- Modify `allowedTools` to restrict or expand tool usage
- Update workflow steps to match your team's process
- Add organization-specific governance rules

## Contributing

This skill is designed for your specific workflow. Customize it to fit your team's needs:
1. Edit the workflow phases in SKILL.md
2. Add custom validation steps
3. Integrate with your CI/CD pipeline
4. Share improvements with your team

## Support

For help:
1. Check [SETUP-GUIDE.md](./SETUP-GUIDE.md)
2. Review the [SKILL.md](./SKILL.md) workflow
3. Ask Claude: "Help me with the Smartbear API workflow"

## License

Customize and use as needed for your organization.

---

**Ready to build APIs with confidence!** 🎉

Start by asking Claude: *"Build a REST API for [your use case]"*
