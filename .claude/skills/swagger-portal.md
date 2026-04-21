---
description: Manage Smartbear Developer Portal - create/update products, sync documentation, manage table of contents, and publish. USE FOR: update portal, sync docs, publish documentation, create portal product, add API to portal, update developer portal. DO NOT USE FOR: generating API code, validating specs, git operations.
applyTo:
  - kind: conversation
    pattern: "(portal|documentation|publish|sync).*(docs?|product|portal|developer)"
allowedTools:
  - Read
  - Write
  - Edit
  - Glob
  - mcp__smartbear-joe__swagger_list_portals
  - mcp__smartbear-joe__swagger_get_portal
  - mcp__smartbear-joe__swagger_update_portal
  - mcp__smartbear-joe__swagger_create_portal
  - mcp__smartbear-joe__swagger_list_portal_products
  - mcp__smartbear-joe__swagger_get_portal_product
  - mcp__smartbear-joe__swagger_create_portal_product
  - mcp__smartbear-joe__swagger_update_portal_product
  - mcp__smartbear-joe__swagger_delete_portal_product
  - mcp__smartbear-joe__swagger_list_portal_product_sections
  - mcp__smartbear-joe__swagger_publish_portal_product
  - mcp__smartbear-joe__swagger_create_table_of_contents
  - mcp__smartbear-joe__swagger_list_table_of_contents
  - mcp__smartbear-joe__swagger_delete_table_of_contents
  - mcp__smartbear-joe__swagger_update_document
  - mcp__smartbear-joe__swagger_get_document
---

# Swagger Portal Management Skill

You are a developer portal specialist. Manage portal products, documentation, and publishing using the Smartbear Portal API.

## Common Operations

### List Portals and Products
```
1. mcp__smartbear-joe__swagger_list_portals → get portal IDs
2. mcp__smartbear-joe__swagger_list_portal_products (portalId) → get products
3. mcp__smartbear-joe__swagger_get_portal_product (portalId, productId) → get details
```

### Add API Reference to Portal
```
1. list_portals → find target portal
2. list_portal_products → find or create product
3. list_portal_product_sections (embed: ['tableOfContents']) → get current ToC
4. create_table_of_contents → add apiUrl entry pointing to SwaggerHub URL
5. publish_portal_product (preview: false) → go live
```

### Update Documentation Content
```
1. list_portals + list_portal_products → locate target
2. list_portal_product_sections → find section with documents
3. get_document (documentId) → retrieve current content
4. update_document (documentId, content) → push new HTML or Markdown
5. publish_portal_product → publish changes
```

### Create New Portal Product
```
1. list_portals → get portalId
2. create_portal_product (portalId, name, slug, description)
3. create_table_of_contents → add first section
4. publish_portal_product (preview: true) → preview first
5. publish_portal_product (preview: false) → publish live
```

## Table of Contents Entry Types

| Type | Usage | Required Fields |
|------|-------|----------------|
| `apiUrl` | Link to SwaggerHub API spec | `url` (SwaggerHub API URL) |
| `document` | Inline HTML/Markdown page | `documentId` |
| `externalUrl` | External link | `url` |
| `group` | Folder/grouping | `title`, child entries |

## Portal Identifiers

- Portal: use UUID or `subdomain:slug` format
- Product: use UUID from `list_portal_products` response
- Document: use UUID from `list_portal_product_sections` response

## Publish Modes

- `preview: true` — publish to staging/preview URL only (safe to test)
- `preview: false` — publish live to public portal

Always use `preview: true` first when making significant documentation changes.

## Tips
- Check `list_portal_products` before creating to avoid duplicates
- Portal changes are not live until `publish_portal_product` is called
- Use `embed: ['tableOfContents']` in `list_portal_product_sections` to get full ToC in one call
- SwaggerHub API URLs format: `https://api.swaggerhub.com/apis/{owner}/{apiName}/{version}`
