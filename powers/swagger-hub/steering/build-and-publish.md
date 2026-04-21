# Steering: Build and Publish an API

Use this guide when the user asks to build, create, or update an API from scratch.

## Step-by-Step

### 1. Clarify Requirements
Before writing any code, confirm:
- API name and purpose
- Resources and operations (CRUD? search? events?)
- Authentication method (Bearer JWT, API Key, OAuth2, none)
- Target language/framework (default: Node.js/Express)
- Organization name (or fetch via `list_organizations`)

### 2. Generate Implementation Code
Write production-quality code including:
- Route definitions matching the planned OpenAPI spec
- Input validation (e.g., zod, joi, class-validator)
- Error handling middleware returning standard error shapes
- Auth middleware stub
- JSDoc/docstring comments on public functions
- Unit test stubs

### 3. Generate OpenAPI 3.1 Spec
The spec must include:
- `info`: title, version, description, contact
- `servers`: at least one server URL
- All paths with operationIds, parameter schemas, request bodies
- All response schemas with examples
- `components.schemas` for reusable types
- `components.securitySchemes` for auth
- Error responses: 400, 401, 403, 404, 422, 500

### 4. Scan for Governance Issues
```
org = mcp__smartbear-joe__swagger_list_organizations → first org
result = mcp__smartbear-joe__swagger_scan_api_standardization(org, specContent)
```
Report all errors and warnings. Fix errors before proceeding.

### 5. Auto-Standardize (if API exists)
```
mcp__smartbear-joe__swagger_standardize_api(owner, apiName)
```
If this succeeds, retrieve the corrected spec and update the local file.

### 6. Publish to SwaggerHub
```
mcp__smartbear-joe__swagger_create_or_update_api(owner, apiName, specContent)
```
Capture the returned SwaggerHub URL.

### 7. Update Developer Portal
```
portals = mcp__smartbear-joe__swagger_list_portals()
products = mcp__smartbear-joe__swagger_list_portal_products(portalId)
sections = mcp__smartbear-joe__swagger_list_portal_product_sections(portalId, productId, embed: ['tableOfContents'])
mcp__smartbear-joe__swagger_create_table_of_contents(portalId, productId, sectionId, {type: 'apiUrl', url: swaggerHubUrl})
mcp__smartbear-joe__swagger_publish_portal_product(portalId, productId, preview: false)
```

### 8. Commit and Push
```bash
git add .
git commit -m "feat(api): add {apiName} - published to SwaggerHub {url}"
git push origin main
```

## Checklist Before Marking Complete

- [ ] Code and spec are in sync (same endpoints, same schemas)
- [ ] Spec passes governance scan with zero errors
- [ ] SwaggerHub URL confirmed
- [ ] Portal published (or user explicitly skipped this)
- [ ] Changes committed and pushed
