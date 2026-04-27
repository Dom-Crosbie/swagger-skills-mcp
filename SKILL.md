---
name: swagger-skills-mcp
description: End-to-end API lifecycle management with Smartbear SwaggerHub. Covers API generation, governance validation, portal documentation, user management, shared domains, and integration configuration.
---

# SwaggerHub Agent Skills

AI-powered API lifecycle management for SwaggerHub. Seven skills covering the full API surface: generate, validate, publish, document, manage users, manage domains, and configure integrations.

---

## Configuration

Before using any skill, ensure `swagger-config.yml` in the repo root is populated:

```yaml
swaggerhub_api_key: "your-api-key-here"   # https://app.swaggerhub.com/settings/apiKey
mcp_server_name: "smartbear-joe"          # must match the key in ~/.claude/settings.json
```

Set it from the command line (run from repo root):

**Bash:**
```bash
sed -i 's/YOUR_API_KEY_HERE/your-actual-key/' swagger-config.yml
```

**PowerShell:**
```powershell
(Get-Content swagger-config.yml) -replace 'YOUR_API_KEY_HERE', 'your-actual-key' | Set-Content swagger-config.yml
```

MCP server registration in `~/.claude/settings.json`:

```json
{
  "mcpServers": {
    "smartbear-joe": {
      "command": "npx",
      "args": ["-y", "@smartbear/smartbear-mcp"],
      "env": { "SWAGGERHUB_API_KEY": "your-api-key-here" }
    }
  }
}
```

> **Using a different MCP server name?** Run this one-liner to update every skill file at once:
>
> ```bash
> OLD=smartbear-joe; NEW=your-server-name
> find .claude -name "*.md" -o -name "*.json" | xargs sed -i "s/mcp__${OLD}__/mcp__${NEW}__/g"
> sed -i "s/mcp_server_name: \"${OLD}\"/mcp_server_name: \"${NEW}\"/" swagger-config.yml
> ```

---

## Skills

### 1. swagger-api — Full API Lifecycle

**Trigger:** "build/create API service/store/system"
**File:** `.claude/skills/swagger-api.md`

End-to-end workflow: learns from existing org APIs → generates spec and code → validates until zero governance errors → publishes to SwaggerHub → creates portal documentation.

**Phases:**

**Phase 1 — Learn from Org**
- `swagger_list_organizations` → get org name
- `swagger_search_apis_and_domains` → find 3–5 similar APIs
- `swagger_get_api_definition` → download and analyze each: naming conventions, response structure, auth scheme, endpoint patterns

**Phase 2 — Generate**
- Generate API code matching org patterns
- Generate OpenAPI 3.1 spec using exact same naming, structure, and auth as similar APIs
- Include descriptions, tags, and examples on every operation

**Phase 3 — Validate (loop until zero errors)**
- `swagger_scan_api_standardization` → collect all errors
- Fix each error by matching the pattern from similar org APIs
- Re-scan → repeat until zero critical errors
- `swagger_standardize_api` after publish for auto-fix pass

**Phase 4 — Publish**
- `swagger_create_or_update_api` → upload validated spec
- Capture SwaggerHub URL

**Phase 5 — Portal Documentation**
- `swagger_list_portals` → find or create relevant portal
- `swagger_create_portal_product` if no matching product
- Create four documentation sections:
  - **API Reference** (`apiUrl` entry → SwaggerHub spec URL)
  - **Getting Started** (setup, auth guide, first request)
  - **Usage Examples** (cURL for every endpoint)
  - **Error Handling** (status codes, error response examples)
- `swagger_publish_portal_product` with `preview: false` (live)

**Required checklist before reporting complete:**
- Similar APIs found and analyzed
- Spec generated with org patterns
- Zero governance errors confirmed
- API published to SwaggerHub with URL
- Four portal sections created
- Portal published live

---

### 2. swagger-validate — Governance Validation

**Trigger:** "validate/scan/standardize spec or API"
**File:** `.claude/skills/swagger-validate.md`

Scans an OpenAPI spec against org governance rules, reports violations, and auto-fixes where possible.

