# SwaggerHub Governance Validation Skill

I'm ready to validate your OpenAPI spec against your organization's governance rules and fix any violations.

## What I Can Help With

- **Scan any OpenAPI spec** against your organization's governance standards
- **Report errors and warnings** clearly with remediation guidance
- **Auto-standardize** specs already published to SwaggerHub
- **Manually fix** naming, descriptions, examples, security, and error responses
- **Re-validate** to confirm full compliance before publishing

## Quick Start

**Point me at your spec:**

> "Validate my OpenAPI spec at specs/openapi.yaml"
> "Scan the orders API against Smartbear governance rules"
> "Check if my spec is compliant before I publish"

## Workflow

```
1. mcp__smartbear-mcp__swagger_list_organizations       → get org name
2. Read spec file (from path or search common locations)
3. mcp__smartbear-mcp__swagger_scan_api_standardization → scan for violations
4. mcp__smartbear-mcp__swagger_standardize_api          → auto-fix (if published)
5. Re-scan to verify compliance
```

## Common Violations & Fixes

| Violation | Fix |
|-----------|-----|
| Missing `description` | Add to operations, parameters, schemas |
| Naming convention | Rename to camelCase/kebab-case per org standard |
| Missing `examples` | Add `example` values to schema properties |
| Missing `operationId` | Add unique IDs to each operation |
| No security scheme | Define and apply Bearer/ApiKey/OAuth2 |
| Missing error responses | Add 400, 401, 404, 422, 500 responses |
| No contact info | Add `info.contact` block |

## Output Format

```
Scan Results for: orders-api
Organization: acme-corp

❌ Errors (must fix):
  1. /paths/~1orders/get - Missing operationId
  2. /components/schemas/Order - Missing description

⚠️  Warnings (should fix):
  1. /info - Missing contact.email

✅ Passed: 47 checks

→ Applied auto-fix via standardize_api
✅ All violations resolved. Spec is compliant with acme-corp standards.
```

## Notes

- Organization names are **case-sensitive** — always fetch from `list_organizations`
- Auto-standardize only works for APIs **already published** to SwaggerHub
- Run a scan before every publish to catch issues early
