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

### Phase 3 — Validation & Standardization (**MANDATORY**)
```
mcp__smartbear-mcp__swagger_list_organizations       → get org name
mcp__smartbear-mcp__swagger_scan_api_standardization → scan spec
```
**BLOCK if errors found.** Warnings are OK; errors are not. Fix errors or use auto-fix:
```
mcp__smartbear-mcp__swagger_standardize_api          → auto-fix (if API exists)
```
Then re-scan to confirm **zero errors** before proceeding.

### Phase 4 — SwaggerHub Registry
```
mcp__smartbear-mcp__swagger_create_or_update_api     → publish spec
```
Returns a SwaggerHub URL: `https://app.swaggerhub.com/apis/{owner}/{apiName}/1.0.0`

### Phase 5 — Portal Documentation Linking (**MANDATORY**)
Link the newly created API to your Developer Portal:
```
mcp__smartbear-mcp__swagger_list_portals             → discover portals
mcp__smartbear-mcp__swagger_list_portal_products     → find or create product
mcp__smartbear-mcp__swagger_create_table_of_contents → add API reference
  └─ type: apiUrl
  └─ url: https://api.swaggerhub.com/apis/{owner}/{apiName}/{version}
mcp__smartbear-mcp__swagger_publish_portal_product   → publish live
```
**REQUIRED:** Portal product must be created and API reference must be linked before Phase 6.

### Phase 6 — GitHub Publication
```bash
git add .
git commit -m "API update: [description] - validated, published to SwaggerHub, linked in portal"
git push origin main
```

## Example Output

```
✅ Phase 1: API code generated (Node.js/Express)
✅ Phase 2: OpenAPI 3.1 spec created
✅ Phase 3: Governance validation
   • Scanned against acme-corp governance rules
   • 2 violations found → auto-fixed
   • Re-scanned → zero errors ✓
✅ Phase 4: Published → https://app.swaggerhub.com/apis/acme/orders-api/1.0.0
✅ Phase 5: Portal documentation linking
   • Found portal: Developer Portal
   • Created product: Orders API
   • Linked API reference in portal
   • Published live → https://developer.acme.com/orders-api
✅ Phase 6: Committed and pushed (abc1234)
```

## What Would You Like to Build?

Describe your API and I'll take it from spec to production.
