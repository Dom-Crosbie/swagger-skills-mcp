# SwaggerHub Agent Skills

**SwaggerHub Agent Skills** equip AI coding assistants (Claude Code, GitHub Copilot, Cursor, Windsurf, Kiro, and more) with deep knowledge of the Smartbear SwaggerHub API lifecycle — from generating and validating OpenAPI specs to publishing to the SwaggerHub registry, syncing your Developer Portal, managing users, configuring integrations, and working with shared domains.

---

## Skills

| Skill | Purpose |
|-------|---------|
| **swagger-api** | Full end-to-end lifecycle: learn org patterns → generate → validate → publish → portal → git |
| **swagger-validate** | Scan any OpenAPI spec against governance rules and auto-fix violations |
| **swagger-portal** | Manage Developer Portal products, documentation, table of contents, and publishing |
| **swagger-create** | Create a new API in SwaggerHub from a natural language prompt or existing spec file |
| **swagger-users** | Invite, remove, and list org members; manage per-resource access control roles |
| **swagger-domains** | List, create, fork, publish, and delete shared component domains |
| **swagger-integrations** | List, create, trigger, and delete API integrations (GitHub sync, webhooks, AWS Gateway, and more) |

---

## Setup

### 1. Get your SwaggerHub API key

Go to [SwaggerHub Settings → API Key](https://app.swaggerhub.com/settings/apiKey) and copy your key.

### 2. Register the SmartBear MCP server in Claude Code

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

> **Important — MCP server name:** The key `"smartbear-joe"` is the name every skill uses to call MCP tools. Keep it as-is unless you have a specific reason to rename it. If you use a different name, run the rename command in the [Custom MCP server name](#custom-mcp-server-name) section below.

### 3. Configure `swagger-config.yml`

Set your values from the command line (run from the repo root):

**Bash / Git Bash / WSL:**
```bash
sed -i 's/YOUR_API_KEY_HERE/your-actual-api-key/' swagger-config.yml
```

**PowerShell:**
```powershell
(Get-Content swagger-config.yml) -replace 'YOUR_API_KEY_HERE', 'your-actual-api-key' | Set-Content swagger-config.yml
```

The `mcp_server_name` defaults to `smartbear-joe` and does not need to be changed unless you renamed the MCP server above.

### 4. Restart Claude Code

Close and reopen your editor. Verify with:
```
List my Swagger organizations
```

---

## Quick Prompts

```
# Full end-to-end API build
Build a REST API for managing customer orders

# Validate a local spec
Validate my OpenAPI spec at specs/openapi.yaml against governance rules

# Create from a description
Create a new API in SwaggerHub for a user authentication service with JWT

# Portal docs
Update the portal documentation for the payments API and publish live

# User management
List all members of my SwaggerHub organization
Invite alice@example.com to my org
Give carol@example.com editor access on the payments-api

# Domains
Create a domain called common-schemas with Address and Money component schemas
Fork the error-responses domain into version 2.0.0

# Integrations
List integrations on the orders-api
Set up a GitHub sync integration for the payments-api to push the spec on save
Trigger the GitHub sync integration on orders-api now
```

---

## Custom MCP server name

If you named your MCP server something other than `smartbear-joe`, run this one-liner from the repo root to update every skill file and settings in one shot:

**Bash:**
```bash
OLD=smartbear-joe; NEW=your-server-name
find .claude -name "*.md" -o -name "*.json" | xargs sed -i "s/mcp__${OLD}__/mcp__${NEW}__/g"
sed -i "s/mcp_server_name: \"${OLD}\"/mcp_server_name: \"${NEW}\"/" swagger-config.yml
```

**PowerShell:**
```powershell
$old = "smartbear-joe"; $new = "your-server-name"
Get-ChildItem .claude -Recurse -Include "*.md","*.json" | ForEach-Object {
  (Get-Content $_.FullName) -replace "mcp__$old`__", "mcp__$new`__" | Set-Content $_.FullName
}
(Get-Content swagger-config.yml) -replace "mcp_server_name: `"$old`"", "mcp_server_name: `"$new`"" | Set-Content swagger-config.yml
```

---

## How it works

Skills are Markdown files in `.claude/skills/`. Claude Code auto-detects them based on trigger patterns in the file's YAML frontmatter and executes the step-by-step workflow in the file body. MCP tools are called directly from the workflow using the tool name prefix `mcp__{server-name}__swagger_*`.

The three user/domain/integration skills make direct `curl` calls to the SwaggerHub REST APIs using the API key from `swagger-config.yml`. The four original skills use MCP tools exclusively.

---

## License

MIT
