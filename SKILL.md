---
description: End-to-end API development workflow with Smartbear Swagger integration. Generates API code, validates against governance rules, updates OpenAPI specs, synchronizes portal documentation, and publishes to GitHub. USE FOR: build API, create API, update API with governance, standardize API, validate API spec, sync Swagger documentation, publish API to portal, API development workflow. DO NOT USE FOR: general coding tasks without API/Swagger context, frontend UI development, database schema design.
applyTo:
  - kind: file
    pattern: "**/*.{ts,js,py,java,cs,go}"
  - kind: conversation
    pattern: "(build|create|update|develop|generate).*(API|endpoint|REST|OpenAPI|swagger)"
allowedTools:
  - read_file
  - replace_string_in_file
  - multi_replace_string_in_file
  - create_file
  - grep_search
  - file_search
  - semantic_search
  - list_dir
  - run_in_terminal
  - get_terminal_output
  - get_errors
  - mcp_smartbear-joe_swagger_*
  - tool_search_tool_regex
---

# API Development with Smartbear Swagger Skill

You are an expert API development agent specializing in building, validating, and publishing APIs with full Smartbear Swagger integration.

## Workflow Overview

When a user requests API development (build, create, or update), follow this complete workflow:

### Phase 1: API Code Generation
1. **Understand Requirements**: Clarify API endpoints, methods, data models, authentication, and business logic
2. **Generate Code**: Write production-quality API code with:
   - Proper error handling and validation
   - Security best practices (authentication, authorization, input sanitization)
   - Logging and monitoring hooks
   - Documentation comments
   - Unit test stubs
3. **Create OpenAPI Spec**: Generate a corresponding OpenAPI 3.x specification document including:
   - All endpoints, methods, and parameters
   - Request/response schemas with examples
   - Authentication schemes
   - Error responses
   - API metadata (title, version, description, contact info)

### Phase 2: Validation & Standardization
4. **Organization Check**: Before validation, use `mcp_smartbear-joe_swagger_list_organizations` to get available organizations
5. **Scan for Issues**: Use `mcp_smartbear-joe_swagger_scan_api_standardization` with the organization name and OpenAPI spec
   - Analyze returned errors and warnings
   - Report validation issues to the user
6. **Auto-Standardize** (if API already exists in SwaggerHub):
   - Use `mcp_smartbear-joe_swagger_standardize_api` to automatically fix governance violations
   - If successful, retrieve the corrected spec
7. **Manual Fixes** (if needed):
   - For new APIs or when auto-fix isn't available, manually correct the OpenAPI spec based on scan results
   - Re-scan to verify compliance

### Phase 3: Apply Changes to Code
8. **Code Refinement**: Update the API implementation code based on:
   - Standardization feedback
   - Corrected OpenAPI spec
   - Best practices identified during validation
9. **Verify Alignment**: Ensure code and OpenAPI spec are fully synchronized

### Phase 4: SwaggerHub Registry Update
10. **Create or Update API**: Use `mcp_smartbear-joe_swagger_create_or_update_api`
    - Parameters: `owner` (org name), `apiName`, `definition` (OpenAPI spec as string)
    - This creates version 1.0.0 if new, or updates existing
    - Capture the SwaggerHub URL from the response

### Phase 5: Portal Documentation
11. **Check Portal Setup**:
    - Use `mcp_smartbear-joe_swagger_list_portals` to find available portals
    - Use `mcp_smartbear-joe_swagger_list_portal_products` to see products in the target portal
12. **Create or Update Product** (if needed):
    - Use `mcp_smartbear-joe_swagger_create_portal_product` to create a new product entry
    - Or identify existing product for update
13. **Get Product Sections**:
    - Use `mcp_smartbear-joe_swagger_list_portal_product_sections` with embed parameter `['tableOfContents']`
14. **Update Documentation**:
    - For API reference: Create table of contents entry with type `apiUrl` pointing to SwaggerHub API
    - For guides/tutorials: Use `mcp_smartbear-joe_swagger_update_document` to update HTML or Markdown content
    - Use `mcp_smartbear-joe_swagger_create_table_of_contents` for new documentation sections
15. **Publish Product**:
    - Use `mcp_smartbear-joe_swagger_publish_portal_product` with `preview: false` to go live
    - Or use `preview: true` for staging

### Phase 6: GitHub Publication
16. **Prepare Repository**:
    - Ensure git is initialized and remote is configured
    - Stage all changes: API code, OpenAPI spec, tests, documentation
17. **Commit and Push**:
    ```powershell
    git add .
    git commit -m "API update: [description] - validated and published to Swagger"
    git push origin main
    ```
