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

👉 **See [GETTING-STARTED.md](./GETTING-STARTED.md) for setup and sample prompts.**

---

## Setup (2 minutes)

1. Get your SwaggerHub API key: https://app.swaggerhub.com/settings/apiKey
2. Add to `~/.claude/settings.json`:
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
3. Restart Claude Code
4. Run: `List my Swagger organizations`

---

## Documentation

| Document | Purpose |
|----------|---------|
| **[GETTING-STARTED.md](./GETTING-STARTED.md)** | Setup, configuration, and sample prompts |
| **[SKILL.md](./SKILL.md)** | Complete skill definitions and workflows |
| **[CLAUDE.md](./CLAUDE.md)** | Claude Code-specific configuration |

---

## What's Included

- **4 Skills**: API generation, validation, portal management, and creation
- **24 MCP Tools**: Full SwaggerHub API lifecycle coverage
- **Multi-platform support**: Claude Code, GitHub Copilot, Cursor, Windsurf, Kiro, and more
- **Zero-config**: Pre-configured `.claude/skills/` ready to use

---

## License

MIT
