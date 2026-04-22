# Steering: Sync Developer Portal Documentation

Use this guide when the user asks to update, sync, or publish portal documentation.

## When to Use This Guide

- Adding a new API reference to an existing portal product
- Updating a guide or tutorial page content
- Creating a new portal product for a new API surface
- Publishing staged portal changes to go live

## Step-by-Step

### 1. Discover Portal Structure
```
portals = mcp__smartbear-joe__swagger_list_portals()
```
If multiple portals, ask the user which one. If none exist, inform the user that portal setup is required first (create via SwaggerHub UI or `create_portal`).

### 2. Find the Target Product
```
products = mcp__smartbear-joe__swagger_list_portal_products(portalId)
```
Match against the user's intent. If no matching product exists, use `create_portal_product`.

### 3. Inspect Current Structure
```
sections = mcp__smartbear-joe__swagger_list_portal_product_sections(
  portalId, productId, embed: ['tableOfContents']
)
```
This returns all sections and their current ToC entries in one call.

### 4a. Add an API Reference
```
mcp__smartbear-joe__swagger_create_table_of_contents(
  portalId, productId, sectionId,
  { type: 'apiUrl', title: 'API Reference', url: swaggerHubApiUrl }
)
```
SwaggerHub API URL format: `https://api.swaggerhub.com/apis/{owner}/{apiName}/{version}`

### 4b. Update a Documentation Page
```
doc = mcp__smartbear-joe__swagger_get_document(documentId)
mcp__smartbear-joe__swagger_update_document(documentId, newContent)
```
Content can be HTML or Markdown. Confirm the content type with the user.

### 5. Preview Before Publishing
```
mcp__smartbear-joe__swagger_publish_portal_product(portalId, productId, preview: true)
```
Provide the preview URL to the user for review.

### 6. Publish Live
```
mcp__smartbear-joe__swagger_publish_portal_product(portalId, productId, preview: false)
```
Only publish live after the user confirms the preview looks correct.

## Common Pitfalls

- **Duplicate products**: Always check `list_portal_products` before creating
- **Wrong section**: Use `list_portal_product_sections` to find the right section ID for ToC entries
- **Portal ID format**: Can be UUID or `subdomain:slug` — use whichever the list call returns
- **Changes not visible**: Portal changes require an explicit publish step — they are not auto-published
