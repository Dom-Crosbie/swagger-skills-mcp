# Drift Contract Testing Workflow

This steering guide provides detailed context for the swagger-drift skill when performing API contract testing with Drift CLI and SwaggerHub integration.

## Workflow Purpose

Verify API implementations against their OpenAPI specifications using Drift contract testing, with specs sourced from SwaggerHub Studio and results published to PactFlow for Bi-Directional Contract Testing (BDCT).

## Task Identification

Invoke this workflow when the user:
- Wants to "create Drift tests"
- Asks to "verify API against spec"
- Mentions "contract testing", "spec drift", or "API conformance"
- Requests "test coverage for all endpoints"
- Says "check if API matches the OpenAPI spec"

## Prerequisites Checklist

Before starting, verify:

1. **MCP Connection**
   ```javascript
   const orgs = await mcp__smartbear-mcp__swagger_list_organizations();
   if (!orgs || orgs.length === 0) {
     throw new Error("MCP server not connected. Check SWAGGERHUB_API_KEY.");
   }
   ```

2. **Environment Variables**
   ```bash
   SWAGGERHUB_API_KEY=xxx    # For fetching specs
   API_TOKEN=xxx             # For API authentication during tests
   API_BASE_URL=xxx          # Base URL of API under test
   PACTFLOW_BASE_URL=xxx     # Optional: for BDCT publishing
   PACTFLOW_TOKEN=xxx        # Optional: for BDCT publishing
   ```

3. **Drift CLI Available**
   ```bash
   npx @pactflow/drift --version
   ```

4. **Git Repository** (for committing tests)
   ```bash
   git status
   ```

## Phase 1: Fetch OpenAPI Specification

### Step 1.1: Get Organization List

```javascript
const orgs = await mcp__smartbear-mcp__swagger_list_organizations();
console.log("Available organizations:", orgs);
```

**Critical**: Organization names are case-sensitive. Always use the exact name from this list.

### Step 1.2: Search for API (if name unknown)

```javascript
const results = await mcp__smartbear-mcp__swagger_search_apis_and_domains({
  query: "products",
  owner: "acme-corp",
  state: "published"
});
```

### Step 1.3: Fetch API Definition

```javascript
const spec = await mcp__smartbear-mcp__swagger_get_api_definition({
  owner: "acme-corp",  // Exact org name from step 1.1
  apiName: "products-api",
  version: "1.0.0"
});

// Save locally
fs.writeFileSync("openapi.yaml", spec);
```

### Step 1.4: Validate Governance

```javascript
const issues = await mcp__smartbear-mcp__swagger_scan_api_standardization({
  owner: "acme-corp",
  definition: spec,
  isYaml: true
});

if (issues.length > 0) {
  console.log("Governance issues found:", issues);
  
  // Auto-fix if API already exists in SwaggerHub
  const fixedSpec = await mcp__smartbear-mcp__swagger_standardize_api({
    owner: "acme-corp",
    apiName: "products-api"
  });
  
  fs.writeFileSync("openapi.yaml", fixedSpec);
}
```

## Phase 2: Analyze Spec and Generate Tests

### Step 2.1: Parse Spec Structure

Read `openapi.yaml` and identify:
- Number of paths
- Operations per path
- Request parameters (path, query, header)
- Request body schemas
- Response codes per operation
- Response schemas

### Step 2.2: Detect Complex Schemas

Scan for:
- `anyOf` / `oneOf` / `allOf` — polymorphic types
- `discriminator` — tagged unions
- `$ref` chains — nested references
- `pattern` — regex constraints
- Optional fields clusters

**If complex schemas found**, invoke the **openapi-parser skill**:

```
Analyze this OpenAPI spec and generate Drift test cases covering all schema variants for the following endpoints:
- GET /products
- POST /products
- GET /products/{id}
- DELETE /products/{id}

Pay special attention to the ProductResponse schema which uses oneOf with a discriminator.
```

### Step 2.3: Generate drift.yaml

Create comprehensive test configuration:

```yaml
# drift.yaml
drift-testcase-file: v1
title: "Products API Contract Tests"

sources:
  - name: api-spec
    path: ./openapi.yaml
  - name: test-data
    path: ./api-data.dataset.yaml
  - name: hooks
    path: ./drift.lua

plugins:
  - name: oas           # OpenAPI validation
  - name: json          # JSON parsing
  - name: data          # Dataset support
  - name: http-dump     # HTTP traffic logging (optional, for debugging)
  - name: junit-output  # JUnit XML for CI (optional)

global:
  auth:
    apply: true
    parameters:
      authentication:
        scheme: bearer
        token: ${env:API_TOKEN}

operations:
  # Generate one operation block per endpoint + status code combination
  # See Phase 2.4 for naming conventions
```

### Step 2.4: Generate Operations

For each endpoint, create test cases for all documented response codes:

**Naming Convention**: `{operationId}_{outcome}` or `{operationId}_{variant}_{outcome}`

