# Smartbear Swagger Skills for Claude Code

This repository contains Claude Code skills for the Smartbear Swagger/SwaggerHub MCP integration. Skills automate the full API lifecycle: generate, validate, publish, and document.

## Skills Available

| Skill | File | Trigger |
|-------|------|---------|
| **Full API Workflow** | `.claude/skills/swagger-api.md` | "build/create/update API" |
| **Validate & Standardize** | `.claude/skills/swagger-validate.md` | "validate/scan/standardize spec" |
| **Portal Management** | `.claude/skills/swagger-portal.md` | "update/publish portal docs" |
| **Create from Prompt** | `.claude/skills/swagger-create.md` | "create new API in SwaggerHub" |

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
```

## MCP Server Setup

The Smartbear MCP server must be running. Configure it in your Claude Code MCP settings:

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

Get your API key from [SwaggerHub Settings > API Key](https://app.swaggerhub.com/settings/apiKey).

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
