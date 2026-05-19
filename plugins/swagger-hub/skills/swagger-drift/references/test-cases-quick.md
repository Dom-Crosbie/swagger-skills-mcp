# Drift Test Cases Quick Reference

This is a condensed reference for writing Drift test cases in the SwaggerHub context. For full details, see the original [test-cases.md](https://raw.githubusercontent.com/pactflow/pactflow-agent-skills/main/plugins/swagger-contract-testing/skills/drift-testing/references/test-cases.md) from PactFlow.

## Minimal Test Structure

```yaml
# drift.yaml
drift-testcase-file: v1
title: "API Contract Tests"

sources:
  - name: api-spec
    path: ./openapi.yaml  # Fetched from SwaggerHub

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
  getProduct_Success:
    target: api-spec:getProductById
    parameters:
      path:
        id: 123
    expected:
      response:
        statusCode: 200
```

## Common Test Patterns

### 200 Success (Happy Path)

```yaml
getProducts_Success:
  target: api-spec:getAllProducts
  expected:
    response:
      statusCode: 200
```

### 201 Created

```yaml
createProduct_Success:
  target: api-spec:createProduct
  parameters:
    request:
      body:
        name: "New Product"
        price: 29.99
  expected:
    response:
      statusCode: 201
```

### 401 Unauthorized

```yaml
getProduct_Unauthorized:
  target: api-spec:getProductById
  exclude:
    - auth  # Strip global auth
  parameters:
    path:
      id: 123
    headers:
      authorization: "Bearer invalid-token"
  expected:
    response:
      statusCode: 401
```

### 404 Not Found

```yaml
getProduct_NotFound:
  target: api-spec:getProductById
  parameters:
    path:
      id: 99999  # Non-existent ID
  expected:
    response:
      statusCode: 404
```

### 400 Bad Request

```yaml
createProduct_InvalidData:
  target: api-spec:createProduct
  parameters:
    request:
      body:
        price: "not-a-number"  # Intentionally invalid
    ignore:
      schema: true  # Suppress validation error
  expected:
    response:
      statusCode: 400
```

## Using Datasets

Separate test data from test logic:

```yaml
# api-data.dataset.yaml
drift-dataset-file: V1
datasets:
  - name: products
    data:
      existing:
        id: 123
        name: "Test Product"
        price: 19.99
      new:
        name: "New Product"
        price: 29.99
      forbidden:
        id: 456  # For 403 tests
```

Reference in tests:

```yaml
# drift.yaml
sources:
  - name: products
    path: ./api-data.dataset.yaml

operations:
  getProduct_Success:
    target: api-spec:getProductById
    dataset: products
    parameters:
      path:
        id: ${products:existing.id}
    expected:
      response:
        statusCode: 200
```

## Lifecycle Hooks (Stateful Operations)

Use Lua hooks when data must exist before a test:

```lua
-- drift.lua
local server_url = os.getenv("API_BASE_URL")

local exports = {
  ["operation:started"] = function(event, data)
    if data.operation == "deleteProduct_Success" then
      -- Create product before deleting it
      http({
        url = server_url .. "/products",
        method = "POST",
        headers = { authorization = "Bearer " .. os.getenv("API_TOKEN") },
        body = { id = 123, name = "temp", price = 9.99 }
      })
    end
  end,
  
  ["operation:finished"] = function(event, data)
    -- Cleanup after test
    if data.operation == "createProduct_Success" then
      http({
        url = server_url .. "/products/" .. data.response.body.id,
        method = "DELETE",
        headers = { authorization = "Bearer " .. os.getenv("API_TOKEN") }
      })
    end
  end
}

return exports
```

## Tags for Test Management

```yaml
operations:
  getAllProducts_Success:
    tags: [smoke, read-only, products]
    target: api-spec:getAllProducts
    expected:
      response:
        statusCode: 200
  
  deleteProduct_Success:
    tags: [destructive, products]
    target: api-spec:deleteProduct
    parameters:
      path:
        id: 123
    expected:
      response:
        statusCode: 204
```

Run by tag:

```bash
# Smoke tests only
drift verify -f drift.yaml -u https://api.example.com --tags smoke

# Exclude destructive tests
drift verify -f drift.yaml -u https://api.example.com --tags '!destructive'

# Multiple tags (OR logic)
drift verify -f drift.yaml -u https://api.example.com --tags 'smoke,regression'
```

## Expressions

| Syntax | Example | Purpose |
|--------|---------|---------|
| `${env:VAR}` | `${env:API_TOKEN}` | Environment variable |
| `${dataset:path}` | `${products:existing.id}` | Dataset value |
| `${functions:fn}` | `${functions:generate_uuid}` | Lua function |
| `${dataset:notIn(path)}` | `${products:notIn(existing.*.id)}` | Generate value NOT in dataset |

## Mock Server Testing

Test locally with Prism before live API:

```bash
# Start mock server
npx @stoplight/prism-cli mock openapi.yaml -p 4010

# Run tests against mock
drift verify -f drift.yaml -u http://localhost:4010
```

Force specific response codes on mock:

```yaml
getProduct_NotFound:
  target: api-spec:getProductById
  parameters:
    path:
      id: 99999
    headers:
      Prefer: "code=404"  # Force 404 on mock server
  expected:
    response:
      statusCode: 404
```

## Common Issues

### "Value for query parameter X is missing"

Parameter lacks `example` in OpenAPI spec. Add explicitly:

```yaml
parameters:
  query:
    version: "2024-01-04"
    format: "json"
```

### "Schema validation error"

**This is drift detection** — API doesn't match spec. Either:
- Fix the API to match the spec
- Update the spec if API is correct
- Use `ignore: { schema: true }` only for intentional 4xx tests

### "Got 401, expected 200"

Add authentication:

```yaml
global:
  auth:
    apply: true
    parameters:
      authentication:
        scheme: bearer
        token: ${env:API_TOKEN}
```

### "Connection refused"

API or mock server isn't running. Check:

```bash
# For mock server
npx @stoplight/prism-cli mock openapi.yaml -p 4010

# Verify it's running
curl http://localhost:4010/health
```

## Full Coverage Workflow

1. **Fetch spec from SwaggerHub** using MCP
2. **Parse endpoints** to identify all operations + response codes
3. **Generate initial tests** covering each endpoint
4. **Run and iterate** using `drift verify --failed`
5. **Check coverage** with `check_coverage.py`
6. **Publish results** to PactFlow if using BDCT

## Best Practices

- **One test per status code** — write separate tests for 200, 404, 401, etc.
- **Use datasets** — keep test data separate and reusable
- **Tag strategically** — `smoke`, `regression`, `destructive`, `read-only`
- **Lifecycle hooks** — use Lua for stateful operations
- **Mock first** — develop tests against Prism before live API
- **Version control** — commit drift tests alongside API code
- **CI integration** — run Drift in pipelines before deployment
