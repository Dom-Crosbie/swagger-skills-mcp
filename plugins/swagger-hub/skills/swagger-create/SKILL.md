# SwaggerHub API Creation Skill

I'm ready to create a new API in SwaggerHub — either by generating a spec from your natural language description, or by registering an existing OpenAPI file.

## What I Can Help With

- **Generate an API spec from a prompt** using SwaggerHub's AI (`create_api_from_prompt`)
- **Register an existing spec** from a file in your workspace
- **Check for duplicates** before creating to avoid collisions
- **Validate on creation** to catch governance issues immediately
- **Return the SwaggerHub URL** ready to share or link in your portal

## Quick Start

**From a description:**
> "Create a new API in SwaggerHub for a user authentication service with JWT"
> "Generate an OpenAPI spec for a product catalog API with search and pagination"

**From a file:**
> "Register my spec at specs/openapi.yaml in SwaggerHub"
> "Upload the payments API spec to the acme-corp organization"

## Workflow A — From Natural Language

```
1. list_organizations           → get org name
2. create_api_from_prompt       → generate spec from description
3. Review generated spec with user
4. scan_api_standardization     → validate compliance
5. create_or_update_api         → register in SwaggerHub
```

## Workflow B — From Existing File

```
1. Read spec file from provided path
2. list_organizations           → get org name
3. search_apis_and_domains      → check for existing API with same name
4. scan_api_standardization     → validate before upload
5. create_or_update_api         → register/update in SwaggerHub
```

## Writing Effective Prompts for `create_api_from_prompt`

Include these details for best results:

- **Resources** — e.g., "customers", "orders", "products"
- **Operations** — list, get by ID, create, update, delete
- **Auth type** — Bearer JWT, API Key, OAuth2
- **Pagination** — on all list endpoints
- **Error codes** — 404 for not found, 422 for validation errors

**Example:**
> "A REST API for managing customer orders. Resources: customers (CRUD) and orders (CRUD + list by customer). Auth: Bearer JWT. Pagination on all list endpoints. Return 404 for missing resources, 422 for validation errors."

## After Registration

I'll provide:
- SwaggerHub URL: `https://app.swaggerhub.com/apis/{owner}/{apiName}/1.0.0`
- Validation summary (errors, warnings, passes)
- Suggested next steps: add to portal, generate SDK, set up CI/CD webhook

## Notes

- API names must be unique within an organization
- Default version is `1.0.0`
- `create_or_update_api` is idempotent — safe to re-run if the API already exists
