---
name: swagger-drift
description: Verifies API implementations against OpenAPI specifications from SwaggerHub using Drift contract testing. Fetches specs from SwaggerHub Studio via MCP, generates comprehensive Drift test cases, runs verification against live or mock APIs, and publishes results. USE FOR: create Drift tests, verify API against OpenAPI spec, test API contract, check for spec drift, validate API implementation, generate contract tests from SwaggerHub spec, run API conformance testing, publish verification results to PactFlow. DO NOT USE FOR: general API testing without OpenAPI specs, load testing, security penetration testing, or UI testing.
applyTo:
  - kind: file
    pattern: "**/*{drift,openapi,swagger,oas}.{yaml,json}"
  - kind: conversation
    pattern: "(drift|contract test|spec drift|verify|conformance|API.*spec|OpenAPI.*test)"
allowedTools:
  - read_file
  - replace_string_in_file
  - create_file
  - grep_search
  - file_search
  - semantic_search
  - list_dir
  - run_in_terminal
  - get_terminal_output
  - mcp_smartbear-mcp_swagger_*
  - tool_search
---

# Swagger Drift Testing Skill

You are an expert in API contract testing using Drift CLI with SwaggerHub integration. You help users fetch OpenAPI specifications from SwaggerHub Studio, generate comprehensive Drift test cases, run verification against APIs, and publish results.

## Reference Files

- [`references/drift-integration.md`](references/drift-integration.md) — Complete integration workflow: SwaggerHub → Drift → PactFlow → Portal
- [`references/mcp-tools.md`](references/mcp-tools.md) — All Smartbear MCP tools for SwaggerHub operations
- [`references/test-cases-quick.md`](references/test-cases-quick.md) — Quick reference for writing Drift test cases

For comprehensive Drift documentation, also reference:
- **Drift Skill** at `~/.agents/skills/drift-testing/SKILL.md` — Full Drift CLI expertise
- **OpenAPI Parser Skill** at `~/.agents/skills/openapi-parser/SKILL.md` — Complex schema parsing

## Quick Start

### 1. Fetch OpenAPI Spec from SwaggerHub

```javascript
// Get organization list first
const orgs = await mcp__smartbear-mcp__swagger_list_organizations();

// Fetch the spec
const spec = await mcp__smartbear-mcp__swagger_get_api_definition({
  owner: "your-org",  // Must match org name exactly (case-sensitive)
  apiName: "products-api",
  version: "1.0.0"
});

// Save locally
fs.writeFileSync("openapi.yaml", spec);
```

### 2. Generate Drift Tests

Use the **openapi-parser** skill to analyze complex schemas and generate tests:

```bash
# Parse the spec and generate test scaffolding
# The openapi-parser skill handles anyOf/oneOf/allOf/discriminators
# and outputs ready-to-use Drift YAML
```

Or manually create initial tests:

```yaml
# drift.yaml
drift-testcase-file: v1
title: "Products API Contract Tests"

sources:
  - name: api-spec
    path: ./openapi.yaml

plugins:
  - name: oas
  - name: json
  - name: data

global:
  auth:
    apply: true
    parameters:
      authentication:
        scheme: bearer
        token: ${env:API_TOKEN}

operations:
  getAllProducts_Success:
    target: api-spec:getAllProducts
    tags: [smoke, read-only]
    expected:
      response:
        statusCode: 200
  
  getProductById_Success:
    target: api-spec:getProductById
    tags: [smoke, read-only]
    parameters:
      path:
        id: 123
    expected:
      response:
        statusCode: 200
  
  getProductById_NotFound:
    target: api-spec:getProductById
    tags: [regression]
    parameters:
      path:
        id: 99999
    expected:
      response:
        statusCode: 404
```

### 3. Run Drift Verification

```bash
# Against live API
drift verify -u https://api.example.com/v1 -f drift.yaml

# Against local mock server (Prism)
npx @stoplight/prism-cli mock openapi.yaml -p 4010
drift verify -u http://localhost:4010 -f drift.yaml

# Re-run only failed tests
drift verify -u https://api.example.com/v1 -f drift.yaml --failed

# Run specific tags
drift verify -u https://api.example.com/v1 -f drift.yaml --tags smoke
```

### 4. Iterate and Fix

Drift provides detailed failure reports. Common issues:

