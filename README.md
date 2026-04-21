# SwaggerHub Agent Skills

**SwaggerHub Agent Skills** equip AI coding assistants (Claude Code, GitHub Copilot, Cursor, Windsurf, Kiro, and more) with deep knowledge of the Smartbear SwaggerHub API lifecycle — from generating and validating OpenAPI specs to publishing to the SwaggerHub registry and syncing your Developer Portal.

The plugin bundles the Smartbear MCP server alongside skills, enabling direct connections to SwaggerHub. Assistants can scan governance rules, auto-fix violations, publish API specs, manage portal products, and push to GitHub — without leaving the editor.

---

## Skills Overview

| Plugin | Skill | Purpose |
|--------|-------|---------|
| swagger-hub | **swagger-api** | Full end-to-end lifecycle: generate code → validate → publish to SwaggerHub → sync portal → push to git |
| swagger-hub | **swagger-validate** | Scan any OpenAPI spec against organization governance rules and fix violations |
| swagger-hub | **swagger-portal** | Manage Developer Portal products, documentation, table of contents, and publishing |
| swagger-hub | **swagger-create** | Create a new API in SwaggerHub from a natural language prompt or existing spec file |

---

## Quick Start

**Ask your AI assistant:**

```
Build a REST API for managing customer orders with CRUD operations and JWT auth
```

```
Validate my OpenAPI spec at specs/openapi.yaml against governance rules
```

```
Update the portal documentation for the payments API and publish live
```

```
Create a new API in SwaggerHub for a user authentication service
```

---

## Installation

### Claude Code

**Project-level install (recommended):**
```bash
mkdir -p .claude/skills
cp -r plugins/swagger-hub/skills/* .claude/skills/
```

Commit `.claude/skills/` to share with your team. Claude Code auto-discovers skills in this directory.

**Or clone this repo and open it directly** — the `.claude/skills/` directory is already configured.

Configure the MCP server in `~/.claude/settings.json`:
```json
{
  "mcpServers": {
    "smartbear-mcp": {
      "command": "npx",
      "args": ["-y", "@smartbear/smartbear-mcp"],
      "env": {
        "SWAGGERHUB_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### GitHub Copilot (VS Code)

**Project-level install:**
```bash
mkdir -p .github/skills
cp -r plugins/swagger-hub/skills/* .github/skills/
```

Commit to share team-wide. Copilot auto-discovers skills in `.github/skills/`.

### Cursor

**Manual project install:**
```bash
mkdir -p .cursor/skills
cp -r plugins/swagger-hub/skills/* .cursor/skills/
```

Or add via **Settings → Rules → Add Rule (GitHub):**
- `https://github.com/Dom-Crosbie/swaqgger-skills-mcp/tree/main/plugins/swagger-hub/skills/swagger-api`
- `https://github.com/Dom-Crosbie/swaqgger-skills-mcp/tree/main/plugins/swagger-hub/skills/swagger-validate`

### Windsurf

```bash
mkdir -p .windsurf/skills
cp -r plugins/swagger-hub/skills/* .windsurf/skills/
```

Or use the Cascade panel: **⋯ menu → Skills → + Workspace**

### Kiro

Import the Power from GitHub via the **Agent Steering & Skills** panel, or manual install:
```bash
mkdir -p .kiro/skills
cp -r plugins/swagger-hub/skills/* .kiro/skills/
```

Set environment variables before activating:
- `SWAGGERHUB_API_KEY`

### Antigravity / Other Agents

```bash
mkdir -p .agents/skills
cp -r plugins/swagger-hub/skills/* .agents/skills/
```

---

## Credential Configuration

Get your SwaggerHub API key from [SwaggerHub → Settings → API Key](https://app.swaggerhub.com/settings/apiKey).

Set it as an environment variable or in your MCP server config:
```bash
export SWAGGERHUB_API_KEY=your-api-key-here
```

The MCP server config is in [`powers/swagger-hub/mcp.json`](./powers/swagger-hub/mcp.json).

---

## Windows (PowerShell) Syntax

Replace Unix commands with PowerShell equivalents:
```powershell
# mkdir -p .claude/skills
New-Item -ItemType Directory -Force -Path .claude\skills

# cp -r plugins/swagger-hub/skills/* .claude/skills/
Copy-Item -Recurse plugins\swagger-hub\skills\* .claude\skills\
```

---

## Repository Structure

```
swagger-hub-agent-skills/
├── plugins/
│   └── swagger-hub/
│       └── skills/
│           ├── swagger-api/SKILL.md      # Full lifecycle workflow
│           ├── swagger-validate/SKILL.md # Governance validation
│           ├── swagger-portal/SKILL.md   # Portal management
│           └── swagger-create/SKILL.md  # Create from prompt/file
│
├── powers/
│   └── swagger-hub/
│       ├── POWER.md                      # Kiro Power definition
│       ├── mcp.json                      # MCP server configuration
│       └── steering/
│           ├── build-and-publish.md      # Build & publish workflow
│           ├── portal-sync.md            # Portal sync workflow
│           └── governance.md             # Governance remediation
│
├── .claude/
│   ├── skills/                           # Claude Code skill definitions
│   │   ├── swagger-api.md
│   │   ├── swagger-validate.md
│   │   ├── swagger-portal.md
│   │   └── swagger-create.md
│   └── settings.json                     # Pre-approved MCP tool permissions
│
├── .agents/plugins/marketplace.json      # Agent marketplace discovery
├── CLAUDE.md                             # Claude Code project instructions
└── README.md
```

---

## MCP Tools Reference

All tools are provided by the `smartbear-mcp` MCP server, prefixed `mcp__smartbear-mcp__swagger_`:

| Tool | Purpose |
|------|---------|
| `list_organizations` | Get organization names (required for most operations) |
| `create_api_from_prompt` | Generate OpenAPI spec from natural language |
| `create_or_update_api` | Publish spec to SwaggerHub registry |
| `get_api_definition` | Retrieve existing spec |
| `search_apis_and_domains` | Find APIs by name or description |
| `scan_api_standardization` | Validate spec against governance rules |
| `standardize_api` | Auto-fix governance violations |
| `list_portals` / `get_portal` | Discover portals |
| `list_portal_products` / `create_portal_product` | Manage portal products |
| `list_portal_product_sections` | Get sections with table of contents |
| `publish_portal_product` | Publish live or to preview |
| `create_table_of_contents` | Add API reference or doc section |
| `get_document` / `update_document` | Read/write documentation content |

Full tool list: 24 tools covering the complete SwaggerHub and portal API.

---

## License

MIT
