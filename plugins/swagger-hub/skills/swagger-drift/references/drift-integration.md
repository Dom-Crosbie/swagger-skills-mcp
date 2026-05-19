# Drift Integration with SwaggerHub

This document describes how Drift contract testing integrates with SwaggerHub Studio and the Smartbear MCP server.

## Overview

The swagger-drift skill combines:
- **SwaggerHub Studio** — the source of your OpenAPI specifications
- **Drift CLI** — PactFlow's contract testing tool that verifies API implementations against OpenAPI specs
- **Smartbear MCP Server** — provides programmatic access to SwaggerHub APIs

## Workflow

```
┌──────────────┐     1. Fetch OpenAPI Spec      ┌──────────────┐
│  SwaggerHub  │◄─────────────────────────────────│ MCP Server   │
│   Studio     │                                  │ (smartbear)  │
└──────────────┘                                  └──────────────┘
       │                                                  ▲
       │ 2. Generate                                     │
       │    Drift Tests                                  │ 6. Publish
       │                                                  │    Results
       ▼                                                  │
┌──────────────┐                                  ┌──────────────┐
│ Drift Tests  │     3. Run Verification    ────►│  PactFlow    │
│  (YAML)      │                                  │  Workspace   │
└──────────────┘                                  └──────────────┘
       │
       │ 4. Test Against
       ▼
┌──────────────┐
│ API Instance │
│ (Live/Mock)  │
└──────────────┘
```

## Step-by-Step Integration

### 1. Fetch OpenAPI Spec from SwaggerHub

Use the Smartbear MCP server to retrieve your API specification:

```javascript
// The MCP tool retrieves the spec
mcp__smartbear-mcp__swagger_get_api_definition({
  owner: "your-org",
  apiName: "your-api",
  version: "1.0.0"
})
```

Save the spec locally as `openapi.yaml` for Drift to reference.

### 2. Generate Drift Test Cases

Use the **openapi-parser** skill to analyze the spec and generate comprehensive Drift test cases:

- Parse complex schemas (anyOf, oneOf, allOf, discriminators)
- Generate tests for each endpoint and response code
- Create datasets for test data
- Add lifecycle hooks for stateful operations

Output: `drift.yaml` with complete test coverage

### 3. Run Drift Verification

Execute Drift against your API:

```bash
# Against live API
drift verify -u https://api.example.com/v1 -f drift.yaml

# Against mock server (Prism)
npx @stoplight/prism-cli mock openapi.yaml -p 4010
drift verify -u http://localhost:4010 -f drift.yaml
```

### 4. Fix and Iterate

Use the feedback loop pattern:
- Run tests → identify failures → fix implementation or test data → re-run
- Use `--failed` flag to only re-run previously failed tests
- Use `check_coverage.py` script to verify all endpoints are covered

### 5. Publish Results to PactFlow (BDCT)

Generate verification results and publish to PactFlow for Bi-Directional Contract Testing:

```bash
# Generate verification results
drift verify -u https://api.example.com/v1 -f drift.yaml --generate-result

# Publish to PactFlow (via MCP or CLI)
pactflow publish-provider-contract \
  --provider "your-api" \
  --provider-app-version "${GIT_COMMIT}" \
  --branch "${GIT_BRANCH}" \
  --content-type application/vnd.pact+json \
  --verification-results ./drift-results \
  --verification-results-content-type application/vnd.pactflow.verification-results+json
```

### 6. Update SwaggerHub Registry

After successful verification, update the API in SwaggerHub:

```javascript
mcp__smartbear-mcp__swagger_create_or_update_api({
  owner: "your-org",
  apiName: "your-api",
  definition: updatedSpecString
})
```

### 7. Sync Portal Documentation

Update the Developer Portal with the verified API:

```javascript
mcp__smartbear-mcp__swagger_update_portal_product({
  portalId: "portal-uuid",
  productId: "product-uuid",
  description: "Updated API with Drift verification ✓"
})
```

