# Quick Reference - Smartbear API Skill

## Common Commands

### 🚀 Build New API
```
Build a REST API for [use case] with [specific requirements]
```

### 🔄 Update Existing API
```
Update the [API name] to add [feature or endpoint]
```

### ✅ Validate Spec Only
```
Validate my OpenAPI spec at [path] against governance rules
```

### 📚 Update Documentation
```
Update the portal documentation for [API name]
```

### 🔍 Check Status
```
What's the status of [API name] in SwaggerHub?
```

### 📋 List Resources
```
List my Swagger organizations
Show my Swagger portals
List products in portal [portal-id]
```

## Workflow Phases

| Phase | What Happens | Tools Used |
|-------|-------------|------------|
| 1. Code Gen | API implementation + OpenAPI spec | `create_file`, language tools |
| 2. Validate | Check governance compliance | `scan_api_standardization` |
| 3. Fix | Auto-correct violations | `standardize_api` |
| 4. Upload | Publish to SwaggerHub | `create_or_update_api` |
| 5. Portal | Update documentation | `publish_portal_product` |
| 6. Git | Commit and push | `run_in_terminal` (git) |

## Key MCP Tools

### Validation
- `mcp_smartbear-joe_swagger_scan_api_standardization` - Check governance
- `mcp_smartbear-joe_swagger_standardize_api` - Auto-fix issues

### Registry
- `mcp_smartbear-joe_swagger_create_or_update_api` - Publish API
- `mcp_smartbear-joe_swagger_get_api_definition` - Get existing spec
- `mcp_smartbear-joe_swagger_search_apis_and_domains` - Search APIs

### Portal
- `mcp_smartbear-joe_swagger_list_portals` - List portals
- `mcp_smartbear-joe_swagger_list_portal_products` - List products
- `mcp_smartbear-joe_swagger_publish_portal_product` - Publish docs

### Organization
- `mcp_smartbear-joe_swagger_list_organizations` - Get orgs

## File Locations

```
your-project/
├── src/                    # API code
├── specs/                  # OpenAPI specs
│   └── openapi.yaml
├── tests/                  # Tests
├── .swagger-config.yml     # Config (copy from .example)
└── .vscode/               # VS Code settings
    └── SKILL.md           # Place skill here
```

## Configuration

Edit `.swagger-config.yml`:
```yaml
organization: "your-org"
portal:
  id: "your-portal"
  defaultProduct: "your-product"
github:
  remote: "origin"
  branch: "main"
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| MCP tools not found | Ask: "Load Smartbear MCP tools" |
| Org not found | Verify name (case-sensitive) |
| Portal not found | List portals first |
| Validation errors | Normal! Claude will auto-fix |
| Git push fails | Check remote & credentials |

## Tips

### ✅ DO
- Validate early and often
- Commit specs with code
- Use semantic versioning
- Include examples in specs
- Test before publishing

### ❌ DON'T
- Skip validation
- Commit code without spec
- Manually edit generated code without updating spec
- Publish without testing
- Forget to pull before push

## Quick Setup

1. **Install**: Place `SKILL.md` in `.vscode/` folder
2. **Configure**: Copy `.swagger-config.example.yml` to `.swagger-config.yml`
3. **Verify MCP**: Ask Claude "List my Swagger organizations"
4. **Test**: Ask Claude "Build a simple health check API"

## Keyboard Shortcuts (in VS Code)

- `Ctrl+I` - Open Claude inline chat
- `Ctrl+Shift+I` - Open Claude side panel
- `Ctrl+L` - New conversation with Claude

## Example Prompts

### Basic
```
Build a simple API with GET /health endpoint
```

### Intermediate
```
Create a RESTful API for blog posts with:
- CRUD operations
- Pagination
- Search functionality
- JWT authentication
```

### Advanced
```
Build a microservice API for payment processing with:
- Idempotency support
- Webhook notifications
- Retry logic with exponential backoff
- Comprehensive error handling
- OpenAPI spec with detailed examples
```

## Resource Links

- 📖 [Full Setup Guide](./SETUP-GUIDE.md)
- 🎯 [Skill Definition](./SKILL.md)
- 🏠 [README](./README.md)
- 🔧 [Config Example](./.swagger-config.example.yml)

## Getting Help

Ask Claude directly:
```
Help me understand the Smartbear API workflow
Show me examples of API prompts
What Smartbear tools are available?
Debug my OpenAPI spec validation errors
```

---

**Pro Tip**: Start simple! Build a basic API first to learn the workflow, then tackle complex projects.
