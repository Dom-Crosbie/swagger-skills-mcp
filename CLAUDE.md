# SwaggerHub Skills — Claude Code Context

## Configuration

Read `swagger-config.yml` at the start of any skill that needs credentials or the MCP server name:
- `swaggerhub_api_key` — used as the `Authorization` header for direct REST API calls
- `mcp_server_name` — the MCP server name (default: `smartbear-joe`); MCP tool prefix is `mcp__{mcp_server_name}__swagger_`

## Skills

| Skill | File | Trigger |
|-------|------|---------|
| Full API Workflow | `.claude/skills/swagger-api.md` | "build/create API service/store/system" |
| Validate & Standardize | `.claude/skills/swagger-validate.md` | "validate/scan/standardize spec or API" |
| Portal Management | `.claude/skills/swagger-portal.md` | "update/publish portal docs" |
| Create from Prompt | `.claude/skills/swagger-create.md` | "create new API in SwaggerHub" |
| User Management | `.claude/skills/swagger-users.md` | "invite/remove/list users or members" |
| Domain Management | `.claude/skills/swagger-domains.md` | "create/update/fork domain" |
| Integration Management | `.claude/skills/swagger-integrations.md` | "create/trigger/list integrations" |

## MCP Tools (prefix: `mcp__smartbear-joe__swagger_`)

- `list_organizations` — get org names (required for most operations)
- `create_api_from_prompt` — generate spec from natural language
- `create_or_update_api` — publish spec to SwaggerHub registry
- `get_api_definition` — retrieve existing spec
- `search_apis_and_domains` — find APIs or domains by keyword
- `scan_api_standardization` — validate against governance rules
- `standardize_api` — auto-fix governance violations
- `list_portals` / `get_portal` / `create_portal` / `update_portal`
- `list_portal_products` / `get_portal_product` / `create_portal_product` / `update_portal_product` / `delete_portal_product`
- `list_portal_product_sections` — get sections with optional ToC embed
- `publish_portal_product` — publish live (`preview: false`) or staging (`preview: true`)
- `list_table_of_contents` / `create_table_of_contents` / `delete_table_of_contents`
- `get_document` / `update_document`

## Key Rules

- Organization names are case-sensitive — always get them from `list_organizations`
- SwaggerHub creates APIs at version `1.0.0` by default
- Portal changes require explicit `publish_portal_product` to go live
- User management, domain, and integration skills call `https://api.swaggerhub.com` directly via `curl` using `swaggerhub_api_key`
- Available access control roles: `OWNER`, `EDITOR`, `VIEWER`