| Error | Cause | Fix |
|-------|-------|-----|
| Schema validation error | API response doesn't match spec | **This is drift!** Fix API or update spec |
| Got 401, expected 200 | Missing authentication | Add `global.auth` block |
| Got 404, expected 200 | Test data doesn't exist | Use lifecycle hooks to create data |
| Value for parameter X missing | No `example` in spec | Add explicit value in test |

### 5. Publish Results (BDCT)

```bash
# Generate verification bundle
drift verify -u https://api.example.com/v1 -f drift.yaml --generate-result

# Publish to PactFlow via MCP or CLI
pactflow publish-provider-contract \
  --provider "products-api" \
  --provider-app-version "${GIT_COMMIT}" \
  --branch "${GIT_BRANCH}" \
  --content-type application/vnd.pact+json \
  --verification-results ./drift-results
```

## Complete Workflow

When a user asks to create Drift tests for a SwaggerHub API:

### Phase 1: Fetch and Validate

1. **List Organizations**: Use `mcp__smartbear-mcp__swagger_list_organizations()` to get exact org names
2. **Fetch Spec**: Use `mcp__smartbear-mcp__swagger_get_api_definition()` with org and API name
3. **Validate Governance**: Use `mcp__smartbear-mcp__swagger_scan_api_standardization()` to check for issues
4. **Auto-Fix** (if needed): Use `mcp__smartbear-mcp__swagger_standardize_api()` to resolve violations
5. **Save Locally**: Write the spec to `openapi.yaml` for Drift to reference

### Phase 2: Generate Tests

6. **Parse Spec**: If complex schemas exist (anyOf/oneOf/discriminators), invoke the **openapi-parser skill**:
   ```
   Use the openapi-parser skill to analyze this spec and generate Drift test cases covering all schema variants
   ```
7. **Create drift.yaml**: Generate comprehensive test configuration including:
   - Source reference to openapi.yaml
   - Required plugins (oas, json, data)
   - Global auth configuration
   - Operations covering all endpoints and response codes
8. **Create Datasets** (if needed): Separate test data into `*.dataset.yaml` files
9. **Create Lifecycle Hooks** (if needed): Lua file for stateful operations

### Phase 3: Run and Iterate

10. **Start Mock Server** (for local testing):
    ```powershell
    npx @stoplight/prism-cli mock openapi.yaml -p 4010
    ```
11. **Initial Run**: Execute `drift verify` against mock or live API
12. **Analyze Failures**: Categorize failures:
    - **Drift detected**: API doesn't match spec → fix API or update spec
    - **Test data issues**: Missing resources → add lifecycle hooks
    - **Auth issues**: 401 errors → configure global auth
    - **Schema bugs**: Invalid spec examples → report to SwaggerHub
13. **Fix and Re-run**: Use `drift verify --failed` to only re-run failures
14. **Check Coverage**: Verify all endpoints are tested using `check_coverage.py`

### Phase 4: Publish and Document

15. **Generate Results**: Run with `--generate-result` flag for PactFlow BDCT
16. **Publish to PactFlow**: Submit verification bundle
17. **Update Portal**: Use `mcp__smartbear-mcp__swagger_update_portal_product()` to document verification
18. **Commit Changes**: Version control drift tests with API code

## Key Principles

### 1. Never Modify the OpenAPI Spec During Testing

The spec is the contract. If Drift detects drift (schema validation errors), it means:
- The API implementation doesn't match its specification
- This is a **bug** that must be fixed

**Don't** change the spec to make tests pass. **Do** fix the API implementation.

### 2. Test Against the Spec, Not Implementation Details

Drift validates that the API conforms to its OpenAPI specification. Focus on:
- All documented endpoints
- All documented response codes
- Schema compliance
- Authentication patterns

### 3. Use Mock Servers for Development

Start with Prism mock server to:
- Develop tests without impacting live APIs
- Iterate quickly on test cases
- Catch spec bugs early (invalid examples, missing fields)

Then run against live API for real verification.

### 4. Organize Tests by Endpoint and Status Code

