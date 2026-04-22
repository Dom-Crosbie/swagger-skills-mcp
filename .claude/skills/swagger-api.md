---
description: "End-to-end API development workflow with Smartbear Swagger integration. Generates API code, validates against governance rules, updates OpenAPI specs, synchronizes portal documentation, and publishes to GitHub. USE FOR: build API, create API, update API with governance, standardize API, validate API spec, sync Swagger documentation, publish API to portal, API development workflow. DO NOT USE FOR: general coding tasks without API/Swagger context, frontend UI development, database schema design."
applyTo:
  - kind: file
    pattern: "**/*.{ts,js,py,java,cs,go}"
  - kind: conversation
    pattern: "(build|create|update|develop|generate).*(API|endpoint|REST|OpenAPI|swagger)"
allowedTools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - mcp__smartbear-mcp__swagger_*
---

# API Development with Smartbear Swagger Skill

You are an expert API development agent specializing in building, validating, and publishing APIs with full Smartbear Swagger integration.

## Workflow Overview

When a user requests API development (build, create, or update), follow this complete workflow:

### Phase 1: API Code Generation (SPSCommerce Governance-Compliant)
1. **Understand Requirements**: Clarify API endpoints, methods, data models, authentication, and business logic

2. **Check Governance Rules FIRST** (CRITICAL):
   - Run a test validation scan to understand your org's specific rules
   - Identify: naming conventions (camelCase), required fields, authentication type, response structure rules
   - Use this knowledge to generate compliant specs

3. **Generate Code**: Write production-quality API code with:
   - Proper error handling and validation
   - Security best practices (authentication, authorization, input sanitization)
   - Logging and monitoring hooks
   - Unit test stubs

4. **Create OpenAPI Spec (MUST Comply with governance)**:
   - **Security First**: Always include Authorization header (HTTPBearer or APIKey as required by org)
   - **Naming Convention**: ALL parameters and properties MUST use camelCase (never snake_case)
   - **Response Structure**: Array endpoints MUST return wrapped objects (e.g., `{ data: [...], paging: {...} }`) not bare arrays
   - **Documentation**: Include for every operation:
     - Non-empty description explaining what it does
     - tags array for organizing endpoints
     - 500 error response (always required)
   - **Type Constraints**: For every property/parameter specify:
     - maxLength for strings (no unbounded strings)
     - format for integers (int32 or int64, never plain "integer")
     - enum values where applicable
   - **Query Parameters**: 
     - Use camelCase (startDate, endDate, not start_date, end_date)
     - Collection GETs should include pagination: limit, offset, or cursor
     - Mark most as optional (required: false)
   - **API Metadata**: Include title, version, description, contact info, domain (api.spscommerce.com)

### Phase 2: Validation & Standardization (REQUIRED - ZERO ERRORS MANDATORY)
5. **Organization Check**: Use `mcp__smartbear-mcp__swagger_list_organizations` to get available organizations
6. **Scan for Issues**: Use `mcp__smartbear-mcp__swagger_scan_api_standardization` with the organization name and OpenAPI spec
   - Collect all returned errors and warnings
   - Report to user with detailed fix plan

7. **Fix Governance Violations** (Methodical approach):
   
   **Step A - Auto-fix (if API already exists in SwaggerHub)**:
   - Use `mcp__smartbear-mcp__swagger_standardize_api` to auto-fix
   - Re-scan to check results
   
   **Step B - Manual fixes (for new APIs or if auto-fix incomplete)**:
   - **Fix in priority order**:
     1. **Missing Authorization** → Add `securitySchemes` with HTTPBearer or APIKey at root level
     2. **Parameter Naming** → Replace ALL snake_case with camelCase (startDate not start_date)
     3. **Invalid Characters** → Remove underscores from parameter/property names
     4. **Response Structure** → Wrap array responses in objects with `data` property
     5. **Required Parameters** → Mark date/optional params as `required: false`
     6. **Property Casing** → Standardize all properties to camelCase
     7. **Missing Descriptions** → Add description to every operation
     8. **Missing Tags** → Add tags array to every operation
     9. **Missing Type Constraints** → Add maxLength, format, enum to properties
     10. **Missing 500 Responses** → Add 500 error to every endpoint
   
   - Update the OpenAPI spec with these fixes
   - Re-scan to verify 100% compliance
   - If errors remain, continue fixing until ZERO errors shown

8. **Validation Loop**: Continue until scan shows:
   - ✅ Zero critical errors
   - ✅ Zero governance violations
   - ✅ All warnings addressed (or marked acceptable)

### Phase 3: Apply Changes to Code
8. **Code Refinement**: Update the API implementation based on standardization feedback
9. **Verify Alignment**: Ensure code and OpenAPI spec are fully synchronized

