# Troubleshooting & FAQ

Common issues and solutions when using the Smartbear Swagger API skill.

## Table of Contents

- [MCP Server Issues](#mcp-server-issues)
- [Validation Problems](#validation-problems)
- [Portal Issues](#portal-issues)
- [Git & GitHub Issues](#git--github-issues)
- [Skill Activation Issues](#skill-activation-issues)
- [OpenAPI Spec Issues](#openapi-spec-issues)
- [FAQ](#faq)

---

## MCP Server Issues

### ❌ Error: "MCP tools not found" or "Tool not available"

**Cause**: Smartbear MCP tools are not loaded into the current session.

**Solution**:
```
@workspace Load the Smartbear MCP tools
```

Claude will use `tool_search_tool_regex` to load them.

**Prevention**: Tools are loaded automatically when the skill is triggered, but you can pre-load them at the start of a session.

---

### ❌ Error: "MCP server not responding"

**Cause**: The Smartbear MCP server is not running or not configured.

**Solution**:
1. Check if the MCP server is running:
   ```powershell
   # Check running processes (adjust based on how you start the server)
   Get-Process | Where-Object {$_.ProcessName -like "*mcp*"}
   ```

2. Restart the MCP server:
   ```powershell
   # Navigate to your MCP server directory
   cd path\to\smartbear-mcp-server
   # Start the server (adjust command as needed)
   npm start
   ```

3. Verify VS Code MCP configuration:
   - Open Settings (Ctrl+,)
   - Search for "MCP" or "Model Context Protocol"
   - Ensure Smartbear MCP server is listed and enabled

---

### ❌ Error: "Authentication failed" or "Invalid credentials"

**Cause**: MCP server doesn't have valid Smartbear credentials.

**Solution**:
1. Check your MCP server configuration file (usually `.mcprc` or `mcp-config.json`)
2. Ensure you have valid SwaggerHub API key
3. Generate a new API key:
   - Log in to SwaggerHub
   - Go to Settings → API Keys
   - Create new API key
   - Update MCP server config

4. Restart MCP server after updating credentials

---

## Validation Problems

### ⚠️ "Scan returns many validation errors"

**Cause**: This is **normal** for first-time validation. OpenAPI specs often need adjustments to meet organization governance rules.

**Solution**: Claude will automatically:
1. Attempt auto-fix using `standardize_api`
2. If auto-fix unavailable, manually correct issues
3. Re-validate to confirm compliance

**What to do**:
- Review the errors reported
- Let Claude apply fixes
- Verify the changes make sense for your API

---

### ❌ Error: "Organization not found"

**Cause**: Organization name is incorrect or case-sensitive.

**Solution**:
1. Get your exact organization name:
   ```
   @workspace List my Swagger organizations
   ```

2. Update `.swagger-config.yml`:
   ```yaml
   organization: "ExactOrgName"  # Case-sensitive!
   ```

3. Common mistakes:
   - Using display name instead of slug
   - Wrong capitalization
   - Extra spaces

---

### ❌ Error: "Cannot standardize - API not found in SwaggerHub"

**Cause**: Auto-standardization requires the API to already exist in SwaggerHub.

**Solution**: For new APIs, Claude will:
1. Do manual fixes based on scan results
2. Create the API in SwaggerHub first
3. Then use auto-standardization for future updates

**Workaround**: Upload a draft version to SwaggerHub first, then run standardization.

---

## Portal Issues

### ❌ Error: "Portal not found"

**Cause**: Portal ID is incorrect or you don't have access.

**Solution**:
1. List available portals:
   ```
   @workspace Show my Swagger portals
   ```

2. Use the correct format:
   - Subdomain: `"my-portal"` 
   - OR UUID: `"550e8400-e29b-41d4-a716-446655440000"`

3. Verify access:
   - Log in to Swagger Portal UI
   - Check if you can see the portal
   - Verify you have edit permissions

---

### ❌ Error: "Portal product not found"

**Cause**: Product slug or ID is incorrect.

**Solution**:
1. List products in the portal:
   ```
   @workspace List products in portal [portal-id]
   ```

2. Use the exact slug from the results

3. If creating a new product, Claude will do this automatically

---

### ⚠️ Portal updates not appearing

**Cause**: Changes are in draft/preview mode, not published.

**Solution**:
1. Check if `autoPublish` is set in config:
   ```yaml
   portal:
     autoPublish: false  # Change to true for auto-publish
   ```

2. Manually publish:
   ```
   @workspace Publish the [product-name] portal product to live
   ```

3. Or use preview:
   ```
   @workspace Publish [product-name] to preview
   ```

---

## Git & GitHub Issues

### ❌ Error: "Git push rejected" or "Permission denied"

**Cause**: Authentication or branch protection.

**Solution**:
1. Check authentication:
   ```powershell
   git config --list | Select-String "user"
   ```

2. Verify remote:
   ```powershell
   git remote -v
   ```

3. Test connection:
   ```powershell
   git fetch origin
   ```

4. If using HTTPS, update credentials:
   ```powershell
   git credential-manager-core erase
   # Then push again - will prompt for credentials
   ```

5. If using SSH, check SSH keys:
   ```powershell
   ssh -T git@github.com
   ```

---

### ❌ Error: "Updates were rejected because the remote contains work"

**Cause**: Remote branch has changes you don't have locally.

**Solution**:
```powershell
# Pull and rebase
git pull origin main --rebase

# Then push
git push origin main
```

**Prevention**: Always pull before starting new work.

---

### ❌ Error: "Branch protection rules" or "Required status checks"

**Cause**: GitHub branch protection requires PR or passing checks.

**Solution**:
1. Create a feature branch:
   ```powershell
   git checkout -b feature/api-updates
   git push origin feature/api-updates
   ```

2. Create PR on GitHub

3. Or ask Claude to:
   ```
   Create a new branch for these API changes and push to GitHub
   ```

---

## Skill Activation Issues

### ❌ Skill not being used automatically

**Cause**: File location or `applyTo` patterns don't match.

**Solution**:
1. Place `SKILL.md` in correct location:
   - `.vscode/SKILL.md` (recommended)
   - OR `.github/SKILL.md`
   - OR project root

2. Check `applyTo` patterns in YAML frontmatter:
   ```yaml
   applyTo:
     - kind: conversation
       pattern: "(build|create|update).*API"
   ```

3. Explicitly invoke:
   ```
   @workspace /SKILL.md Build a new API for...
   ```

---

### ❌ Claude says "I don't have access to that tool"

**Cause**: Tool restrictions in `allowedTools` or tool not loaded.

**Solution**:
1. Check `allowedTools` in SKILL.md frontmatter
2. Ensure MCP tools are loaded
3. Add missing tools to `allowedTools`:
   ```yaml
   allowedTools:
     - mcp_smartbear-joe_swagger_*
   ```

---

## OpenAPI Spec Issues

### ❌ Error: "Invalid OpenAPI specification"

**Cause**: Syntax errors or invalid schema.

**Solution**:
1. Validate locally:
   ```powershell
   npm install -g @stoplight/spectral-cli
   spectral lint specs/openapi.yaml
   ```

2. Ask Claude to fix:
   ```
   @workspace Validate and fix my OpenAPI spec at specs/openapi.yaml
   ```

3. Common issues:
   - Missing `openapi` version field
   - Invalid `$ref` paths
   - Wrong indentation (YAML)
   - Missing required fields

---

### ⚠️ Spec doesn't match my code

**Cause**: Code and spec are out of sync.

**Solution**:
1. Ask Claude to regenerate spec from code:
   ```
   Generate an OpenAPI spec from my existing API code in src/
   ```

2. Or update code to match spec:
   ```
   Update my API code to match the OpenAPI spec at specs/openapi.yaml
   ```

3. **Prevention**: Always update code and spec together.

---

## FAQ

### Q: How do I test the skill without publishing to production?

**A**: 
1. Use preview mode for portal:
   ```yaml
   portal:
     autoPublish: false  # In .swagger-config.yml
   ```

2. Use a test organization in SwaggerHub

3. Use a feature branch for Git:
   ```
   @workspace Create this API in a feature branch
   ```

---

### Q: Can I use this skill with a non-REST API (GraphQL, gRPC)?

**A**: Currently optimized for REST APIs with OpenAPI specs. For GraphQL:
- Generate GraphQL schema separately
- Use the Git/portal documentation features
- Skip SwaggerHub validation

For gRPC:
- Generate Protocol Buffers
- Document in portal manually
- Use Git workflow only

---

### Q: How do I customize the validation rules?

**A**: Validation rules are set at the organization level in SwaggerHub:
1. Log in to SwaggerHub
2. Go to Organization Settings
3. Configure Governance & Standardization rules
4. Rules apply to all scans automatically

---

### Q: Can I use this with multiple organizations?

**A**: Yes! 
1. Specify organization per project:
   ```yaml
   # .swagger-config.yml
   organization: "project-specific-org"
   ```

2. Or specify at runtime:
   ```
   @workspace Build API for organization "acme-corp"
   ```

---

### Q: How do I handle API versioning?

**A**: 
1. **In spec**: Update `info.version` in OpenAPI spec
2. **In SwaggerHub**: Creates new version automatically
3. **In Git**: Tag releases:
   ```powershell
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

4. **Auto-increment**: Enable in config:
   ```yaml
   api:
     autoIncrement: true
   ```

---

### Q: What if I don't want to use all workflow phases?

**A**: You can skip phases by being explicit:
- **Skip validation**: `Build API but skip validation`
- **Skip portal**: `Build API and upload to SwaggerHub only`
- **Skip SwaggerHub**: `Generate API code and spec only`
- **Skip Git**: `Build API but don't commit to Git`

---

### Q: Can I revert changes if something goes wrong?

**A**: Yes!

**Git**: 
```powershell
git reset --hard HEAD~1  # Undo last commit
git push origin main --force  # Push revert
```

**SwaggerHub**: 
- Use version history in SwaggerHub UI
- Download previous version
- Re-upload using the skill

**Portal**:
- Use portal version history
- Republish previous version

---

### Q: How do I see what the skill is doing?

**A**: Claude will report each step:
1. Code generation
2. Validation scan results
3. Fix attempts
4. Upload status
5. Portal updates
6. Git commits

Watch the conversation for detailed progress.

---

### Q: Performance is slow - how to speed up?

**A**: 
1. **Pre-load MCP tools** at session start
2. **Skip re-validation** if already validated
3. **Use auto-fix** instead of manual corrections
4. **Batch updates** - do multiple API changes together
5. **Simplify specs** - remove unnecessary detail

---

### Q: Can I use this in CI/CD pipelines?

**A**: Not directly (this is an interactive skill for Claude in VS Code). For CI/CD:
1. Extract OpenAPI spec from git
2. Use Smartbear CLI tools or API directly
3. Automate validation in GitHub Actions
4. Use Claude skill for development, CI/CD for deployment

See `PROJECT-STRUCTURE.md` for CI/CD examples.

---

### Q: How do I contribute improvements to the skill?

**A**: 
1. Edit `SKILL.md` directly
2. Test the changes
3. Share with your team
4. Document improvements in comments

The skill is a living document - customize it!

---

## Getting More Help

### In VS Code
Ask Claude directly:
```
Help me debug the Smartbear API workflow
What's going wrong with my API validation?
Show me the last error in detail
```

### Check Logs
1. **VS Code Output**: View → Output → Select "Claude" or "MCP"
2. **MCP Server Logs**: Check server console/log files
3. **SwaggerHub**: Check audit logs in SwaggerHub UI

### Documentation
- [SETUP-GUIDE.md](./SETUP-GUIDE.md) - Complete setup instructions
- [SKILL.md](./SKILL.md) - Workflow details
- [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) - Command reference
- [PROJECT-STRUCTURE.md](./PROJECT-STRUCTURE.md) - Example project

### External Resources
- [SwaggerHub Support](https://support.smartbear.com/swaggerhub/)
- [OpenAPI Specification](https://spec.openapis.org/oas/latest.html)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [VS Code Claude Extension](https://marketplace.visualstudio.com/)

---

## Still Having Issues?

If none of these solutions work:

1. **Restart everything**:
   - Close VS Code
   - Stop MCP server
   - Start MCP server
   - Reopen VS Code

2. **Check versions**:
   - VS Code is up to date
   - Claude extension is latest version
   - MCP server is compatible

3. **Test components individually**:
   - Test MCP server directly
   - Test SwaggerHub API access
   - Test Git operations manually

4. **Ask Claude for diagnosis**:
   ```
   Help me diagnose why the Smartbear skill isn't working. 
   Walk me through each component step by step.
   ```

Good luck! 🚀
