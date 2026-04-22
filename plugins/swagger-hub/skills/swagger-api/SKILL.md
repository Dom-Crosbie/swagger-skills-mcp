# SwaggerHub API Lifecycle Skill

I'm ready to help you build, validate, and publish APIs end-to-end using Smartbear's SwaggerHub and Developer Portal.

## What I Can Help With

- **Generate production-ready API code** from a plain-English description
- **Create OpenAPI 3.1 specifications** with full schema, auth, and examples
- **Validate and standardize** your spec against your organization's governance rules
- **Auto-fix governance violations** using SwaggerHub's AI standardization
- **Publish to SwaggerHub registry** to create or update the API version
- **Sync your Developer Portal** with the latest API reference and documentation
- **Commit and push everything** to GitHub in one atomic operation

## Quick Start

**Tell me what API you need:**

> "Build a REST API for managing customer orders with CRUD operations and JWT auth"

I'll handle the rest — code, spec, validation, SwaggerHub upload, portal sync, and git push.

## Workflow Phases

### Phase 1 — API Code Generation
Generate implementation code with error handling, validation, auth middleware, and test stubs. Supported languages: Node.js, Python, Java, C#, Go, Ruby, PHP.

### Phase 2 — OpenAPI Specification
Create a compliant OpenAPI 3.1 spec with:
- All endpoints, methods, and parameters
- Request/response schemas with examples
- Authentication schemes (Bearer JWT, API Key, OAuth2)
- Standard error responses (400, 401, 404, 422, 500)

### Phase 3 — Validation & Standardization (Loop until zero errors)
```
mcp__smartbear-joe__swagger_list_organizations       → get org name
mcp__smartbear-joe__swagger_scan_api_standardization → scan spec, collect all errors
  → fix each error, re-scan
  → repeat until zero critical errors
```

### Phase 4 — SwaggerHub Registry + Standardize (BOTH REQUIRED)
```
mcp__smartbear-joe__swagger_create_or_update_api     → publish spec
mcp__smartbear-joe__swagger_standardize_api          → ALWAYS run after every publish
mcp__smartbear-joe__swagger_scan_api_standardization → re-scan to confirm zero errors
```
Returns a SwaggerHub URL: `https://app.swaggerhub.com/apis/{owner}/{apiName}/1.0.0`

### Phase 5 — Portal Documentation (all steps required, in order)
```
mcp__smartbear-joe__swagger_list_portals
mcp__smartbear-joe__swagger_list_portal_products
mcp__smartbear-joe__swagger_create_portal_product         → if no matching product exists

mcp__smartbear-joe__swagger_list_portal_product_sections  → get current ToC

# Step A — link API spec (REQUIRED, use URL from Phase 4)
mcp__smartbear-joe__swagger_create_table_of_contents      → type: apiUrl, url: https://api.swaggerhub.com/apis/{owner}/{apiName}/{version}

# Step B — Getting Started page
mcp__smartbear-joe__swagger_create_table_of_contents      → type: document, title: "Getting Started"
mcp__smartbear-joe__swagger_update_document               → write setup, auth, first request

# Step C — Usage Examples page
mcp__smartbear-joe__swagger_create_table_of_contents      → type: document, title: "Usage Examples"
mcp__smartbear-joe__swagger_update_document               → write cURL for every endpoint

mcp__smartbear-joe__swagger_publish_portal_product        → preview: false (LIVE)
```

### Phase 6 — GitHub Publication
```bash
git add .
git commit -m "API update: [description] - published to SwaggerHub {url}"
git push origin main
```

## Example Output

```
✅ Phase 1: API code generated (Node.js/Express)
✅ Phase 2: OpenAPI 3.1 spec created
⚠️  Phase 3: 2 governance violations found → auto-fixed
✅ Phase 4: Published → https://app.swaggerhub.com/apis/acme/orders-api/1.0.0
✅ Phase 4: Standardized → zero errors confirmed
✅ Phase 5: Portal product updated and published live
✅ Phase 6: Committed and pushed (abc1234)
```

## What Would You Like to Build?

Describe your API and I'll take it from spec to production.