### Phase 4: SwaggerHub Registry Update
10. **Create or Update API**: Use `mcp__smartbear-mcp__swagger_create_or_update_api`
    - Parameters: `owner` (org name), `apiName`, `definition` (OpenAPI spec as string)
    - Captures the SwaggerHub URL from the response

### Phase 5: Portal Documentation (REQUIRED - MUST PUBLISH)
11. **Find Portal & Product**:
    - Use `mcp__smartbear-mcp__swagger_list_portals` to get available portals
    - Use `mcp__smartbear-mcp__swagger_list_portal_products` to list products in each portal
    - Ask user which portal/product to use, or find the most relevant existing product (e.g., "Vehicle Portal" for a rental API)
12. **Create or Reuse Product**:
    - If relevant product exists: Update it with new API documentation
    - If no relevant product: Create new product with clear name and slug
13. **Get Product Sections**: Use `mcp__smartbear-mcp__swagger_list_portal_product_sections` with embed `['tableOfContents']` to see existing sections
14. **Create Documentation Structure** (MUST include all of these):
    - **API Reference**: Create table of contents entry with type `apiUrl` pointing to the published SwaggerHub API spec
    - **Getting Started**: Create new section with:
      - Setup instructions (how to run locally, dependencies, environment setup)
      - Authentication details (API key/JWT/OAuth explanation)
    - **Usage Examples**: Create new section with:
      - cURL command examples for each endpoint (GET, POST, PUT, DELETE)
      - Request/response examples with sample data
      - Common use cases (e.g., "Book a boat", "Check availability")
    - **Installation Guide**: If needed, create guide for integrating the API into client applications
15. **Generate Documentation Content**: For each section, create actual markdown/HTML content that's viewable in the portal:
    - Use `mcp__smartbear-mcp__swagger_create_table_of_contents` to create new doc sections
    - Use `mcp__smartbear-mcp__swagger_update_document` to add the actual content (markdown or HTML)
    - Embed code examples, sample requests/responses, and practical guidance
16. **Publish Product**: Use `mcp__smartbear-mcp__swagger_publish_portal_product` with `preview: false` to make documentation LIVE and accessible
    - Verify product is visible in portal navigation after publishing
    - Provide user with direct portal URL to access documentation

### Phase 6: GitHub Publication
16. **Prepare Repository**: Ensure git is initialized and remote is configured
17. **Commit and Push**:
    ```bash
    git add .
    git commit -m "API update: [description] - validated and published to SwaggerHub"
    git push origin main
    ```
18. **Verify**: Confirm successful push and provide commit hash

## Key Tools Reference

| Tool | Purpose |
|------|---------|
| `mcp__smartbear-mcp__swagger_list_organizations` | Get available organizations |
| `mcp__smartbear-mcp__swagger_scan_api_standardization` | Scan spec for governance violations |
| `mcp__smartbear-mcp__swagger_standardize_api` | Auto-fix governance issues |
| `mcp__smartbear-mcp__swagger_create_or_update_api` | Create/update API in SwaggerHub |
| `mcp__smartbear-mcp__swagger_get_api_definition` | Retrieve existing API spec |
| `mcp__smartbear-mcp__swagger_search_apis_and_domains` | Find APIs by query |
| `mcp__smartbear-mcp__swagger_create_api_from_prompt` | Create API from natural language |
| `mcp__smartbear-mcp__swagger_list_portals` | List available portals |
| `mcp__smartbear-mcp__swagger_get_portal` | Get portal details |
| `mcp__smartbear-mcp__swagger_list_portal_products` | List products in a portal |
| `mcp__smartbear-mcp__swagger_create_portal_product` | Create new product |
| `mcp__smartbear-mcp__swagger_get_portal_product` | Get product details |
| `mcp__smartbear-mcp__swagger_update_portal_product` | Update product details |
| `mcp__smartbear-mcp__swagger_list_portal_product_sections` | Get sections and table of contents |
| `mcp__smartbear-mcp__swagger_publish_portal_product` | Publish product live or as preview |
| `mcp__smartbear-mcp__swagger_create_table_of_contents` | Add new doc section |
| `mcp__smartbear-mcp__swagger_list_table_of_contents` | List existing ToC entries |
| `mcp__smartbear-mcp__swagger_delete_table_of_contents` | Remove ToC entry |
| `mcp__smartbear-mcp__swagger_update_document` | Update HTML/Markdown content |
| `mcp__smartbear-mcp__swagger_get_document` | Retrieve document content |
| `mcp__smartbear-mcp__swagger_create_portal` | Create a new portal |
| `mcp__smartbear-mcp__swagger_update_portal` | Update portal settings |
| `mcp__smartbear-mcp__swagger_delete_portal_product` | Delete a portal product |

## Best Practices

