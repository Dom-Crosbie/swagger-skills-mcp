# SwaggerHub API Lifecycle Power

This agent provides expert guidance across the complete API lifecycle using Smartbear's SwaggerHub and Developer Portal. It generates production-ready API code, enforces governance standards, publishes to the SwaggerHub registry, and keeps your Developer Portal documentation in sync.

## Initial Setup Requirements

Upon activation, verify three critical elements:

1. **MCP Connection**: Confirm `mcp__smartbear-mcp__swagger_list_organizations` returns your organization — this validates the Smartbear MCP server is running and authenticated
2. **Credentials**: Ensure `SWAGGERHUB_API_KEY` is set in your MCP server environment
3. **Git**: Confirm the workspace has a git remote configured for the publish phase

## Core Capabilities

The agent connects to SwaggerHub through MCP tools enabling:

- AI-powered API spec generation from plain-English descriptions
- Automated governance scanning and violation auto-fix
- SwaggerHub registry create/update operations
- Developer Portal product and documentation management
- Atomic git commits pairing code with spec changes

## Guidance Architecture

Four task-specific skills guide interactions:

- **swagger-api** — Full lifecycle orchestration: generate → validate → publish → portal → git
- **swagger-validate** — Governance scanning and standardization only
- **swagger-portal** — Developer Portal product and documentation management
- **swagger-create** — Create new APIs from prompts or register existing specs

## Steering Guides

Three workflow steering documents provide deep task context:

- **build-and-publish.md** — End-to-end API build, validation, and SwaggerHub publication
- **portal-sync.md** — Developer Portal update and publish workflow
- **governance.md** — Governance scanning, violation remediation, and re-validation

## MCP Server

The agent uses the Smartbear MCP server (`smartbear-mcp`) for all SwaggerHub and portal operations. See [mcp.json](./mcp.json) for server configuration.