Examples:
- `getAllProducts_Success` (200)
- `getAllProducts_Unauthorized` (401)
- `getProductById_Success` (200)
- `getProductById_NotFound` (404)
- `getProductById_byId` (for anyOf: integer)
- `getProductById_bySlug` (for anyOf: string)
- `createProduct_Success` (201)
- `createProduct_InvalidData` (400)
- `deleteProduct_Success` (204)
- `deleteProduct_Forbidden` (403)

**Template**:

```yaml
operationName:
  target: api-spec:operationId
  tags: [category, type, ...]
  dataset: test-data  # If using datasets
  parameters:
    path:
      id: ${test-data:products.existing.id}
    query:
      format: json
    headers:
      x-custom: value
    request:
      body: ${test-data:products.new}
  expected:
    response:
      statusCode: 200
      # body matcher (optional - spec validation is automatic)
```

### Step 2.5: Create Dataset File (if needed)

```yaml
# api-data.dataset.yaml
drift-dataset-file: V1
datasets:
  - name: test-data
    data:
      products:
        existing:
          id: 123
          name: "Test Product"
          slug: "test-product"
          price: 19.99
        new:
          name: "New Product"
          price: 29.99
        forbidden:
          id: 456  # For 403 tests
      users:
        existing:
          id: "user-uuid-123"
          email: "test@example.com"
```

### Step 2.6: Create Lifecycle Hooks (if stateful operations)

```lua
-- drift.lua
local server_url = os.getenv("API_BASE_URL")
local token = os.getenv("API_TOKEN")

local function create_product(id, name, price)
  return http({
    url = server_url .. "/products",
    method = "POST",
    headers = { authorization = "Bearer " .. token },
    body = { id = id, name = name, price = price }
  })
end

local function delete_product(id)
  return http({
    url = server_url .. "/products/" .. id,
    method = "DELETE",
    headers = { authorization = "Bearer " .. token }
  })
end

local exports = {
  -- Before operation runs
  ["operation:started"] = function(event, data)
    if data.operation == "deleteProduct_Success" then
      create_product(123, "temp-product", 9.99)
    end
    
    if data.operation == "updateProduct_Success" then
      create_product(456, "update-target", 15.99)
    end
  end,
  
  -- After operation completes
  ["operation:finished"] = function(event, data)
    if data.operation == "createProduct_Success" then
      local product_id = data.response.body.id
      delete_product(product_id)
    end
  end,
  
  -- Exported functions for expressions
  exported_functions = {
    generate_uuid = function()
      return os.execute("uuidgen")  -- Platform-specific
    end,
    
    readonly_token = function()
      return os.getenv("READONLY_API_TOKEN")
    end
  }
}

return exports
```

## Phase 3: Run and Iterate

### Step 3.1: Start Mock Server (for local testing)

```powershell
# Start Prism mock server
npx @stoplight/prism-cli mock openapi.yaml -p 4010

# In another terminal, verify it's running
curl http://localhost:4010/products
```

### Step 3.2: Initial Run

```bash
# Against mock server
drift verify -u http://localhost:4010 -f drift.yaml

# Or against live API
drift verify -u https://api.example.com/v1 -f drift.yaml
```

### Step 3.3: Analyze Failures

Categorize each failure:

| Error Pattern | Category | Action |
|---------------|----------|--------|
| Schema validation error | **Drift detected** | Fix API or update spec |
| Got 404, expected 200 | Missing test data | Add lifecycle hook to create resource |
| Got 401, expected 200 | Auth missing | Add/fix `global.auth` |
| Got 200, expected 401 | Auth not stripped | Add `exclude: [auth]` + bad token |
| Value for parameter X missing | No spec example | Add explicit value in test |
| Connection refused | Server not running | Start mock/API server |
| Got 400, expected 200 | Invalid request | Check request body matches schema |

### Step 3.4: Fix and Re-run

```bash
# Only re-run failed tests
drift verify -u http://localhost:4010 -f drift.yaml --failed

# Run specific operation during debugging
drift verify -u http://localhost:4010 -f drift.yaml --operation getProductById_Success

# Run by tags
drift verify -u http://localhost:4010 -f drift.yaml --tags smoke
```

### Step 3.5: Check Coverage

```bash
# Download check_coverage.py script
curl -O https://raw.githubusercontent.com/pactflow/pactflow-agent-skills/main/plugins/swagger-contract-testing/skills/drift-testing/scripts/check_coverage.py

# Run coverage check
uv run check_coverage.py --spec openapi.yaml --test-files drift.yaml

# Exit code 0 = full coverage
# Exit code 1 = gaps remain
```

Output shows:
- Operations with no tests
- Operations missing specific response codes
- Overall coverage percentage

### Step 3.6: Iterate Until Success

**Goal**: `drift verify` exits with code 0 AND `check_coverage.py` exits with code 0

Use this loop:

