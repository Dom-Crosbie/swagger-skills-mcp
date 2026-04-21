# Steering: API Governance and Standardization

Use this guide when the user asks to validate, scan, or standardize an OpenAPI spec.

## When to Use This Guide

- Checking a spec for governance violations before publishing
- Fixing errors returned by a previous scan
- Auto-standardizing a spec already in SwaggerHub
- Setting up governance as part of a CI/CD workflow

## Step-by-Step

### 1. Locate the Spec
Check in order:
1. Path provided by the user
2. `specs/openapi.yaml`
3. `openapi.yaml` at project root
4. `openapi.json` at project root
5. `swagger.yaml` at project root

If not found, ask the user for the path.

### 2. Get Organization Name
```
orgs = mcp__smartbear-mcp__swagger_list_organizations()
```
Organization names are **case-sensitive**. Use the exact value returned.

### 3. Scan for Violations
```
result = mcp__smartbear-mcp__swagger_scan_api_standardization(
  organization: orgName,
  definition: specContent  // full YAML/JSON as string
)
```

### 4. Categorize and Report Results

**Format the output clearly:**
```
Scan Results: {apiName}
Organization: {orgName}

❌ Errors ({count}) — must fix before publishing:
  • {path}: {description}

⚠️  Warnings ({count}) — should fix:
  • {path}: {description}

✅ Passed: {count} checks
```

### 5. Fix Violations

**Option A — Auto-standardize** (API already in SwaggerHub):
```
mcp__smartbear-mcp__swagger_standardize_api(owner, apiName)
```
Retrieve the corrected spec and update the local file.

**Option B — Manual fixes** (new API or auto-fix unavailable):

| Error Type | Remediation |
|------------|-------------|
| Missing `operationId` | Add unique camelCase ID to each operation |
| Missing `description` | Add to each operation, parameter, and schema |
| No `examples` | Add `example` field to schema properties |
| Naming violation | Rename identifiers to org standard (usually camelCase) |
| No security scheme | Define in `components.securitySchemes`, apply to operations |
| Missing error responses | Add 400, 401, 404, 422, 500 with schemas |
| No `info.contact` | Add `contact.name` and `contact.email` to `info` block |

### 6. Re-Scan to Verify
Re-run step 3 after fixes. Only proceed to publish once error count is zero.

## Governance Integration in CI/CD

For teams wanting automated governance checks, the scan can be run in CI using the SwaggerHub API directly:
```bash
curl -X POST \
  "https://api.swaggerhub.com/apis/{org}/{api}/standardization" \
  -H "Authorization: {api-key}" \
  -H "Content-Type: application/json" \
  --data-binary @specs/openapi.yaml
```

Add this as a GitHub Actions step in `.github/workflows/api-validation.yml` to catch violations on every PR.
