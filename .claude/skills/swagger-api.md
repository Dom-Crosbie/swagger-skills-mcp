---
description: "Build REST APIs end-to-end with governance compliance. Learns from existing org APIs, generates spec and code, validates until zero errors, creates portal docs, and publishes. USE FOR: build API, create API, rest API. DO NOT USE FOR: frontend, databases, non-API tasks."
applyTo:
  - kind: conversation
    pattern: "(build|create).*(API|rest|restful).*(service|store|system|application)"
allowedTools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - mcp__smartbear-joe__swagger_*
---

# Build REST API with Governance (Mandatory Workflow)

**DO NOT SKIP STEPS. Execute in order. Each step is required.**

## STEP 1: Get Organization & Search Similar APIs

1. List organizations: `mcp__smartbear-joe__swagger_list_organizations`
2. Get the user's organization name from the response
3. Search for similar APIs: `mcp__smartbear-joe__swagger_search_apis_and_domains`
   - Search for relevant keywords (e.g., "ecommerce", "store", "product", "tool")
   - Get 3-5 similar APIs
4. **ANALYZE** each similar API:
   - Download spec using `mcp__smartbear-joe__swagger_get_api_definition`
   - Extract and document:
     - Parameter naming (camelCase? snake_case?)
     - Response structure (wrapped arrays? bare arrays?)
     - Security scheme (Bearer? API Key?)
     - Endpoint patterns (CRUD structure?)
     - HTTP status codes
     - Documentation style

5. **REPORT** findings to user: "Found X similar APIs. Patterns: [naming style, response structure, auth, endpoints]"

---

## STEP 2: Generate API Code & OpenAPI Spec

6. Generate API code matching the domain:
   - Use patterns from Step 1 (naming, structure, auth)
   - Include full CRUD endpoints matching the similar APIs
   - Add error handling and validation
   - Add security implementation (matching similar APIs)

7. Generate OpenAPI 3.1 spec:
   - Use **exact same** naming as similar APIs (camelCase/snake_case)
   - Use **exact same** response structure (wrapped/bare arrays)
   - Use **exact same** security scheme
   - Use **exact same** endpoint patterns
   - Include descriptions and tags on every operation
   - Include examples in request/response schemas

---

## STEP 3: Scan & Validate (MANDATORY LOOP - DO NOT SKIP)

8. **FIRST SCAN**: `mcp__smartbear-joe__swagger_scan_api_standardization`
   - Parameters: org name, OpenAPI spec
   - Collect ALL errors and warnings

9. **IF ERRORS FOUND**: Enter fix loop
   ```
   WHILE spec has errors:
     - Read the error message
     - Analyze what's wrong (naming? structure? security?)
     - Look at similar APIs from Step 1 to see how they handle it
     - Fix the spec to match the similar API's pattern
     - RESCAN the spec
     - IF zero errors THEN break
   ```

10. **VALIDATE** the loop completed:
    - Re-scan result shows: ✅ Zero critical errors
    - If not: continue fixing until zero errors
    - **DO NOT PROCEED without zero errors**

11. Report to user: "Governance validation passed ✅"

---

## STEP 4: Publish to SwaggerHub & Standardize (BOTH REQUIRED)