**Workflow:**
1. Locate spec (from path, or search for `openapi.yaml` / `openapi.json`)
2. `swagger_list_organizations` → get org
3. `swagger_scan_api_standardization` → report all errors and warnings
4. `swagger_standardize_api` → auto-fix (always run)
5. Re-scan → loop until zero critical errors

**Common violations and fixes:**

| Violation | Fix |
|-----------|-----|
| `sps-unknown-error-format` | Add RFC 7807 schema to every error response |
| `sps-no-collection-paging-capability` | Wrap arrays: `{ data: [...], paging: { total, limit, offset } }` |
| `sps-missing-pagination-query-parameters` | Add `limit` and `offset` to collection GETs |
| `owasp:api4:2019-string-limit` | Add `maxLength` to all string properties |
| Missing `description` | Add to every operation, parameter, and schema |
| Missing `operationId` | Add unique ID to each operation |
| Missing security | Add security scheme and apply to all endpoints |

---

### 3. swagger-portal — Portal Documentation

**Trigger:** "update/publish portal docs"
**File:** `.claude/skills/swagger-portal.md`

Manages Developer Portal products, documentation pages, table of contents, and publishing.

**Key operations:**
- `swagger_list_portals` + `swagger_list_portal_products` → locate target
- `swagger_create_portal_product` → new product with name, slug, description
- `swagger_list_portal_product_sections` (embed: `['tableOfContents']`) → get current structure
- `swagger_create_table_of_contents` → add entry (types: `apiUrl`, `document`, `externalUrl`, `group`)
- `swagger_update_document` → write Markdown/HTML content
- `swagger_publish_portal_product` → `preview: false` for live, `preview: true` for staging

**Table of contents entry types:**

| Type | Use | Required fields |
|------|-----|----------------|
| `apiUrl` | Link to SwaggerHub spec | `url` (SwaggerHub API URL) |
| `document` | Inline Markdown/HTML page | content via `update_document` |
| `externalUrl` | External link | `url` |
| `group` | Folder/section | `title`, child entries |

> Portal changes are not live until `publish_portal_product` is called explicitly.

---

### 4. swagger-create — Create from Prompt

**Trigger:** "create new API in SwaggerHub"
**File:** `.claude/skills/swagger-create.md`

Creates a new SwaggerHub API from a natural language description or registers an existing spec file.

**Option A — Natural language:**
1. `swagger_list_organizations` → get org
2. `swagger_create_api_from_prompt` (org, prompt, apiName)
3. Show generated spec for confirmation
4. `swagger_scan_api_standardization` → validate
5. `swagger_create_or_update_api` → publish

**Option B — Existing spec file:**
1. Read spec from file path
2. `swagger_list_organizations`
3. `swagger_search_apis_and_domains` → check for duplicates
4. `swagger_scan_api_standardization` → validate
5. `swagger_create_or_update_api` → register

---

### 5. swagger-users — User Management

**Trigger:** "invite/remove/list users or members"
**File:** `.claude/skills/swagger-users.md`

Manages org members and per-resource access control via the SwaggerHub User Management REST API (`https://api.swaggerhub.com/user-management/v1`). Reads `swaggerhub_api_key` from `swagger-config.yml`.

**Operations:**

| Task | Endpoint |
|------|----------|
| List members | `GET /orgs/{owner}/members` |
| Invite by email | `POST /orgs/{owner}/members` `{ "emails": ["..."] }` |
| Remove member | `DELETE /orgs/{owner}/members?user=email` |
| Get user roles | `GET /orgs/{owner}/roles?user=email` |
| List resource access (users) | `GET /orgs/{owner}/resources/{name}/resource-type/{type}/users` |
| Assign role | `POST` same path `{ "users": [{ "name": "...", "role": "EDITOR" }] }` |
| Update role | `PATCH` same path |
| Remove access | `DELETE` same path |

Available roles: `OWNER`, `EDITOR`, `VIEWER`

> Always confirm with user before removing a member or revoking access.

---

### 6. swagger-domains — Domain Management

**Trigger:** "create/update/fork domain"
**File:** `.claude/skills/swagger-domains.md`

