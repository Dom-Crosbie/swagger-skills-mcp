# API Development with Smartbear Swagger - Setup Guide

This guide will help you set up and use the custom Claude Code skill for API development with Smartbear Swagger integration.

## Prerequisites

### 1. Smartbear MCP Server Setup
Ensure you have the Smartbear MCP server running locally. You mentioned it's already running, but verify:
- MCP server is configured in your VS Code settings
- Authentication credentials are valid
- Connection is active

### 2. Required Accounts & Access
- **SwaggerHub Account**: Active account with API access
- **SwaggerHub Organization**: Member of at least one organization with appropriate permissions
- **GitHub Repository**: Repository configured for your API project
- **Swagger Portal** (optional): Portal setup in Swagger for documentation publishing

### 3. Tools & Software
- VS Code with Claude Code extension installed
- Git configured and authenticated
- Node.js, Python, or your preferred API development language/framework

## Installation Steps

### Step 1: Install the Skill File
The skill file has been created at:
```
c:\Users\dominick.crosbie\swaqgger-skills-mcp\SKILL.md
```

**To activate the skill in VS Code:**
1. Open VS Code Settings (Ctrl+,)
2. Search for "Custom Skills" or "Copilot Skills"
3. Add the path to your skill file, or
4. Place `SKILL.md` in your `.github` or `.vscode` directory in your workspace

### Step 2: Verify MCP Server Connection
Test that Smartbear tools are available:

1. Open Claude Code in VS Code
2. Type: "List my Swagger organizations"
3. Claude should use `mcp_smartbear-mcp_swagger_list_organizations` to retrieve them

If this fails, check your MCP server configuration.

### Step 3: Configure Your Environment
Create a configuration file for your project settings:

```yaml
# .swagger-config.yml
organization: "your-org-name"
portal:
  id: "your-portal-subdomain"
  defaultProduct: "your-product-slug"
github:
  remote: "origin"
  branch: "main"
api:
  defaultVersion: "1.0.0"
  specFormat: "openapi-3.1.0"
```

### Step 4: Initialize Your Project Structure
Recommended project structure:

```
your-api-project/
├── src/                    # API implementation code
│   ├── routes/
│   ├── controllers/
│   ├── models/
│   └── middleware/
├── specs/                  # OpenAPI specifications
│   └── openapi.yaml
├── tests/                  # API tests
│   ├── unit/
│   └── integration/
├── docs/                   # Additional documentation
│   └── guides/
├── .swagger-config.yml     # Swagger configuration
└── README.md
```

## Usage Examples

### Example 1: Create a New API

**Prompt to Claude:**
```
Build a new REST API for managing products with the following endpoints:
- GET /products - List all products
- GET /products/{id} - Get single product
- POST /products - Create new product
- PUT /products/{id} - Update product
- DELETE /products/{id} - Delete product

Include proper validation, error handling, and authentication.
```

**What happens:**
1. Claude generates the API code in your preferred language
2. Creates an OpenAPI 3.x specification
3. Scans the spec against your organization's governance rules
4. Fixes any standardization issues
5. Updates the code based on fixes
6. Uploads to SwaggerHub
7. Updates your Swagger Portal documentation
8. Commits and pushes to GitHub

### Example 2: Update an Existing API

**Prompt to Claude:**
```
Update the products API to add pagination support to the GET /products endpoint.
Add query parameters: page, pageSize, and sortBy.
```

**What happens:**
1. Claude modifies the existing API code
2. Updates the OpenAPI spec with new parameters
3. Validates against governance rules
4. Updates SwaggerHub registry
5. Updates portal documentation
6. Commits changes to GitHub

### Example 3: Validate Existing API

**Prompt to Claude:**
```
Scan my current OpenAPI spec (specs/openapi.yaml) for governance violations
and fix any issues found.
```

**What happens:**
1. Claude reads your OpenAPI spec
2. Scans it using `scan_api_standardization`
3. Reports all issues found
4. Either auto-fixes using `standardize_api` or manually corrects issues
5. Updates the spec file
6. Re-validates to confirm compliance

## Workflow Deep Dive

### Phase 1: Code Generation
When you ask to "build an API", Claude will:
- Ask clarifying questions if needed (authentication type, data models, etc.)
- Generate production-ready code with best practices
- Include error handling, validation, and logging
- Create corresponding OpenAPI specification