```bash
# 1. Run failed tests
drift verify -u http://localhost:4010 -f drift.yaml --failed

# 2. If all pass, check coverage
uv run check_coverage.py --spec openapi.yaml --test-files drift.yaml

# 3. If gaps found, add missing tests and go to step 1
```

Or use the automated loop script:

```powershell
# Download loop script
curl -O https://raw.githubusercontent.com/pactflow/pactflow-agent-skills/main/plugins/swagger-contract-testing/skills/drift-testing/scripts/run_loop.ps1

# Run until both gates pass
.\run_loop.ps1 --spec openapi.yaml --test-files drift.yaml --server-url http://localhost:4010
```

## Phase 4: Publish and Document

### Step 4.1: Generate Verification Results

```bash
# Generate PactFlow verification bundle
drift verify -u https://api.example.com/v1 -f drift.yaml --generate-result
```

Output: `./drift-results/verification-bundle.json`

### Step 4.2: Publish to PactFlow (BDCT)

```bash
# Install PactFlow CLI if not available
npm install -g @pactflow/cli

# Publish verification results
pactflow publish-provider-contract \
  --provider "products-api" \
  --provider-app-version "${GIT_COMMIT}" \
  --branch "${GIT_BRANCH}" \
  --content-type application/vnd.pact+json \
  --content-file openapi.yaml \
  --verification-results ./drift-results \
  --verification-results-content-type application/vnd.pactflow.verification-results+json \
  --verification-exit-code $?
```

### Step 4.3: Update SwaggerHub (if spec changed)

```javascript
// Only if spec was updated during testing
const updatedSpec = fs.readFileSync("openapi.yaml", "utf8");

await mcp__smartbear-mcp__swagger_create_or_update_api({
  owner: "acme-corp",
  apiName: "products-api",
  definition: updatedSpec
});
```

### Step 4.4: Update Portal Documentation

```javascript
// Get portal and product IDs
const portals = await mcp__smartbear-mcp__swagger_list_portals();
const products = await mcp__smartbear-mcp__swagger_list_portal_products({
  portalId: portals[0].id
});

// Find the products-api product
const product = products.find(p => p.name === "Products API");

// Update with verification status
await mcp__smartbear-mcp__swagger_update_portal_product({
  portalId: portals[0].id,
  productId: product.id,
  description: `Products API - Drift Verified ✓

Last verified: ${new Date().toISOString()}
Coverage: 100% endpoints (42/42)
All tests passed: ✓
`
});

// Publish to live
await mcp__smartbear-mcp__swagger_publish_portal_product({
  portalId: portals[0].id,
  productId: product.id,
  preview: false
});
```

### Step 4.5: Commit to Git

```bash
git add drift.yaml api-data.dataset.yaml drift.lua openapi.yaml
git commit -m "Add Drift contract tests - 100% endpoint coverage

- Fetched spec from SwaggerHub (acme-corp/products-api/1.0.0)
- Generated 42 test cases covering all endpoints and response codes
- All tests passing against live API
- Published verification results to PactFlow
- Updated Developer Portal documentation
"
git push origin main
```

## Success Criteria

A complete Drift verification workflow includes:

✅ OpenAPI spec fetched from SwaggerHub
✅ Spec passes governance validation
✅ Comprehensive drift.yaml generated
✅ All endpoints have test coverage
✅ All documented response codes tested
✅ `drift verify` exits with code 0
✅ `check_coverage.py` exits with code 0
✅ No schema validation errors (zero drift)
✅ Results published to PactFlow (if BDCT enabled)
✅ Portal documentation updated
✅ Tests committed to version control

## Optimization Tips

1. **Use Mock Server First**: Develop tests against Prism to catch spec bugs early
2. **Parallelize by Suite**: Split tests into multiple files and run in parallel
3. **Tag Strategically**: Use tags to run subsets (smoke vs regression)
4. **Cache Test Data**: Use lifecycle hooks to create data once, not per-operation
5. **Fail Fast**: Use `--failed` flag to only re-run broken tests
6. **Automate Coverage**: Run `check_coverage.py` in CI to enforce 100% coverage

## Common Pitfalls

❌ **Modifying the spec to make tests pass** — The spec is the contract; fix the API instead
❌ **Ignoring schema validation errors** — These are drift detections, not test bugs
❌ **Testing implementation details** — Test conformance to spec, not specific field values
❌ **Skipping lifecycle hooks** — Stateful operations need data setup
❌ **Hardcoding auth tokens** — Use environment variables
❌ **Not version controlling tests** — Drift tests are part of the codebase

## Handoffs to Other Skills

- **swagger-api**: User wants to update API implementation after finding drift
- **swagger-validate**: User wants standalone governance check before Drift
- **swagger-portal**: User wants to update docs without running tests
- **openapi-parser**: Complex schemas need detailed parsing
- **pactflow**: User wants full BDCT workflow including consumer tests