12. Upload spec: `mcp__smartbear-joe__swagger_create_or_update_api`
    - owner: organization name from Step 1
    - apiName: [descriptive name from user's domain, no spaces]
    - definition: the validated OpenAPI spec from Step 3
13. Capture the SwaggerHub URL from response

14. **STANDARDIZE (MANDATORY)**: `mcp__smartbear-joe__swagger_standardize_api`
    - owner: organization name
    - apiName: same apiName used above
    - This MUST run on every new or updated API — do not skip
    - Wait for completion before proceeding

15. **RE-SCAN after standardize**: `mcp__smartbear-joe__swagger_scan_api_standardization`
    - Confirm zero errors after standardization
    - If new errors introduced, fix and standardize again

16. Report SwaggerHub URL to user

---

## STEP 5: Create Portal Documentation (MANDATORY — all sub-steps required)

The SwaggerHub spec URL from Step 4 MUST be carried into this step.
Use format: `https://api.swaggerhub.com/apis/{owner}/{apiName}/{version}`

17. List portals: `mcp__smartbear-joe__swagger_list_portals`
    - Find the most relevant portal for this API domain

18. List products: `mcp__smartbear-joe__swagger_list_portal_products`
    - If a matching product exists, use it
    - If not, create one: `mcp__smartbear-joe__swagger_create_portal_product`

19. Get current sections: `mcp__smartbear-joe__swagger_list_portal_product_sections`
    - embed: ['tableOfContents']

20. **ADD API REFERENCE (REQUIRED FIRST)**:
    - `mcp__smartbear-joe__swagger_create_table_of_contents`
    - type: `apiUrl`
    - title: "[API Name] Reference"
    - url: **the SwaggerHub spec URL from Step 16** (`https://api.swaggerhub.com/apis/...`)
    - This links the portal page directly to the published API spec

21. **ADD GETTING STARTED PAGE**:
    - `mcp__smartbear-joe__swagger_create_table_of_contents` with type: `document`, title: "Getting Started"
    - Capture the `documentId` from the response
    - `mcp__smartbear-joe__swagger_update_document` with content covering:
      - Prerequisites and installation
      - How to authenticate (API key / Bearer token)
      - First example request

22. **ADD USAGE EXAMPLES PAGE**:
    - `mcp__smartbear-joe__swagger_create_table_of_contents` with type: `document`, title: "Usage Examples"
    - Capture the `documentId` from the response
    - `mcp__smartbear-joe__swagger_update_document` with content covering:
      - cURL command for every endpoint
      - Real request and response examples

23. Publish live: `mcp__smartbear-joe__swagger_publish_portal_product`
    - preview: **false** (not draft, not preview — LIVE)

24. Report portal product URL to user

---

## STEP 6: Commit & Push to GitHub

21. Stage all changes:
    ```bash
    git add .
    git commit -m "Build [API Name] - validated and published to SwaggerHub at [URL]"
    git push origin main
    ```

22. Report commit URL to user

---

## REQUIRED CHECKLIST

Before completing, verify:

- ✅ Step 1: Similar APIs found and analyzed
- ✅ Step 2: Code and spec generated using same patterns
- ✅ Step 3: Spec scanned and zero errors confirmed
- ✅ Step 4: API published to SwaggerHub with URL
- ✅ Step 4: `swagger_standardize_api` run after publish
- ✅ Step 4: Re-scan after standardize shows zero errors
- ✅ Step 5: Portal documentation created with 4 sections
- ✅ Step 5: Portal published (not preview)
- ✅ Step 6: Pushed to GitHub

**If ANY step incomplete, do not report success to user.**

---

## If Errors Occur

**Common Governance Violations — Fix These Manually if Standardize Doesn't Resolve Them**:

| Error | Fix |
|-------|-----|
| `sps-unknown-error-format` | Add RFC 7807 schema to every error response: `{ type, title, status, detail, instance }` |
| `sps-no-collection-paging-capability` | Wrap list responses: `{ data: [...], paging: { total, limit, offset } }` |
| `sps-missing-pagination-query-parameters` | Add `limit` (int32) and `offset` (int32) to all collection GET endpoints |
| `sps-hosts-spscommerce-domain` | Set `servers[].url` to `https://api.spscommerce.com/...` |
| `owasp:api4:2019-string-limit` | Add `maxLength` to every string property |
| Naming violations | Rename all params/properties to camelCase — no underscores |
| Missing security | Add `securitySchemes` with Bearer token, apply at root |

After each manual fix: standardize again, then re-scan. Loop until zero critical errors.

**Validation Loop Stuck**: If same error repeats 3+ times:
- Apply the manual fix from the table above
- Run standardize again
- Ask user: "Which existing API should I match exactly?"

**Portal Not Found**: Create a new product:
- Use descriptive name matching the domain
- Use the domain as slug (e.g., "power-tools", "ecommerce")

**Governance Scan Unclear**: Get more detail:
- Run scan on a similar API to understand the org's rules
- Compare error messages between new and similar API
- Fix to match the similar API exactly

---

## Summary Output to User

When complete, provide:
1. ✅ API successfully built and validated
2. 📄 SwaggerHub URL: [link]
3. 📚 Portal documentation URL: [link]
4. 💾 GitHub commit: [link]
5. 📝 What you can do now: [list endpoints with brief descriptions]
