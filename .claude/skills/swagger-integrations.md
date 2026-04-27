---
description: "Manage SwaggerHub API integrations: list, create, update, delete, and trigger integrations on specific API versions (e.g. GitHub sync, AWS Gateway, CI/CD hooks). USE FOR: integration, sync, webhook, trigger integration, configure integration. DO NOT USE FOR: portal docs, governance, user management."
applyTo:
  - kind: conversation
    pattern: "(list|create|add|update|delete|remove|run|trigger|execute|manage|configure).*(integration|webhook|sync).*(swagger|swaggerhub|api)|(swagger|swaggerhub).*(integration|webhook|sync)"
allowedTools:
  - Read
  - Bash
  - mcp__smartbear-joe__swagger_*
---

# Manage SwaggerHub Integrations

Integrations connect a SwaggerHub API version to external systems (GitHub, GitLab, AWS API Gateway, Bitbucket, CI/CD pipelines, webhooks, and more).

## STEP 1: Load Config

Read `swagger-config.yml` to get:
- `swaggerhub_api_key` — used in all API calls as the `Authorization` header
- `mcp_server_name` — the MCP server name

Store these as `API_KEY` and `MCP_NAME`.

Base URL: `https://api.swaggerhub.com`

---

## STEP 2: Get Organization & API

Run `mcp__{MCP_NAME}__swagger_list_organizations` to get the user's org. Store as `ORG`.

Ask the user which API the integration applies to, OR search for it:

```bash
# List APIs in org to help user select
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/apis/$ORG?limit=20"
```

Collect: `API_NAME`, `VERSION` (default: latest/1.0.0).

---

## STEP 3: Determine the Task

Based on the user's request, go to the relevant section below.

---

## LIST INTEGRATIONS

```bash
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations"
```

Present as a table: **Integration ID | Name | Type | Enabled | Last Run**

If no integrations exist, offer to create one.

---

## GET INTEGRATION DETAILS

Collect: integration ID (from the list above).

```bash
curl -s -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations/$INTEGRATION_ID"
```

Display all configuration details.

---

## CREATE INTEGRATION

Ask the user what type of integration they want. Common types:

| Type | Description |
|------|-------------|
| `API_AUTO_MOCKING` | VirtServer AutoMocking — generate a mock server from the spec |
| `GITHUB` | Push spec to a GitHub repo on save |
| `GITLAB` | Push spec to GitLab on save |
| `BITBUCKET_CLOUD` | Push spec to Bitbucket Cloud on save |
| `BITBUCKET_SERVER` | Push spec to Bitbucket Server on save |
| `AMAZON_API_GATEWAY` | Sync to AWS API Gateway |
| `AMAZON_API_GATEWAY_LAMBDA` | Sync to AWS API Gateway with Lambda |
| `APIGEE_EDGE` | Sync to Apigee Edge |
| `AZURE_API_MANAGEMENT` | Sync to Azure API Management |
| `AZURE_DEVOPS_SERVICES` | Sync to Azure DevOps Services |
| `WEBHOOK` | Send HTTP POST to a URL on API events |
| `AMAZON_API_GATEWAY` | Deploy to Amazon API Gateway |

Collect configuration based on type (ask user for required values).

**Example — GitHub sync:**
```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "GitHub Sync",
    "configType": "GITHUB",
    "enabled": true,
    "config": {
      "owner": "github-org",
      "repository": "repo-name",
      "branch": "main",
      "syncMethod": "Basic Sync",
      "token": "github-personal-access-token",
      "outputFolder": "specs",
      "outputFile": "openapi.yaml"
    }
  }' \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations"
```

**Example — Webhook:**
```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Webhook",
    "configType": "WEBHOOK",
    "enabled": true,
    "config": {
      "url": "https://your-endpoint.example.com/webhook",
      "secret": "optional-secret"
    }
  }' \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations"
```

Capture and report the integration ID from the response.

---

## UPDATE INTEGRATION

Collect: integration ID, fields to change.

```bash
curl -s -X PUT \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{ "enabled": true, "config": { ... } }' \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations/$INTEGRATION_ID"
```

To enable or disable only:
```bash
curl -s -X PATCH \
  -H "Authorization: $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"enabled": false}' \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations/$INTEGRATION_ID"
```

---

## RUN / TRIGGER INTEGRATION

Manually execute an integration (useful for testing or on-demand sync).

Collect: integration ID.

```bash
curl -s -X POST \
  -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations/$INTEGRATION_ID/execute"
```

Report the execution result and any output.

---

## DELETE INTEGRATION

**Confirm with user before deleting.**

```bash
curl -s -X DELETE \
  -H "Authorization: $API_KEY" \
  "https://api.swaggerhub.com/apis/$ORG/$API/$VERSION/integrations/$INTEGRATION_ID"
```

---

## Summary Output

When complete, provide:
1. Action taken and result
2. Integration ID (for create/update)
3. Integration status (enabled/disabled, last run)
4. Next suggested actions (e.g. "Want to trigger the integration now to test it?")
