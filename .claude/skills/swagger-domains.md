---
description: "Manage SwaggerHub Domains: list, create, update, fork, publish, set visibility, and delete domains and their versions. USE FOR: domain, create domain, update domain, fork domain, publish domain, domain visibility. DO NOT USE FOR: APIs (use swagger-api), portals (use swagger-portal)."
applyTo:
  - kind: conversation
    pattern: "(list|create|update|fork|publish|delete|manage|set).*(domain|domains).*(swagger|swaggerhub)|(swagger|swaggerhub).*(domain|domains)"
allowedTools:
  - Read
  - Bash
  - mcp__smartbear-joe__swagger_list_organizations
---

# Manage SwaggerHub Domains

Domains are reusable component libraries (schemas, parameters, responses) shared across APIs.

## STEP 1: Load Config

Read `swagger-config.yml` to get:
- `swaggerhub_api_key` — used in all API calls as the `Authorization` header
- `mcp_server_name` — the MCP server name

Store these as `API_KEY` and `MCP_NAME`.

Base URL: `https://api.swaggerhub.com`

---

## STEP 2: Get Organization

Run `mcp__{MCP_NAME}__swagger_list_organizations` to get the user's org.

If multiple orgs, ask which one. Store as `ORG`.

---

## STEP 3: Determine the Task

Based on the user's request, go to the relevant section below.

---

## LIST DOMAINS

```bash
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/domains/$ORG"
```

Present as a table: **Domain Name | Latest Version | Visibility | Description**

---

## GET DOMAIN DEFINITION

Collect: domain name, version (default: latest)

```bash
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN/$VERSION"
```

Display the definition. Offer to save to a local file.

---

## CREATE OR UPDATE DOMAIN

Collect from user (ask if not provided):
- Domain name (kebab-case recommended)
- Version (default: 1.0.0)
- OpenAPI YAML/JSON definition, OR description of what the domain should contain

If the user provides a description, generate an appropriate OpenAPI components document containing the requested schemas, parameters, and/or responses.

```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/yaml" \
  --data-binary "@domain-spec.yaml" \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN?version=$VERSION&isPrivate=false"
```

Capture and report the SwaggerHub URL from the response.

---

## FORK DOMAIN

Collect from user:
- Source domain name and version
- New owner (org/user to fork into)
- New domain name (optional, defaults to source name)

```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN/$VERSION/fork?newOwner=$NEW_OWNER"
```

---

## CLONE DOMAIN VERSION

Creates a new version of an existing domain.

Collect: domain name, source version, new version number.

```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"version": "2.0.0"}' \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN/$VERSION/clone"
```

---

## SET DOMAIN VISIBILITY

Collect: domain name, version, desired visibility (public/private).

```bash
# Set private
curl -s -X PUT \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"private": true}' \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN/$VERSION/settings/private"
```

---

## PUBLISH DOMAIN (set lifecycle)

Collect: domain name, version, lifecycle status (`PUBLISHED` or `UNPUBLISHED`).

```bash
curl -s -X PUT \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"published": true}' \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN/$VERSION/settings/lifecycle"
```

---

## DELETE DOMAIN OR VERSION

**Always confirm with user before deleting.**

Delete a specific version:
```bash
curl -s -X DELETE \
  -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN/$VERSION"
```

Delete entire domain (all versions):
```bash
curl -s -X DELETE \
  -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN"
```

---

## RENAME DOMAIN

Collect: current domain name, new domain name.

```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"newName": "new-domain-name"}' \
  "https://api.swaggerhub.com/domains/$ORG/$DOMAIN/rename"
```

---

## Summary Output

When complete, provide:
1. Action taken and result
2. SwaggerHub URL if a domain was created/updated: `https://app.swaggerhub.com/domains/$ORG/$DOMAIN`
3. Next suggested actions (e.g. "Want to reference this domain in an API?")
