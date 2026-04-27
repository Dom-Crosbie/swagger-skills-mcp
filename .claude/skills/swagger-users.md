---
description: "Manage SwaggerHub organization users: list members, invite by email, remove members, and manage access control roles on APIs or domains. USE FOR: add user, invite user, remove user, list members, user roles, access control. DO NOT USE FOR: API creation, portal docs, governance."
applyTo:
  - kind: conversation
    pattern: "(invite|add|remove|list|manage).*(user|member|role|access).*(swagger|swaggerhub|org|organization)"
allowedTools:
  - Read
  - Bash
  - mcp__smartbear-joe__swagger_list_organizations
---

# Manage SwaggerHub Users

## STEP 1: Load Config

Read `swagger-config.yml` to get:
- `swaggerhub_api_key` — used in all API calls as the `Authorization` header
- `mcp_server_name` — the MCP server name (e.g. `smartbear-joe`)

Store these as `API_KEY` and `MCP_NAME` for use in every step.

Base URL for all calls: `https://api.swaggerhub.com/user-management/v1`

---

## STEP 2: Get Organization

Run `mcp__{MCP_NAME}__swagger_list_organizations` to get the user's org name.

If the user has multiple orgs, ask which one to use.

Store as `ORG`.

---

## STEP 3: Determine the Task

Based on the user's request, go to the relevant section below.

---

## LIST MEMBERS

```bash
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/user-management/v1/orgs/$ORG/members"
```

Present results as a table: **Username | Email | Role | Last Active**

---

## INVITE USER

Collect from user (ask if not provided):
- Email address(es) to invite

```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"emails": ["user@example.com"]}' \
  "https://api.swaggerhub.com/user-management/v1/orgs/$ORG/members"
```

Confirm success and list who was invited.

---

## REMOVE MEMBER

Collect from user (ask if not provided):
- Email address(es) to remove

**Confirm before removing** — ask user: "Remove [email] from [ORG]? This cannot be undone."

```bash
curl -s -X DELETE \
  -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/user-management/v1/orgs/$ORG/members?user=user@example.com"
```

---

## GET USER ROLES

```bash
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/user-management/v1/orgs/$ORG/roles?user=user@example.com"
```

---

## MANAGE ACCESS CONTROL (assign/update/remove roles on a specific API or domain)

Collect from user (ask if not provided):
- Resource name (API or domain name)
- Resource type (API or DOMAIN)
- User email(s)
- Role to assign (if adding/updating)

**List current access:**
```bash
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/user-management/v1/orgs/$ORG/resources/$RESOURCE/resource-type/$TYPE/users"
```

**Assign role:**
```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"users": [{"name": "username", "role": "EDITOR"}]}' \
  "https://api.swaggerhub.com/user-management/v1/orgs/$ORG/resources/$RESOURCE/resource-type/$TYPE/users"
```

Available roles: `OWNER`, `EDITOR`, `VIEWER`

**Update role:**
Use `PATCH` with the same body.

**Remove access:**
Use `DELETE` with `?user=username` query param.

---

## MANAGE TEAM ACCESS CONTROL

Same as user access control but use `/teams` instead of `/users` and supply team names.

---

## Summary Output

When complete, provide:
1. Action taken and result
2. Current member list or access state (if relevant)
3. Next suggested actions (e.g. "Want to set their role on a specific API?")
