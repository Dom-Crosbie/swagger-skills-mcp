# MCP Tools for SwaggerHub + Drift Integration

This document describes all Smartbear MCP server tools available for the swagger-drift workflow.

## Tool Naming Convention

All Smartbear MCP tools are prefixed with:
- `mcp__smartbear-mcp__swagger_` for SwaggerHub operations
- Tool names use snake_case (e.g., `get_api_definition`)

## SwaggerHub Registry Tools

### Get API Definition

Retrieve an OpenAPI spec from SwaggerHub Studio to use with Drift.

```typescript
mcp__smartbear-mcp__swagger_get_api_definition({
  owner: string,        // Organization name (case-sensitive)
  apiName: string,      // API name as shown in SwaggerHub
  version?: string      // Default: "1.0.0"
})
```

**Returns**: OpenAPI specification as a JSON string

**Usage**:
```javascript
// Fetch the spec
const spec = await mcp__smartbear-mcp__swagger_get_api_definition({
  owner: "acme-corp",
  apiName: "products-api",
  version: "1.0.0"
});

// Save locally for Drift
fs.writeFileSync("openapi.yaml", spec);
```

### Search APIs

Find APIs by name or description before fetching.

```typescript
mcp__smartbear-mcp__swagger_search_apis_and_domains({
  query: string,        // Search term
  owner?: string,       // Filter by organization
  state?: "published" | "unpublished" | "all"
})
```

**Returns**: Array of matching APIs with metadata

### Create or Update API

Publish an updated OpenAPI spec after successful Drift verification.

```typescript
mcp__smartbear-mcp__swagger_create_or_update_api({
  owner: string,
  apiName: string,
  definition: string,   // Full OpenAPI spec as string
  version?: string,     // Default: "1.0.0"
  isPrivate?: boolean
})
```

**Usage**:
```javascript
// After Drift verification passes
await mcp__smartbear-mcp__swagger_create_or_update_api({
  owner: "acme-corp",
  apiName: "products-api",
  definition: JSON.stringify(updatedSpec)
});
```

## Governance Tools

### List Organizations

Get available organizations (required for most operations).

```typescript
mcp__smartbear-mcp__swagger_list_organizations()
```

**Returns**: Array of organization names

**Critical**: Organization names are case-sensitive. Always fetch the list first.

### Scan API Standardization

Validate an OpenAPI spec against governance rules before running Drift tests.

```typescript
mcp__smartbear-mcp__swagger_scan_api_standardization({
  owner: string,
  definition: string,   // OpenAPI spec to validate
  isYaml?: boolean      // Default: false
})
```

**Returns**: Array of validation errors and warnings

**Usage**:
```javascript
// Validate before testing
const issues = await mcp__smartbear-mcp__swagger_scan_api_standardization({
  owner: "acme-corp",
  definition: specContent,
  isYaml: true
});

if (issues.length > 0) {
  console.log("Governance issues found:", issues);
  // Fix issues before proceeding to Drift tests
}
```

### Standardize API

Auto-fix governance violations in an existing SwaggerHub API.

```typescript
mcp__smartbear-mcp__swagger_standardize_api({
  owner: string,
  apiName: string,
  version?: string
})
```

**Returns**: Standardized OpenAPI spec

**Usage**:
```javascript
// Auto-fix governance issues
const standardizedSpec = await mcp__smartbear-mcp__swagger_standardize_api({
  owner: "acme-corp",
  apiName: "products-api"
});

// Now run Drift tests against standardized spec
fs.writeFileSync("openapi.yaml", standardizedSpec);
```

## Portal Documentation Tools

### List Portals

Get available Developer Portals.

```typescript
mcp__smartbear-mcp__swagger_list_portals()
```

**Returns**: Array of portals with IDs and metadata

### List Portal Products

Get all API products in a portal.

```typescript
mcp__smartbear-mcp__swagger_list_portal_products({
  portalId: string      // UUID from list_portals
})
```

**Returns**: Array of products with IDs

### Get Portal Product

Retrieve details of a specific product.

```typescript
mcp__smartbear-mcp__swagger_get_portal_product({
  portalId: string,
  productId: string
})
```

**Returns**: Product metadata including name, description, visibility

### Update Portal Product

Update product metadata after successful Drift verification.

```typescript
mcp__smartbear-mcp__swagger_update_portal_product({
  portalId: string,
  productId: string,
  name?: string,
  slug?: string,
  description?: string,
  visibility?: "public" | "private"
})
```

**Usage**:
```javascript
// Add verification badge to portal
await mcp__smartbear-mcp__swagger_update_portal_product({
  portalId: "portal-uuid",
  productId: "product-uuid",
  description: "Products API - Drift Verified ✓ (100% endpoint coverage)"
});
```

### Publish Portal Product

Publish portal changes to live or preview.

