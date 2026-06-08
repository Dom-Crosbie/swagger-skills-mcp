---
name: swagger-regex-validation
description: "Validates OpenAPI spec examples against regex patterns defined in schemas. Tests that example values match their schema pattern constraints (e.g., ISO country codes, LEI, BIC). USE FOR: regex validation, pattern validation, example validation, ISO compliance, financial identifier validation, CountryAlpha2Code, LEI, BIC validation."
allowedTools:
  - read_file
  - replace_string_in_file
  - create_file
  - grep_search
  - file_search
  - semantic_search
  - mcp_smartbear-joe_swagger_*
---

# Regex Pattern Validation for OpenAPI Examples

Validates that example values in OpenAPI specs match their schema's regex `pattern` constraints. This addresses the gap where Spectral-style validation isn't built into Swagger Studio live editing.

## Problem Statement

When schemas define regex patterns, the examples should match those patterns. For instance:

```yaml
CountryAlpha2Code:
  pattern: '^[A-Z]{2}$'
  type: string
  example: CH    # ✅ Valid - matches pattern
  
CountryAlpha2Code:
  pattern: '^[A-Z]{2}$'
  type: string
  example: X     # ❌ Invalid - only 1 character
```

Currently, there's no live editor validation for this in Swagger Studio. This skill provides a **pipeline-based approach** to catch these violations.

## Supported Pattern Types

| Schema Type | Pattern | Description | Valid Example |
|-------------|---------|-------------|---------------|
| `CountryAlpha2Code` | `^[A-Z]{2}$` | ISO 3166-1 Alpha-2 country codes | `CH`, `US`, `GB` |
| `LeiType` | `^[A-Z0-9]{18}[0-9]{2}$` | ISO 17442:2019 Legal Entity Identifier | `529900W18LQJJN6SJ336` |
| `AnyBicType` | `^[A-Z0-9]{4}[A-Z]{2}(?!00)[A-Z0-9]{2}([A-Z0-9]{3})?$` | ISO 9362:2014 Business Identifier Code | `CITIUS33XXX` |

## Workflow

### Option 1: Scan Against Governance Rules

If your organization has custom standardization rules that enforce example validation:

```
1. mcp__smartbear-joe__swagger_list_organizations  → get org name
2. mcp__smartbear-joe__swagger_scan_api_standardization → scan spec
3. Review violations related to examples not matching patterns
4. Fix violations in spec
5. Re-scan to confirm compliance
```

### Option 2: Direct Pattern Validation Script

For specs not yet in SwaggerHub, or when governance rules don't cover example validation:

```powershell
# PowerShell validation script
$spec = Get-Content "openapi.yaml" | ConvertFrom-Yaml

foreach ($schemaName in $spec.components.schemas.Keys) {
    $schema = $spec.components.schemas[$schemaName]
    if ($schema.pattern -and $schema.example) {
        $regex = [regex]::new($schema.pattern)
        if (-not $regex.IsMatch($schema.example)) {
            Write-Warning "❌ Schema '$schemaName': example '$($schema.example)' does not match pattern '$($schema.pattern)'"
        }
    }
}
```

### Option 3: AI-Powered Auto-Fix

For specs already in SwaggerHub:

```
1. mcp__smartbear-joe__swagger_standardize_api → AI auto-corrects invalid examples
2. Review suggested fixes
3. Validate corrected spec
```

## Test Cases

### Test Case 1: Invalid Country Code
```yaml
# Input
CountryAlpha2Code:
  pattern: '^[A-Z]{2}$'
  example: "CHE"  # 3 characters - invalid

# Expected Error
Schema 'CountryAlpha2Code': example 'CHE' does not match pattern '^[A-Z]{2}$'
Pattern requires exactly 2 uppercase letters
```

### Test Case 2: Invalid LEI
```yaml
# Input
LeiType:
  pattern: '^[A-Z0-9]{18}[0-9]{2}$'
  example: "INVALID"

# Expected Error
Schema 'LeiType': example 'INVALID' does not match pattern '^[A-Z0-9]{18}[0-9]{2}$'
Pattern requires 18 alphanumeric characters followed by 2 digits
```

### Test Case 3: Invalid BIC (fails negative lookahead)
```yaml
# Input
AnyBicType:
  pattern: '^[A-Z0-9]{4}[A-Z]{2}(?!00)[A-Z0-9]{2}([A-Z0-9]{3})?$'
  example: "CITIUS00XXX"  # Contains "00" which is disallowed

# Expected Error
Schema 'AnyBicType': example 'CITIUS00XXX' does not match pattern
The 7th-8th characters cannot be "00" per ISO 9362
```

## Demo API Reference

A demo API showcasing these patterns is available in SwaggerHub:

**ChrisDemo API**: `domcrosbie-cc0/ChrisDemo/1.0.0`

URL: https://app.swaggerhub.com/apis/domcrosbie-cc0/ChrisDemo/1.0.0

This API includes:
- `/validate/country` - Country code validation endpoint
- `/validate/lei` - LEI validation endpoint  
- `/validate/bic` - BIC validation endpoint
- `/financial/entity` - Financial entity CRUD with all pattern types

## Integration with Spectral

This skill complements existing Spectral workflows:

| Approach | When to Use |
|----------|-------------|
| **Spectral (local)** | Live editor feedback during development |
| **Swagger Studio Scan** | Pipeline validation on save/publish |
| **AI Standardization** | Auto-fix when publishing to SwaggerHub |

**Recommendation**: Keep Spectral for live local validation. Add Swagger Studio governance scan as a secondary check to catch issues even when developers forget to run Spectral.

## Adding Custom Regex Rules to Governance

To add your organization's regex validation rules to SwaggerHub governance:

1. Navigate to Organization Settings → Standardization
2. Add custom rules for pattern validation
3. Reference the patterns your organization uses
4. Scan APIs against updated governance rules

## Output Format

```
Regex Pattern Validation Results
================================
Spec: ChrisDemo v1.0.0
Organization: domcrosbie-cc0

Schema Patterns Checked: 3

✅ CountryAlpha2Code
   Pattern: ^[A-Z]{2}$
   Example: "CH" → VALID

✅ LeiType  
   Pattern: ^[A-Z0-9]{18}[0-9]{2}$
   Example: "529900W18LQJJN6SJ336" → VALID

✅ AnyBicType
   Pattern: ^[A-Z0-9]{4}[A-Z]{2}(?!00)[A-Z0-9]{2}([A-Z0-9]{3})?$
   Example: "CITIUS33XXX" → VALID

All examples match their schema patterns.
```

## Notes

- Regex patterns in OpenAPI use ECMA-262 (JavaScript) regex syntax
- Some patterns include lookaheads (e.g., `(?!00)`) that require careful validation
- Always test edge cases: minimum/maximum length, special characters, case sensitivity
- Consider adding `x-examples` for multiple valid/invalid test cases per schema
