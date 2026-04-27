# Smartbear Swagger Skills for Claude Code

This repository contains Claude Code skills for the Smartbear Swagger/SwaggerHub MCP integration. Skills automate the full API lifecycle: generate, validate, publish, document, manage users, and configure integrations.

## Quick Setup (2 steps)

### 1. Edit `swagger-config.yml`

Open `swagger-config.yml` in the root of this repo and set the two required values:

```yaml
swaggerhub_api_key: "YOUR_API_KEY_HERE"   # from https://app.swaggerhub.com/settings/apiKey
mcp_server_name: "smartbear-joe"          # the name you gave the MCP in Claude Code settings
```

### 2. Configure the MCP Server in Claude Code

Edit `~/.claude/settings.json` (Windows: `C:\Users\YourName\.claude\settings.json`):

```json
{
  "mcpServers": {
    "smartbear-joe": {
      "command": "npx",
      "args": ["-y", "@smartbear/smartbear-mcp"],
      "env": {
        "SWAGGERHUB_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

> The `mcp_server_name` in `swagger-config.yml` must match the key you use here (`"smartbear-joe"` by default). If you name your MCP server something different, update both places.

Restart Claude Code, then verify with: `List my Swagger organizations`

---

## Skills Available

| Skill | File | Trigger |
|-------|------|---------|
| **Full API Workflow** | `.claude/skills/swagger-api.md` | "build/create/update API" |
| **Validate & Standardize** | `.claude/skills/swagger-validate.md` | "validate/scan/standardize spec" |
| **Portal Management** | `.claude/skills/swagger-portal.md` | "update/publish portal docs" |
| **Create from Prompt** | `.claude/skills/swagger-create.md` | "create new API in SwaggerHub" |
| **User Management** | `.claude/skills/swagger-users.md` | "invite/remove/list users or members" |
| **Domain Management** | `.claude/skills/swagger-domains.md` | "create/update/fork domain" |
| **Integration Management** | `.claude/skills/swagger-integrations.md` | "create/trigger/list integrations" |

## Quick Prompts

```
# Full end-to-end workflow
Build a REST API for managing customer orders

# Validate only
Validate my OpenAPI spec at specs/openapi.yaml against governance rules

# Create from description
Create a new API in SwaggerHub for a user authentication service with JWT

# Portal update
Update the portal documentation for the payments API and publish live

# Standardize existing API
Standardize the customer-orders API in SwaggerHub

# User management
List all members of my SwaggerHub organization
Invite alice@example.com to my org
Remove bob@example.com from the org
Give carol@example.com editor access on the payments-api

# Domain management
List all domains in my org
Create a new domain called common-schemas with Address and Money components
Fork the error-responses domain into a new version 2.0.0

# Integration management
List integrations on the orders-api version 1.0.0
Set up a GitHub sync integration for the payments-api
Trigger the GitHub sync integration on orders-api now
```

## Project Structure

```
.claude/
  skills/
    swagger-api.md       # Full lifecycle workflow
    swagger-validate.md  # Governance validation
    swagger-portal.md    # Portal documentation
    swagger-create.md    # Create new APIs
  settings.json          # Tool permissions
CLAUDE.md                # This file
SKILL.md                 # Legacy skill definition (VS Code format)
```

## Smartbear MCP Tools

All tools are prefixed `mcp__smartbear-joe__swagger_`:

- `list_organizations` — get your org names (required for most operations)
- `create_api_from_prompt` — generate an API spec from natural language
- `create_or_update_api` — publish spec to SwaggerHub registry
- `get_api_definition` — retrieve existing spec
- `search_apis_and_domains` — find APIs by name/description
- `scan_api_standardization` — validate against governance rules
- `standardize_api` — auto-fix governance violations
- `list_portals` / `get_portal` / `create_portal` / `update_portal`
- `list_portal_products` / `get_portal_product` / `create_portal_product` / `update_portal_product` / `delete_portal_product`
- `list_portal_product_sections` — get sections with optional ToC embed
- `publish_portal_product` — publish live or to preview
- `list_table_of_contents` / `create_table_of_contents` / `delete_table_of_contents`
- `get_document` / `update_document`

## Notes

- Organization names are **case-sensitive**
- SwaggerHub creates APIs at version `1.0.0` by default
- Portal changes require explicit `publish_portal_product` to go live
- Use `preview: true` when testing portal changes before publishing
- User management, domain, and integration skills call the SwaggerHub REST API directly via `curl` using `swaggerhub_api_key` from `swagger-config.yml`
- Available access control roles: `OWNER`, `EDITOR`, `VIEWER`
- Integration types include: `GITHUB_SYNC`, `GITLAB_PUSH`, `BITBUCKET_PUSH`, `AWS_API_GATEWAY_IMPORT`, `WEBHOOK`