```typescript
mcp__smartbear-mcp__swagger_publish_portal_product({
  portalId: string,
  productId: string,
  preview?: boolean     // Default: false (publish live)
})
```

**Usage**:
```javascript
// Publish to preview first
await mcp__smartbear-mcp__swagger_publish_portal_product({
  portalId: "portal-uuid",
  productId: "product-uuid",
  preview: true
});

// Then publish live after review
await mcp__smartbear-mcp__swagger_publish_portal_product({
  portalId: "portal-uuid",
  productId: "product-uuid",
  preview: false
});
```

### List Portal Product Sections

Get documentation sections for a product.

```typescript
mcp__smartbear-mcp__swagger_list_portal_product_sections({
  portalId: string,
  productId: string,
  embed?: ["tableOfContents"]   // Include TOC in response
})
```

**Returns**: Array of sections with documents and optional TOC

### Update Document

Update documentation content (e.g., add Drift test results).

```typescript
mcp__smartbear-mcp__swagger_update_document({
  portalId: string,
  documentId: string,
  title?: string,
  htmlContent?: string,
  markdownContent?: string
})
```

**Usage**:
```javascript
// Add Drift test results to docs
const driftResults = `
# Contract Testing Results

✓ All 42 endpoints verified against OpenAPI spec
✓ 100% schema coverage
✓ Zero drift detected

Last verified: ${new Date().toISOString()}
`;

await mcp__smartbear-mcp__swagger_update_document({
  portalId: "portal-uuid",
  documentId: "doc-uuid",
  markdownContent: driftResults
});
```

## Table of Contents Tools

### Create Table of Contents

Link SwaggerHub API to portal documentation.

```typescript
mcp__smartbear-mcp__swagger_create_table_of_contents({
  portalId: string,
  sectionId: string,
  title: string,
  type: "apiUrl",
  apiUrl: string        // SwaggerHub API URL
})
```

**Usage**:
```javascript
// Link verified API to portal
await mcp__smartbear-mcp__swagger_create_table_of_contents({
  portalId: "portal-uuid",
  sectionId: "section-uuid",
  title: "Products API Reference",
  type: "apiUrl",
  apiUrl: "https://app.swaggerhub.com/apis/acme-corp/products-api/1.0.0"
});
```

## Workflow Example: Complete Integration

```javascript
// 1. Fetch spec from SwaggerHub
const spec = await mcp__smartbear-mcp__swagger_get_api_definition({
  owner: "acme-corp",
  apiName: "products-api"
});
fs.writeFileSync("openapi.yaml", spec);

// 2. Validate governance
const issues = await mcp__smartbear-mcp__swagger_scan_api_standardization({
  owner: "acme-corp",
  definition: spec,
  isYaml: true
});

if (issues.length > 0) {
  // Auto-fix if possible
  const fixed = await mcp__smartbear-mcp__swagger_standardize_api({
    owner: "acme-corp",
    apiName: "products-api"
  });
  fs.writeFileSync("openapi.yaml", fixed);
}

// 3. Generate Drift tests (using openapi-parser skill)
// ... (AI generates drift.yaml from openapi.yaml)

// 4. Run Drift verification
execSync("drift verify -u https://api.example.com -f drift.yaml");

// 5. Publish results to portal
const portals = await mcp__smartbear-mcp__swagger_list_portals();
const products = await mcp__smartbear-mcp__swagger_list_portal_products({
  portalId: portals[0].id
});

await mcp__smartbear-mcp__swagger_update_portal_product({
  portalId: portals[0].id,
  productId: products[0].id,
  description: "Products API - Drift Verified ✓"
});

await mcp__smartbear-mcp__swagger_publish_portal_product({
  portalId: portals[0].id,
  productId: products[0].id
});
```

## Error Handling

### Organization Not Found

```
Error: Organization 'Acme-Corp' not found
```

**Fix**: Organization names are case-sensitive. Use `list_organizations` to get the exact name.

### API Not Found

```
Error: API 'products-api' not found in organization 'acme-corp'
```

**Fix**: Use `search_apis_and_domains` to verify the API name.

### Authentication Failed

```
Error: Invalid API key
```

**Fix**: Check `SWAGGERHUB_API_KEY` environment variable is set correctly.

### Rate Limiting

```
Error: Rate limit exceeded
```

**Fix**: Wait before retrying. SwaggerHub has rate limits per API key.

## Best Practices

1. **Cache Organization List**: Fetch once at the start of a session
2. **Validate Before Testing**: Always run governance scan before Drift tests
3. **Preview Before Publishing**: Use `preview: true` to test portal changes
4. **Version Control**: Commit OpenAPI specs fetched from SwaggerHub
5. **Error Recovery**: Auto-standardize governance issues before proceeding
6. **Atomic Updates**: Update spec, run tests, and update portal in one workflow
