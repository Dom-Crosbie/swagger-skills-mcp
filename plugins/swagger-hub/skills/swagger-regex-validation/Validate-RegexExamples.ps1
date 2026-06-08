# Validate-RegexExamples.ps1
# Validates that OpenAPI spec examples match their schema regex patterns
#
# Usage:
#   .\Validate-RegexExamples.ps1 -SpecPath "openapi.yaml"
#   .\Validate-RegexExamples.ps1 -SpecPath "openapi.yaml" -Verbose
#
# Requires: powershell-yaml module
#   Install-Module -Name powershell-yaml -Scope CurrentUser

param(
    [Parameter(Mandatory=$true)]
    [string]$SpecPath,
    
    [switch]$FailOnError
)

# Check if powershell-yaml is installed
if (-not (Get-Module -ListAvailable -Name powershell-yaml)) {
    Write-Warning "powershell-yaml module not found. Installing..."
    Install-Module -Name powershell-yaml -Scope CurrentUser -Force
}

Import-Module powershell-yaml

# Read and parse the spec
$specContent = Get-Content -Path $SpecPath -Raw
$spec = ConvertFrom-Yaml $specContent

Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "   Regex Pattern Validation for OpenAPI Examples               " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Spec: $SpecPath" -ForegroundColor White
Write-Host "Title: $($spec.info.title)" -ForegroundColor White
Write-Host "Version: $($spec.info.version)" -ForegroundColor White
Write-Host ""

$errors = @()
$warnings = @()
$passed = @()

# Check schemas in components
if ($spec.components -and $spec.components.schemas) {
    foreach ($schemaName in $spec.components.schemas.Keys) {
        $schema = $spec.components.schemas[$schemaName]
        
        # Check if schema has both pattern and example
        if ($schema.pattern -and $schema.example) {
            $pattern = $schema.pattern
            $example = $schema.example.ToString()
            
            try {
                $regex = [regex]::new($pattern)
                $match = $regex.Match($example)
                
                if ($match.Success -and $match.Value -eq $example) {
                    $passed += @{
                        Schema = $schemaName
                        Pattern = $pattern
                        Example = $example
                    }
                    Write-Host "[PASS] " -ForegroundColor Green -NoNewline
                    Write-Host "$schemaName" -ForegroundColor White
                    Write-Host "   Pattern: $pattern" -ForegroundColor DarkGray
                    Write-Host "   Example: $example -> VALID" -ForegroundColor Green
                    Write-Host ""
                } else {
                    $errors += @{
                        Schema = $schemaName
                        Pattern = $pattern
                        Example = $example
                        Issue = "Example does not match pattern"
                    }
                    Write-Host "[FAIL] " -ForegroundColor Red -NoNewline
                    Write-Host "$schemaName" -ForegroundColor White
                    Write-Host "   Pattern: $pattern" -ForegroundColor DarkGray
                    Write-Host "   Example: $example -> INVALID" -ForegroundColor Red
                    Write-Host ""
                }
            } catch {
                $warnings += @{
                    Schema = $schemaName
                    Pattern = $pattern
                    Issue = "Invalid regex pattern: $($_.Exception.Message)"
                }
                Write-Host "[WARN] " -ForegroundColor Yellow -NoNewline
                Write-Host "$schemaName" -ForegroundColor White
                Write-Host "   Pattern: $pattern" -ForegroundColor DarkGray
                Write-Host "   Issue: Invalid regex pattern" -ForegroundColor Yellow
                Write-Host ""
            }
        } elseif ($schema.pattern -and -not $schema.example) {
            $warnings += @{
                Schema = $schemaName
                Pattern = $schema.pattern
                Issue = "Schema has pattern but no example to validate"
            }
            Write-Verbose "[WARN] $schemaName has pattern but no example"
        }
        
        # Also check properties within object schemas
        if ($schema.properties) {
            foreach ($propName in $schema.properties.Keys) {
                $prop = $schema.properties[$propName]
                if ($prop.pattern -and $prop.example) {
                    $pattern = $prop.pattern
                    $example = $prop.example.ToString()
                    
                    try {
                        $regex = [regex]::new($pattern)
                        $match = $regex.Match($example)
                        
                        $fullName = $schemaName + "." + $propName
                        if ($match.Success -and $match.Value -eq $example) {
                            $passed += @{
                                Schema = $fullName
                                Pattern = $pattern
                                Example = $example
                            }
                        } else {
                            $errors += @{
                                Schema = $fullName
                                Pattern = $pattern
                                Example = $example
                                Issue = "Example does not match pattern"
                            }
                            Write-Host "[FAIL] " -ForegroundColor Red -NoNewline
                            Write-Host $fullName -ForegroundColor White
                            Write-Host "   Pattern: $pattern" -ForegroundColor DarkGray
                            Write-Host "   Example: $example -> INVALID" -ForegroundColor Red
                            Write-Host ""
                        }
                    } catch {
                        # Regex error handled
                    }
                }
            }
        }
    }
}

# Summary
Write-Host ""
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host "                         SUMMARY                                " -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Patterns Checked: $($passed.Count + $errors.Count)" -ForegroundColor White
Write-Host "[PASS] Passed: $($passed.Count)" -ForegroundColor Green
Write-Host "[FAIL] Failed: $($errors.Count)" -ForegroundColor $(if ($errors.Count -gt 0) { "Red" } else { "Green" })
Write-Host "[WARN] Warnings: $($warnings.Count)" -ForegroundColor $(if ($warnings.Count -gt 0) { "Yellow" } else { "Green" })

if ($errors.Count -gt 0) {
    Write-Host ""
    Write-Host "[FAIL] VALIDATION FAILED" -ForegroundColor Red
    Write-Host "The following examples do not match their patterns:" -ForegroundColor Red
    Write-Host ""
    
    foreach ($err in $errors) {
        Write-Host "  - $($err.Schema)" -ForegroundColor Red
        Write-Host "    Pattern:  $($err.Pattern)" -ForegroundColor DarkGray
        Write-Host "    Example:  $($err.Example)" -ForegroundColor DarkGray
    }
    
    if ($FailOnError) {
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "[PASS] ALL EXAMPLES MATCH THEIR PATTERNS" -ForegroundColor Green
}

# Return results object for pipeline usage
return @{
    Passed = $passed
    Errors = $errors
    Warnings = $warnings
    TotalChecked = $passed.Count + $errors.Count
    Success = $errors.Count -eq 0
}