### Phase 2: Validation
The generated OpenAPI spec is validated:
- Scanned against your organization's governance rules
- Issues are identified (naming conventions, missing fields, security gaps)
- Auto-correction is attempted using Smartbear AI
- Manual fixes applied if needed

### Phase 3: Code Refinement
Based on validation feedback:
- API code is updated to match the corrected spec
- Additional improvements are made
- Code and spec are verified to be in sync

### Phase 4: SwaggerHub Publishing
- API is created or updated in SwaggerHub Registry
- You receive a SwaggerHub URL for the API
- API is immediately accessible in SwaggerHub UI

### Phase 5: Portal Documentation
- Portal product is identified or created
- Documentation sections are updated
- API reference is linked from portal
- Changes are published live (or to preview)

### Phase 6: GitHub
- All changes (code, spec, docs) are committed
- Pushed to your GitHub repository
- Commit message includes SwaggerHub URL for traceability

## Configuration Tips

### Organization Names
Get your organization name:
```
@workspace List my Swagger organizations
```

Keep this name handy - it's required for validation.

### Portal Setup
List your available portals:
```
@workspace Show my Swagger portals
```

If you don't have a portal, you can skip Phase 5 or create one first.

### Git Configuration
Ensure your repository is initialized:
```powershell
git init
git remote add origin https://github.com/your-username/your-repo.git
git checkout -b main
```

## Troubleshooting

### Issue: "MCP tools not found"
**Solution**: Run this first in Claude:
```
Load the Smartbear MCP tools
```
Claude will use `tool_search_tool_regex` to load them.

### Issue: "Organization not found"
**Solution**: Verify the organization name is exact (case-sensitive):
```
@workspace What are my organizations in Swagger?
```

### Issue: "Portal product not found"
**Solution**: List products to get the correct identifier:
```
@workspace List products in portal [portal-subdomain]
```

### Issue: "Validation fails with many errors"
**Solution**: This is expected for first-time validation. Claude will auto-fix most issues or apply manual corrections. Re-run validation after fixes.

### Issue: "Git push rejected"
**Solution**: Check if you need to pull first:
```powershell
git pull origin main --rebase
git push origin main
```

## Advanced Usage

### Custom Validation Rules
Ask Claude to validate specific aspects:
```
Check if my API spec follows REST best practices for:
- Proper HTTP methods
- Resource naming conventions
- Error response structure
```

### Incremental Updates
Update just one part of the workflow:
```
Update the portal documentation for the products API without changing the code
```

### Multiple Environments
Maintain separate specs for different environments:
```
specs/
├── openapi.yaml          # Main spec
├── openapi.dev.yaml      # Development overrides
└── openapi.prod.yaml     # Production overrides
```

### Batch Operations
Process multiple APIs:
```
Validate and standardize all OpenAPI specs in the specs/ directory
```

## Best Practices

### 1. Version Control
- Always commit specs alongside code
- Use semantic versioning for specs
- Tag releases in Git

### 2. Documentation
- Keep portal documentation up-to-date with code changes
- Include examples in OpenAPI specs
- Document breaking changes prominently

### 3. Validation
- Validate early and often
- Fix governance issues before review
- Set up pre-commit hooks for validation

### 4. Security
- Always define authentication schemes in specs
- Validate input parameters thoroughly
- Document security requirements

### 5. Testing
- Generate tests from OpenAPI specs
- Validate responses against schema
- Test error conditions

## Integration with CI/CD

Consider setting up automated workflows:

```yaml
# .github/workflows/api-validation.yml
name: Validate API Spec
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate OpenAPI Spec
        run: |
          # Use Smartbear CLI or API to validate
          # Fail build if validation errors found
```

## Getting Help

### In VS Code
Simply ask Claude:
```
Help me understand the API development workflow with Smartbear
```

### Check Skill Status
```
What skills are currently active?
```

### View Available Tools
```
What Smartbear tools are available?
```

## Next Steps

1. **Try the examples** above to familiarize yourself with the workflow
2. **Create your first API** using the skill
3. **Customize** the skill file for your team's specific needs
4. **Share** this setup with your team
5. **Iterate** - the skill will learn from your patterns

## Resources

- [SwaggerHub Documentation](https://support.smartbear.com/swaggerhub/)
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [MCP Server Documentation](https://modelcontextprotocol.io/)
- [VS Code Claude Extension](https://marketplace.visualstudio.com/items?itemName=claudeai)

---

**Happy API Building!** 🚀

For questions or issues with this skill, consult the SKILL.md file or ask Claude directly in VS Code.
