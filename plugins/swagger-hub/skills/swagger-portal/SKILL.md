# SwaggerHub Developer Portal Skill

I'm ready to manage your Smartbear Developer Portal — create products, update documentation, manage table of contents, and publish live or to preview.

## What I Can Help With

- **List portals and products** to find the right target
- **Create new portal products** for new API surfaces
- **Add API references** linking directly to SwaggerHub specs
- **Update guide and tutorial content** with HTML or Markdown
- **Manage table of contents** structure and ordering
- **Publish to preview or live** with a single command

## Quick Start

> "Update the portal documentation for the payments API"
> "Add the orders API reference to the developer portal"
> "Publish the customer portal product to preview"
> "Create a new portal product for the analytics API"

## Common Operations

### Add an API Reference to the Portal
```
1. list_portals           → get portal ID
2. list_portal_products   → find or create product
3. list_portal_product_sections (embed: tableOfContents)
4. create_table_of_contents → type: apiUrl, url: SwaggerHub URL
5. publish_portal_product  → preview: false (live)
```

### Update a Documentation Page
```
1. list_portals + list_portal_products → locate target
2. list_portal_product_sections        → find document section
3. get_document                        → fetch current content
4. update_document                     → push new HTML/Markdown
5. publish_portal_product              → publish changes
```

### Create a New Product
```
1. list_portals                   → get portalId
2. create_portal_product          → name, slug, description
3. create_table_of_contents       → add first section
4. publish_portal_product         → preview: true first, then false
```

## Table of Contents Entry Types

| Type | When to Use | Key Field |
|------|-------------|-----------|
| `apiUrl` | Link to SwaggerHub spec | `url` → SwaggerHub API URL |
| `document` | Inline HTML/Markdown page | `documentId` |
| `externalUrl` | External resource link | `url` |
| `group` | Folder grouping | `title` + child entries |

## SwaggerHub API URL Format
```
https://api.swaggerhub.com/apis/{owner}/{apiName}/{version}
```

## Publish Modes

| Mode | Effect |
|------|--------|
| `preview: true` | Staging only — safe to test |
| `preview: false` | Live public portal |

Always use `preview: true` first for significant changes.

## Tools Reference

```
mcp__smartbear-mcp__swagger_list_portals
mcp__smartbear-mcp__swagger_get_portal
mcp__smartbear-mcp__swagger_create_portal
mcp__smartbear-mcp__swagger_update_portal
mcp__smartbear-mcp__swagger_list_portal_products
mcp__smartbear-mcp__swagger_get_portal_product
mcp__smartbear-mcp__swagger_create_portal_product
mcp__smartbear-mcp__swagger_update_portal_product
mcp__smartbear-mcp__swagger_delete_portal_product
mcp__smartbear-mcp__swagger_list_portal_product_sections
mcp__smartbear-mcp__swagger_publish_portal_product
mcp__smartbear-mcp__swagger_list_table_of_contents
mcp__smartbear-mcp__swagger_create_table_of_contents
mcp__smartbear-mcp__swagger_delete_table_of_contents
mcp__smartbear-mcp__swagger_get_document
mcp__smartbear-mcp__swagger_update_document
```