```yaml
operations:
  # GET /products
  getAllProducts_Success:        # 200
    target: api-spec:getAllProducts
    expected:
      response:
        statusCode: 200
  
  getAllProducts_Unauthorized:   # 401
    target: api-spec:getAllProducts
    exclude: [auth]
    expected:
      response:
        statusCode: 401
  
  # GET /products/{id}
  getProductById_Success:        # 200
    target: api-spec:getProductById
    parameters:
      path:
        id: 123
    expected:
      response:
        statusCode: 200
  
  getProductById_NotFound:       # 404
    target: api-spec:getProductById
    parameters:
      path:
        id: 99999
    expected:
      response:
        statusCode: 404
```

### 5. Tag for Flexible Test Execution

```yaml
tags: [smoke, regression, read-only, destructive, security]
```

Run subsets in CI:
- Smoke tests on every commit
- Regression tests nightly
- Destructive tests only in isolated environments

## Integration with Other Skills

- **swagger-api**: The OpenAPI spec that Drift tests is created by this skill
- **swagger-validate**: Ensures the spec passes governance before Drift testing
- **swagger-portal**: Documents the verification status after Drift succeeds
- **drift-testing**: Full Drift CLI expertise (auth, lifecycle hooks, expressions)
- **openapi-parser**: Parses complex schemas to generate comprehensive tests
- **pactflow**: Manages BDCT publishing and contract matrix

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

## Installation

```bash
# Drift CLI
npm install -g @pactflow/drift
# or use npx (no install needed)
npx @pactflow/drift --help

# Prism mock server
npm install -g @stoplight/prism-cli
# or use npx
npx @stoplight/prism-cli --help
```

## Example: Complete Session

```
User: "Create Drift tests for the products-api in SwaggerHub"

Agent:
1. Fetch organizations
2. Fetch products-api spec from SwaggerHub
3. Scan for governance issues
4. Save spec as openapi.yaml
5. Analyze spec (invoke openapi-parser if complex schemas)
6. Generate drift.yaml with comprehensive test coverage
7. Create api-data.dataset.yaml for test data
8. Create drift.lua for stateful operations
9. Provide commands to:
   - Start Prism mock server
   - Run initial drift verification
   - Iterate with --failed flag
   - Check coverage
10. After tests pass, publish to PactFlow and update portal
```

## Common Scenarios

### Scenario: API has complex polymorphic responses

**Detection**: OpenAPI spec contains `anyOf`, `oneOf`, `allOf`, or `discriminator`

**Action**: Invoke the **openapi-parser skill** to enumerate all schema variants and generate separate test cases for each.

### Scenario: Drift detects schema violations

**Detection**: `Schema validation error` in Drift output

**Meaning**: The API response doesn't match the OpenAPI spec

**Action**:
1. Compare actual response vs spec schema
2. Determine if API or spec is wrong
3. Fix the API (preferred) or update spec if API is correct
4. Re-run tests to verify fix

### Scenario: Stateful operations (DELETE, PATCH)

**Detection**: Endpoints that require existing resources

**Action**: Create lifecycle hooks in `drift.lua`:

```lua
["operation:started"] = function(event, data)
  if data.operation == "deleteProduct_Success" then
    -- Create product before test
    http({
      url = os.getenv("API_BASE_URL") .. "/products",
      method = "POST",
      body = { id = 123, name = "test", price = 9.99 }
    })
  end
end
```

### Scenario: Missing parameter examples in spec

**Detection**: `Value for query parameter X is missing`

**Action**: Add explicit values in test:

```yaml
parameters:
  query:
    version: "2024-01-04"
    format: "json"
  path:
    id: 123
```

## Success Criteria

A complete Drift verification includes:

✓ All endpoints covered (use `check_coverage.py` to verify)
✓ All documented response codes tested (200, 201, 400, 401, 403, 404, etc.)
✓ Zero schema validation errors (API matches spec)
✓ `drift verify` exits with code 0
✓ Results published to PactFlow (if using BDCT)
✓ Portal documentation updated with verification status
✓ Drift tests committed to version control

## Troubleshooting

See [`references/test-cases-quick.md`](references/test-cases-quick.md#common-issues) for common issues and fixes.

For comprehensive troubleshooting:
- Auth issues: Read `~/.agents/skills/drift-testing/references/auth.md`
- Mock server: Read `~/.agents/skills/drift-testing/references/mock-server.md`
- Lua hooks: Read `~/.agents/skills/drift-testing/references/lua-api.md`
- CLI flags: Read `~/.agents/skills/drift-testing/references/cli-reference.md`
