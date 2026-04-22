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
  - mcp__smartbear-mcp__swagger_*
---

# Build REST API with Governance (Mandatory Workflow)

**DO NOT SKIP STEPS. Execute in order. Each step is required.**

## STEP 1: Get Organization & Search Similar APIs

1. List organizations: `mcp__smartbear-mcp__swagger_list_organizations`
2. Get the user's organization name from the response
3. Search for similar APIs: `mcp__smartbear-mcp__swagger_search_apis_and_domains`
   - Search for relevant keywords (e.g., "ecommerce", "store", "product", "tool")
   - Get 3-5 similar APIs
4. **ANALYZE** each similar API:
   - Download spec using `mcp__smartbear-mcp__swagger_get_api_definition`
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

8. **FIRST SCAN**: `mcp__smartbear-mcp__swagger_scan_api_standardization`
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

## STEP 4: Create or Update in SwaggerHub

12. Upload spec: `mcp__smartbear-mcp__swagger_create_or_update_api`
    - owner: organization name from Step 1
    - apiName: [descriptive name from user's domain]
    - definition: the validated OpenAPI spec from Step 3
13. Capture the SwaggerHub URL from response
14. Report URL to user

---

## STEP 5: Create Portal Documentation (MANDATORY)

15. List portals: `mcp__smartbear-mcp__swagger_list_portals`
    - Find a relevant portal (e.g., if ecommerce API, find "Products Portal" or "Ecommerce Portal")

16. Get portal products: `mcp__smartbear-mcp__swagger_list_portal_products`
    - Find a matching product or create new one

17. Get product sections: `mcp__smartbear-mcp__swagger_list_portal_product_sections`
    - Embed: ['tableOfContents']

18. **CREATE** these documentation sections (REQUIRED):

    **A) API Reference Section**:
    - Create table of contents entry with type: `apiUrl`
    - Link to SwaggerHub spec from Step 4

    **B) Getting Started Section**:
    - Create table of contents entry with type: `markdown` or `html`
    - Create document with:
      - Setup instructions (prerequisites, how to run)
      - Authentication guide (how to get API key/token)
      - Basic example request

    **C) Usage Examples Section**:
    - Create table of contents entry with type: `markdown`
    - Create document with:
      - cURL command for EVERY endpoint (GET, POST, PUT, DELETE)
      - Real example requests and responses
      - Common use cases

    **D) Error Handling Section** (if needed):
    - Document all HTTP status codes
    - Include error response examples

19. Publish portal: `mcp__smartbear-mcp__swagger_publish_portal_product`
    - preview: false (LIVE, not draft)
    - Verify product is now visible and accessible

20. Report portal URL to user

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
- ✅ Step 5: Portal documentation created with 4 sections
- ✅ Step 5: Portal published (not preview)
- ✅ Step 6: Pushed to GitHub

**If ANY step incomplete, do not report success to user.**

---

## If Errors Occur

**Validation Loop Stuck**: If same error repeats 3+ times, analyze deeply:
- Is the error about naming? Compare to similar API's exact naming
- Is the error about structure? Copy the exact structure from similar API
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
