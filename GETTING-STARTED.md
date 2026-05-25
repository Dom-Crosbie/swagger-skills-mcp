# Getting Started with Swagger Skills

Setup and use the Swagger API development skills in your Claude Code editor.

## Prerequisites

- Claude Code installed (VS Code, Cursor, Windsurf, etc.)
- Git installed and configured
- SwaggerHub account with API key ([Get here](https://app.swaggerhub.com/settings/apiKey))

## Installation

### Option 1: New Project (Recommended)

Clone this repo to get started immediately:

```bash
git clone https://github.com/Dom-Crosbie/swagger-skills-mcp.git
cd swagger-skills-mcp
```

The `.claude/skills/` directory is already configured.

### Option 2: Existing Project

Copy the skills into your existing GitHub project:

**Unix/Mac:**
```bash
mkdir -p .claude/skills
cp -r /path/to/swagger-skills-mcp/.claude/skills/* .claude/skills/
git add .claude/skills/
git commit -m "Add Swagger API development skills"
git push
```

**Windows PowerShell:**
```powershell
New-Item -ItemType Directory -Force -Path .claude\skills
Copy-Item -Recurse C:\path\to\swagger-skills-mcp\.claude\skills\* .claude\skills\
git add .claude\skills\
git commit -m "Add Swagger API development skills"
git push
```

## Configuration

### 1. Get Your API Key

1. Log into [SwaggerHub](https://app.swaggerhub.com)
2. Go to **Settings → API Key**
3. Copy your key

### 2. Configure Claude Code

Edit `~/.claude/settings.json` (create if it doesn't exist):

**Path:**
- **Windows:** `C:\Users\YourUsername\.claude\settings.json`
- **Mac/Linux:** `~/.claude/settings.json`

**Content:**
```json
{
  "mcpServers": {
    "smartbear-joe": {
      "command": "npx",
      "args": ["-y", "@smartbear/smartbear-mcp"],
      "env": {
        "SWAGGERHUB_API_KEY": "your-api-key-here"
      }
    }
  }
}
```

### 3. Restart Claude Code

Close and reopen your editor for changes to take effect.

### 4. Verify Setup

In Claude Code, ask:
```
List my Swagger organizations
```

If you see your organizations listed, you're ready to go! ✅

## How the Skill Works

The skill is **self-learning** and **dynamically adaptive**:

1. **Phase 0 - Learn**: Searches your org for similar APIs and learns their patterns
   - Naming conventions (camelCase? snake_case?)
   - Response structures (how arrays are wrapped)
   - Security schemes (Bearer? API Key?)
   - Documentation style

2. **Phase 1 - Generate**: Creates new API following the patterns it learned
   - No hard-coded rules
   - Matches your org's existing APIs

3. **Phase 2 - Validate & Fix**: Runs governance scan, analyzes errors, fixes them
   - Scans the spec
   - For each error: looks at org's existing APIs to see how to fix it
   - Re-scans until zero errors
   - No manual intervention needed

---

## Sample Prompts

Try these prompts—just specify the **domain**, not the endpoints. The skill will learn from your org's existing APIs.
Copy and paste directly into Claude Code.

### Skill 1: List Your Organizations

**Test that everything is connected:**
```
List my Swagger organizations
```

### Skill 2: Build a Complete API (Full Workflow - Pattern-Based)

**The skill will:**
1. Search your org for similar APIs (rental, booking, inventory, etc.)
2. Learn the patterns from those APIs
3. Generate new API following those patterns
4. Validate and fix until zero governance errors
5. Publish to SwaggerHub + Portal + GitHub

**You just specify the domain:**
```
Build a REST API for a boat rental service
```

Or with more context:
```
Build a REST API for a boat rental company. 
The API should handle boats, reservations, pricing, and customer management.
```

**What you get back:**
- ✅ Node.js/Python API code (with tests)
- ✅ OpenAPI spec (matches your org's patterns, passes governance)
- ✅ Published to SwaggerHub with working URL
- ✅ Portal product documentation with:
  - Getting Started guide (auth, setup)
  - cURL examples for each endpoint (copied from real endpoints)
  - API Reference (linked to SwaggerHub)
- ✅ Live portal URL ready to share
- ✅ Git commit with all code and specs

**No need to:**
- ❌ Specify endpoints (skill learns from similar APIs)
- ❌ Worry about governance rules (skill validates in a loop until zero errors)
- ❌ Create portal docs manually (skill generates from spec)

### Skill 3: Create API from Prompt

**Generate a new API and publish directly to SwaggerHub:**
```
Create a new API in SwaggerHub for a product catalog service with:
- Products endpoint (GET all, GET by ID, POST, PUT, DELETE)
- Categories endpoint (GET all, GET by ID)
- Search endpoint (GET /search?q=term)

Use TypeScript/Node.js and include authentication.
```

### Skill 4: Validate an Existing Spec

**Scan an OpenAPI file for governance violations:**
```
Validate my OpenAPI spec at specs/openapi.yaml against our organization's governance rules.
Scan for any violations and auto-fix if possible.
```

### Skill 5: Update Portal Documentation

**Manage and publish portal product documentation:**
```
Update the portal documentation for the orders API:
- Add a Getting Started guide
- Add authentication examples
- Update the API reference with the latest endpoints
Then publish the changes live.
```

### Skill 6: Validate and Standardize Existing API

**Fix governance violations in an existing SwaggerHub API:**
```
Validate the customer-orders API in SwaggerHub against our governance rules and auto-fix any issues.
```

## What Each Skill Does

| Skill | Use When | Example |
|-------|----------|---------|
| **swagger-api** | Building a new API end-to-end | "Build a REST API for..." |
| **swagger-create** | Creating an API from natural language | "Create a new API in SwaggerHub for..." |
| **swagger-validate** | Checking governance compliance | "Validate my OpenAPI spec against..." |
| **swagger-portal** | Updating portal documentation | "Update the portal docs for..." |

## Full Workflow Checklist

When you ask Claude to "Build a REST API for [domain]", here's what MUST happen:

### Phase 0: Learn from Org ✅
- [ ] Searched for similar APIs in your org
- [ ] Found 3+ example APIs
- [ ] Extracted naming conventions, structure, auth patterns
- [ ] Reported patterns to user

### Phase 1: Generate Code & Spec ✅
- [ ] API code generated (Node.js, Python, etc.)
- [ ] OpenAPI 3.1 spec created
- [ ] Spec follows patterns from Phase 0 (same naming, structure, auth)
- [ ] Examples and descriptions included

### Phase 2: Validate & Fix Loop ✅ (MUST end with zero errors)
- [ ] Initial scan completed
- [ ] For each error:
  - [ ] Analyzed error message
  - [ ] Looked at existing org APIs for pattern
  - [ ] Fixed spec to match pattern
  - [ ] Re-scanned
- [ ] Final scan shows ✅ Zero critical errors
- [ ] All fixes reported to user

### Phase 3: Code Refinement ✅
- [ ] Code updated to match validated spec
- [ ] Code and spec are synchronized

### Phase 4: SwaggerHub Publishing ✅
- [ ] API uploaded to SwaggerHub
- [ ] SwaggerHub URL provided (e.g., https://app.swaggerhub.com/apis/org/api-name)

### Phase 5: Portal Documentation ✅ (CRITICAL)
- [ ] Portal product identified or created
- [ ] **Getting Started** section with setup instructions
- [ ] **API Reference** section linked to SwaggerHub spec
- [ ] **Usage Examples** section with cURL commands for each endpoint
- [ ] **Authentication** section explaining auth
- [ ] Portal **published live** (not preview)
- [ ] Portal URL provided so you can view documentation

### Phase 6: GitHub ✅
- [ ] Code committed with all specs
- [ ] Pushed to repository
- [ ] Commit message includes SwaggerHub URL

## If Portal Documentation Is Missing...

**The workflow is incomplete.** Portal documentation is NOT optional — it makes the API usable.

If Claude doesn't create portal sections with cURL examples and setup guides:
1. Ask explicitly: `Create portal documentation for this API with Getting Started and Usage Examples`
2. Specify what you need: `Add cURL examples for each endpoint and setup instructions`
3. Publish explicitly: `Publish the portal documentation live so users can access it`

## Troubleshooting

### "Skills not loading"
- Verify `.claude/skills/` directory exists and contains `.md` files
- Restart your editor
- Run: `What skills are available?` to trigger discovery

### "MCP tools not found"
- Check API key is correct: `echo $SWAGGERHUB_API_KEY`
- Verify `npx` is installed: `npx --version`
- Restart your editor

### "Organization not found"
- Run: `What are my Swagger organizations?`
- Use the exact organization name (case-sensitive)

### "Settings.json has errors"
- Validate JSON: https://jsonlint.com/
- Check file path is correct for your OS
- Make sure API key has no leading/trailing spaces

### "Git push fails"
- Pull first: `git pull origin main`
- Verify you have push access to the repo
- Check Git credentials: `git config user.name`

## Next Steps

1. ✅ Configure your API key in `~/.claude/settings.json`
2. ✅ Restart Claude Code
3. ✅ Run: `List my Swagger organizations` to verify
4. ✅ Try one of the sample prompts above
5. 📖 See `SKILL.md` for detailed skill documentation

## Reference

- **SKILL.md** — Complete skill definitions and workflow details
- **SwaggerHub API Key:** https://app.swaggerhub.com/settings/apiKey
- **OpenAPI Spec:** https://spec.openapis.org/
- **Claude Code:** https://claude.com/claude-code

---

**Ready?** Open Claude Code and try: `List my Swagger organizations` 🚀