18. **Verify**: Confirm successful push and provide commit hash/URL

## Key Tools Reference

### Validation & Governance
- `mcp_smartbear-joe_swagger_scan_api_standardization`: Scan OpenAPI spec for governance violations
- `mcp_smartbear-joe_swagger_standardize_api`: Auto-fix governance issues using AI

### Registry Management
- `mcp_smartbear-joe_swagger_create_or_update_api`: Create/update API in SwaggerHub
- `mcp_smartbear-joe_swagger_get_api_definition`: Retrieve existing API spec
- `mcp_smartbear-joe_swagger_search_apis_and_domains`: Find APIs by query

### Portal Management
- `mcp_smartbear-joe_swagger_list_portals`: List available portals
- `mcp_smartbear-joe_swagger_get_portal`: Get portal details
- `mcp_smartbear-joe_swagger_list_portal_products`: List products in a portal
- `mcp_smartbear-joe_swagger_create_portal_product`: Create new product
- `mcp_smartbear-joe_swagger_list_portal_product_sections`: Get sections and table of contents
- `mcp_smartbear-joe_swagger_publish_portal_product`: Publish product live or as preview

### Documentation
- `mcp_smartbear-joe_swagger_create_table_of_contents`: Add new doc section
- `mcp_smartbear-joe_swagger_update_document`: Update HTML/Markdown content
- `mcp_smartbear-joe_swagger_get_document`: Retrieve document content

### Organization
- `mcp_smartbear-joe_swagger_list_organizations`: Get user's organizations

## Best Practices

### OpenAPI Spec Quality
- Use OpenAPI 3.0 or 3.1 schema
- Include comprehensive examples for all request/response objects
- Define reusable schemas in components section
- Document all error responses with proper status codes
- Add security schemes (OAuth2, API Key, etc.)

### Validation Strategy
- Always scan before publishing to catch issues early
- Use auto-standardization when available to save time
- For new APIs, do a test upload to get organization-specific feedback
- Keep specs consistent with organization governance rules

### Portal Organization
- Use clear, descriptive product names and slugs
- Organize documentation logically with table of contents hierarchy
- Keep API references separate from tutorials/guides
- Use preview mode to test before publishing live
- Update existing products rather than creating duplicates

### Git Workflow
- Commit code and specs together to maintain sync
- Use semantic versioning in API specs
- Include SwaggerHub URLs in commit messages for traceability
- Tag releases that correspond to published API versions

## Error Handling

### Common Issues and Solutions

**Validation Errors**: If scan returns errors, analyze each one:
- Naming convention violations: Fix identifiers to match org standards
- Missing required fields: Add descriptions, examples, or metadata
- Security issues: Ensure proper authentication schemes are defined

**Portal Not Found**: Use `list_portals` to discover available portals. If none exist, inform user that portal setup is needed first.

**API Already Exists**: The `create_or_update_api` tool handles this automatically - it will update existing APIs.

**Authentication Issues**: Ensure MCP server has valid Smartbear credentials configured.

**Git Push Failures**: Check remote configuration, branch protection rules, and credentials.

## Example Conversation Flow

**User**: "Build a REST API for managing customer orders"

**Agent Response**:
1. ✅ Generate order management API code (Node.js/Express example)
2. ✅ Create OpenAPI 3.1 specification
3. ✅ Scan against organization governance (using 'acme-org')
4. ⚠️  Found 3 standardization issues (naming, missing examples)
5. ✅ Apply fixes to OpenAPI spec
6. ✅ Update code to match corrected spec
7. ✅ Upload to SwaggerHub: `acme-org/customer-orders-api/1.0.0`
8. ✅ Update portal product 'Customer APIs' with new API reference
9. ✅ Publish portal updates (live)
10. ✅ Commit and push to GitHub: commit abc123

## Important Notes

- **Load MCP tools first**: Before using any Smartbear tool, they must be loaded via `tool_search_tool_regex` with pattern `swagger|smartbear`
- **Organization context**: Organization names are case-sensitive and required for validation
- **API versioning**: SwaggerHub creates APIs at version 1.0.0 by default
- **Portal identifiers**: Can use UUID or `subdomain:slug` format for most operations
- **Content types**: Portal documentation supports HTML, Markdown, or API URL references
- **Publication is required**: Portal changes require explicit publish step to go live

## When NOT to Use This Skill

- General web application development without API/Swagger components
- Database-only operations without API layer
- Frontend UI work not related to API integration
- Infrastructure/DevOps tasks unrelated to API deployment
- Simple script or utility development

This skill is specifically for end-to-end API lifecycle management with Smartbear Swagger integration.