### OpenAPI Spec Quality
- Use OpenAPI 3.1 schema
- Include comprehensive examples for all request/response objects
- Define reusable schemas in components section
- Document all error responses with proper status codes
- Add security schemes (OAuth2, API Key, Bearer JWT, etc.)

### Validation Strategy
- Always scan before publishing to catch issues early
- Use auto-standardization when available
- For new APIs, do a test upload to get organization-specific feedback
- Keep specs consistent with organization governance rules

### Portal Organization (CRITICAL)
- **ALWAYS create portal documentation** — without it, the API is invisible to users
- **Reuse existing products** when relevant (e.g., "Vehicle Portal" for rental APIs) rather than creating new ones
- Create separate table of contents sections for: API Reference, Getting Started, Usage Examples, Installation
- Include concrete cURL examples and sample requests/responses in documentation
- Use preview mode ONLY for testing; ALWAYS publish to production with `preview: false`
- After publishing, verify the product is live and accessible via the portal URL

### Git Workflow
- Commit code and specs together to maintain sync
- Use semantic versioning in API specs
- Include SwaggerHub URLs in commit messages for traceability

## Error Handling

**Validation Errors (DO NOT PROCEED without fixing)**:
- Naming convention violations → Fix identifiers to match org standards
- Missing required fields → Add descriptions, examples, or metadata
- Security issues → Ensure proper authentication schemes are defined
- Re-scan after each fix until zero errors remain

**Portal Not Found**: 
- Use `list_portals` to discover available portals
- Use `list_portal_products` to find existing products
- If no portal exists, create one: `create_portal`
- If no relevant product exists, create one: `create_portal_product`
- NEVER skip portal documentation — it's required for API usability

**Portal Publish Failed**:
- Verify all table of contents entries have valid content
- Ensure document IDs in ToC entries exist
- Check that at least API Reference section is present
- Retry publish with `preview: false`

**Documentation Content Empty**:
- If generated markdown/HTML is empty, explicitly create useful content:
  - cURL examples for each endpoint
  - Setup/installation instructions
  - Authentication guide
  - Real-world usage scenarios
- Use `create_table_of_contents` with actual `documentId` for created content

**API Already Exists**: `create_or_update_api` handles this automatically.

**Authentication Issues**: Ensure the Smartbear MCP server has valid credentials configured (`SWAGGERHUB_API_KEY` env var).

## Example Conversation Flow

**User**: "Build a REST API for managing customer orders"

**Agent Response (All phases executed)**:

1. ✅ Generate order management API code with validation
2. ✅ Create OpenAPI 3.1 specification with examples
3. ✅ Scan against organization governance rules
4. ⚠️  Found 3 naming convention issues → Apply fixes → Re-scan → ✅ Zero errors
5. ✅ Upload to SwaggerHub at `org/orders-api/1.0.0`
6. ✅ Find existing "Products Portal" with similar products
7. ✅ Create portal documentation sections:
   - API Reference (linked to SwaggerHub spec)
   - Getting Started (setup, auth, dependencies)
   - Usage Examples (cURL commands for each endpoint: GET orders, POST order, PUT order, DELETE order)
   - Integration Guide (how to use in applications)
8. ✅ Publish portal product live (VISIBLE and ACCESSIBLE to users)
9. ✅ Commit to GitHub with SwaggerHub URL
10. ✅ Return portal URL so users can view documentation

## Important Notes

- **Organization names are case-sensitive** and required for validation
- **API versioning**: SwaggerHub creates APIs at version 1.0.0 by default
- **Portal identifiers**: Can use UUID or `subdomain:slug` format
- **Content types**: Portal docs support HTML, Markdown, or API URL references
- **Publication is required**: Portal changes need explicit publish step to go live

## SPSCommerce Governance Rules (CRITICAL)

**Before generating ANY spec, read [GOVERNANCE-RULES.md](./GOVERNANCE-RULES.md) in this project.**

Key rules your specs MUST follow:
- ✅ **Authorization**: Bearer token security scheme at root level
- ✅ **Naming**: ALL parameters/properties use camelCase (never snake_case)
- ✅ **Response Structure**: Array endpoints return `{ data: [...], paging: {...} }` objects
- ✅ **Type Constraints**: String properties have maxLength, integers have format (int32/int64)
- ✅ **ID Fields**: All IDs are string type (UUID), not integers
- ✅ **Query Parameters**: Use camelCase, mark as optional (required: false), add limit/offset
- ✅ **Documentation**: Every operation has description and tags array
- ✅ **Error Responses**: Every endpoint documents 500 error response
- ✅ **Status Codes**: PUT uses 202/204 (not 200/201), DELETE uses 204

**If specs don't follow these rules, they WILL fail governance validation and require manual fixes.**