Manages reusable SwaggerHub domains (shared schemas, parameters, responses) via the Registry REST API (`https://api.swaggerhub.com`). Reads `swaggerhub_api_key` from `swagger-config.yml`.

**Operations:**

| Task | Endpoint |
|------|----------|
| List domains | `GET /domains/{owner}` |
| Get definition | `GET /domains/{owner}/{domain}/{version}` |
| Create / update | `POST /domains/{owner}/{domain}?version=1.0.0` |
| Fork | `POST /domains/{owner}/{domain}/{version}/fork` |
| Clone version | `POST /domains/{owner}/{domain}/{version}/clone` |
| Set visibility | `PUT /domains/{owner}/{domain}/{version}/settings/private` |
| Set lifecycle | `PUT /domains/{owner}/{domain}/{version}/settings/lifecycle` |
| Rename | `POST /domains/{owner}/{domain}/rename` |
| Delete version | `DELETE /domains/{owner}/{domain}/{version}` |
| Delete all | `DELETE /domains/{owner}/{domain}` |

> Always confirm with user before deleting.

---

### 7. swagger-integrations — Integration Management

**Trigger:** "create/trigger/list integrations"
**File:** `.claude/skills/swagger-integrations.md`

Manages integrations on specific API versions via the Registry REST API. Reads `swaggerhub_api_key` from `swagger-config.yml`.

**Operations:**

| Task | Endpoint |
|------|----------|
| List integrations | `GET /apis/{owner}/{api}/{version}/integrations` |
| Get details | `GET /apis/{owner}/{api}/{version}/integrations/{id}` |
| Create | `POST /apis/{owner}/{api}/{version}/integrations` |
| Update | `PUT` same path |
| Enable/disable | `PATCH` same path `{ "enabled": true/false }` |
| Trigger/execute | `POST /apis/{owner}/{api}/{version}/integrations/{id}/execute` |
| Delete | `DELETE /apis/{owner}/{api}/{version}/integrations/{id}` |

**Common integration types:**

| Type | Description |
|------|-------------|
| `GITHUB_SYNC` | Push spec to a GitHub repo on save |
| `GITLAB_PUSH` | Push spec to GitLab on save |
| `BITBUCKET_PUSH` | Push spec to Bitbucket on save |
| `AWS_API_GATEWAY_IMPORT` | Sync to AWS API Gateway |
| `WEBHOOK` | HTTP POST to a URL on API events |

> Always confirm with user before deleting an integration.

---

## MCP Tools Reference

All tools use prefix `mcp__smartbear-joe__swagger_` (replace `smartbear-joe` with your MCP server name if different).

| Tool | Purpose |
|------|---------|
| `list_organizations` | Get org names — required for most operations |
| `create_api_from_prompt` | Generate spec from natural language |
| `create_or_update_api` | Publish spec to SwaggerHub registry |
| `get_api_definition` | Retrieve existing spec |
| `search_apis_and_domains` | Find APIs or domains by keyword |
| `scan_api_standardization` | Validate against governance rules |
| `standardize_api` | Auto-fix governance violations |
| `list_portals` / `get_portal` / `create_portal` / `update_portal` | Portal CRUD |
| `list_portal_products` / `get_portal_product` / `create_portal_product` / `update_portal_product` / `delete_portal_product` | Product CRUD |
| `list_portal_product_sections` | Get sections with optional ToC embed |
| `publish_portal_product` | Publish live or to staging |
| `list_table_of_contents` / `create_table_of_contents` / `delete_table_of_contents` | ToC management |
| `get_document` / `update_document` | Documentation content |

---

## Error Handling

**Validation loop stuck** — same error after 3 fixes:
- Apply the manual fix from the violations table
- Ask user: "Which existing API should I match exactly?"

**Portal not found** — create a new product with a descriptive name and slug matching the domain.

**API already exists** — `create_or_update_api` is idempotent, safe to re-run.

**curl returns 401** — `swaggerhub_api_key` in `swagger-config.yml` is missing or incorrect.

**MCP tools not found** — verify MCP server is running and the server name in `swagger-config.yml` matches `~/.claude/settings.json`.