## Required Tools

### Drift CLI

```bash
# Install globally
npm install -g @pactflow/drift

# Or use npx (no install)
npx @pactflow/drift --help
```

### Prism Mock Server (for local testing)

```bash
# Install globally
npm install -g @stoplight/prism-cli

# Or use npx
npx @stoplight/prism-cli mock openapi.yaml -p 4010
```

### Smartbear MCP Server

Configured in your MCP settings with SwaggerHub API key:

```json
{
  "mcpServers": {
    "smartbear-mcp": {
      "command": "npx",
      "args": ["-y", "@smartbear/smartbear-mcp"],
      "env": {
        "SWAGGERHUB_API_KEY": "${SWAGGERHUB_API_KEY}",
        "PACTFLOW_BASE_URL": "${PACTFLOW_BASE_URL}",
        "PACTFLOW_TOKEN": "${PACTFLOW_TOKEN}"
      }
    }
  }
}
```

## Environment Variables

```bash
# SwaggerHub
export SWAGGERHUB_API_KEY="your-swaggerhub-api-key"

# PactFlow (for BDCT)
export PACTFLOW_BASE_URL="https://your-org.pactflow.io"
export PACTFLOW_TOKEN="your-pactflow-api-token"

# API under test
export API_BASE_URL="https://api.example.com/v1"
export API_TOKEN="your-api-test-token"
```

## File Structure

```
project/
├── openapi.yaml                 # Fetched from SwaggerHub
├── drift/
│   ├── drift.yaml               # Main test configuration
│   ├── drift.lua                # Lifecycle hooks
│   ├── datasets/
│   │   └── api-data.dataset.yaml
│   └── tests/
│       ├── products.tests.yaml
│       ├── users.tests.yaml
│       └── orders.tests.yaml
└── drift-results/               # Generated by --generate-result
    └── verification-bundle.json
```

## Best Practices

1. **Version Control**: Commit drift tests alongside your API code
2. **CI Integration**: Run Drift in your CI pipeline before deployment
3. **Mock Server First**: Develop tests against Prism mock before live API
4. **Governance Validation**: Run SwaggerHub standardization before Drift tests
5. **Tag Organization**: Use tags (smoke, regression, destructive) for test management
6. **Dataset Management**: Keep test data separate in dataset files
7. **Lifecycle Hooks**: Use Lua hooks for stateful operations (create before delete)
8. **Full Coverage**: Use `check_coverage.py` to verify all endpoints are tested

## Troubleshooting

### "No such file or directory: openapi.yaml"

Fetch the spec from SwaggerHub first using `mcp__smartbear-mcp__swagger_get_api_definition`.

### "Connection refused" when testing

Check that your API or mock server is running:
```bash
# For mock server
npx @stoplight/prism-cli mock openapi.yaml -p 4010

# Check it's running
curl http://localhost:4010/health
```

### "Got 401, expected 200"

Add authentication configuration to `drift.yaml`:
```yaml
global:
  auth:
    apply: true
    parameters:
      authentication:
        scheme: bearer
        token: ${env:API_TOKEN}
```

### "Schema validation error"

The API response doesn't match the OpenAPI spec. This is **drift detection** — the API has deviated from its specification. Either:
- Fix the API implementation to match the spec
- Update the spec if the API behavior is correct
- Use `ignore: { schema: true }` only for intentional 4xx tests

### "Value for query parameter X is missing"

The parameter lacks an `example` in the OpenAPI spec. Add it explicitly in the test:
```yaml
parameters:
  query:
    version: "2024-01-04"
    format: "json"
```

## Integration with Other Skills

- **swagger-api**: Generates the OpenAPI spec that Drift tests against
- **swagger-validate**: Ensures the spec follows governance rules before testing
- **swagger-portal**: Documents the verified API in the Developer Portal
- **openapi-parser**: Parses complex specs to generate Drift tests
- **pactflow**: Manages the full contract testing lifecycle with BDCT
