# Smartbear Swagger API Development Skill - Documentation Index

Complete guide to building APIs with Claude Code and Smartbear Swagger integration.

## 📚 Quick Navigation

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **[README.md](./README.md)** | Overview & quick start | Start here |
| **[SETUP-GUIDE.md](./SETUP-GUIDE.md)** | Complete setup instructions | Setting up for first time |
| **[QUICK-REFERENCE.md](./QUICK-REFERENCE.md)** | Commands & shortcuts | Daily reference |
| **[SKILL.md](./SKILL.md)** | Detailed workflow definition | Understanding the workflow |
| **[PROJECT-STRUCTURE.md](./PROJECT-STRUCTURE.md)** | Example project layout | Starting a new project |
| **[TROUBLESHOOTING.md](./TROUBLESHOOTING.md)** | Common issues & solutions | When something goes wrong |
| **[.swagger-config.example.yml](./.swagger-config.example.yml)** | Configuration template | Configuring your project |

## 🚀 Getting Started Path

Follow this path if you're new:

1. **Read**: [README.md](./README.md) - Understand what this skill does
2. **Setup**: [SETUP-GUIDE.md](./SETUP-GUIDE.md) - Install and configure
3. **Reference**: [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) - Learn common commands
4. **Build**: Try your first API with Claude
5. **Troubleshoot**: [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) if needed

## 📖 Document Summaries

### README.md
- **What it is**: Overview of the skill and its capabilities
- **Key sections**: 
  - Features overview
  - Requirements
  - Quick start
  - Example commands
  - MCP tools reference
- **Best for**: Understanding the big picture

### SETUP-GUIDE.md
- **What it is**: Step-by-step installation and configuration guide
- **Key sections**:
  - Prerequisites checklist
  - Installation steps
  - Environment configuration
  - Usage examples with detailed explanations
  - Workflow deep dive
  - Configuration tips
  - Advanced usage patterns
  - Best practices
  - CI/CD integration
- **Best for**: First-time setup and learning the workflow

### QUICK-REFERENCE.md
- **What it is**: Cheat sheet for daily use
- **Key sections**:
  - Common commands
  - Workflow phases table
  - Key MCP tools
  - File locations
  - Configuration snippets
  - Troubleshooting quick fixes
  - Example prompts
- **Best for**: Day-to-day reference

### SKILL.md
- **What it is**: The actual skill file that Claude uses
- **Key sections**:
  - YAML frontmatter (triggers, allowed tools)
  - Complete workflow specification (6 phases)
  - Tool reference
  - Best practices
  - Error handling
  - Example conversation flow
  - When NOT to use the skill
- **Best for**: Understanding how Claude processes API requests
- **Installation**: Place in `.vscode/` or `.github/` directory

### PROJECT-STRUCTURE.md
- **What it is**: Example project layout with sample code
- **Key sections**:
  - Complete directory structure
  - Sample source code files
  - Example OpenAPI spec
  - Configuration files
  - CI/CD workflow examples
  - README template
  - How the skill interacts with each file
- **Best for**: Starting a new project or organizing existing code

### TROUBLESHOOTING.md
- **What it is**: Comprehensive troubleshooting guide
- **Key sections**:
  - MCP server issues
  - Validation problems
  - Portal issues
  - Git & GitHub issues
  - Skill activation issues
  - OpenAPI spec issues
  - FAQ (20+ questions)
  - Getting more help
- **Best for**: Debugging problems and finding solutions

### .swagger-config.example.yml
- **What it is**: Template configuration file
- **Key sections**:
  - Organization settings
  - Portal settings
  - GitHub settings
  - API specification settings
  - Validation settings
  - Code generation preferences
  - Portal publishing settings
- **Best for**: Configuring your specific project
- **Usage**: Copy to `.swagger-config.yml` and customize

## 🎯 Common Scenarios

### Scenario 1: First Time User
**Goal**: Set up and build your first API

1. Read [README.md](./README.md) (5 min)
2. Follow [SETUP-GUIDE.md](./SETUP-GUIDE.md) → Installation Steps (15 min)
3. Ask Claude: "Build a simple health check API"
4. Keep [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) open for commands

### Scenario 2: Experienced User - New Project
**Goal**: Start a new API project

1. Copy structure from [PROJECT-STRUCTURE.md](./PROJECT-STRUCTURE.md)
2. Copy and customize [.swagger-config.example.yml](./.swagger-config.example.yml)
3. Use commands from [QUICK-REFERENCE.md](./QUICK-REFERENCE.md)
4. Reference [SKILL.md](./SKILL.md) for workflow phases

### Scenario 3: Debugging Issues
**Goal**: Fix a problem with the workflow

1. Check [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) → Troubleshooting table
2. Review [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) for detailed solutions
3. Ask Claude: "Help me debug [specific issue]"
4. Check [SETUP-GUIDE.md](./SETUP-GUIDE.md) → Troubleshooting section

### Scenario 4: Team Onboarding
**Goal**: Get team members started

Share these docs in order:
1. [README.md](./README.md) - Overview
2. [SETUP-GUIDE.md](./SETUP-GUIDE.md) - Setup
3. [QUICK-REFERENCE.md](./QUICK-REFERENCE.md) - Daily reference
4. [PROJECT-STRUCTURE.md](./PROJECT-STRUCTURE.md) - Example project

### Scenario 5: Customizing the Workflow
**Goal**: Adapt the skill to your team's process

1. Review [SKILL.md](./SKILL.md) workflow phases
2. Edit SKILL.md to match your process
3. Update [.swagger-config.example.yml](./.swagger-config.example.yml) defaults
4. Test and iterate

## 🔍 Find Information Quickly

### "How do I...?"

| Question | Answer Location |
|----------|-----------------|
| Install the skill? | [SETUP-GUIDE.md](./SETUP-GUIDE.md#installation-steps) |
| Build my first API? | [SETUP-GUIDE.md](./SETUP-GUIDE.md#example-1-create-a-new-api) |
| Configure my organization? | [.swagger-config.example.yml](./.swagger-config.example.yml) |
| Understand the workflow? | [SKILL.md](./SKILL.md#workflow-overview) |
| Fix validation errors? | [TROUBLESHOOTING.md](./TROUBLESHOOTING.md#validation-problems) |
| Structure my project? | [PROJECT-STRUCTURE.md](./PROJECT-STRUCTURE.md) |
| Use common commands? | [QUICK-REFERENCE.md](./QUICK-REFERENCE.md#common-commands) |
| Handle portal issues? | [TROUBLESHOOTING.md](./TROUBLESHOOTING.md#portal-issues) |
| Set up CI/CD? | [PROJECT-STRUCTURE.md](./PROJECT-STRUCTURE.md#cicd-github-workflowsapi-validationyml) |
| Version my APIs? | [TROUBLESHOOTING.md](./TROUBLESHOOTING.md#q-how-do-i-handle-api-versioning) |

### "What is...?"

| Term | Explanation Location |
|------|---------------------|
| The skill workflow | [SKILL.md](./SKILL.md#workflow-overview) |
| MCP server | [SETUP-GUIDE.md](./SETUP-GUIDE.md#1-smartbear-mcp-server-setup) |
| Validation & standardization | [SKILL.md](./SKILL.md#phase-2-validation--standardization) |
| Portal publishing | [SKILL.md](./SKILL.md#phase-5-portal-documentation) |
| OpenAPI spec | [PROJECT-STRUCTURE.md](./PROJECT-STRUCTURE.md#openapi-spec-specsopenapiyaml) |
| Organization governance | [TROUBLESHOOTING.md](./TROUBLESHOOTING.md#q-how-do-i-customize-the-validation-rules) |

### "Where is...?"

| File | Purpose | Location |
|------|---------|----------|
| SKILL.md | Skill definition | Place in `.vscode/` |
| .swagger-config.yml | Project config | Project root |
| openapi.yaml | API specification | `specs/` directory |
| API source code | Implementation | `src/` directory |
| Tests | Test suites | `tests/` directory |

## 📊 Documentation Statistics

| Document | Size | Sections | Best For |
|----------|------|----------|----------|
| README.md | ~600 lines | 15 | Overview |
| SETUP-GUIDE.md | ~800 lines | 18 | Setup & Learning |
| QUICK-REFERENCE.md | ~400 lines | 12 | Daily Use |
| SKILL.md | ~550 lines | 10 | Claude Reference |
| PROJECT-STRUCTURE.md | ~500 lines | 8 | Project Template |
| TROUBLESHOOTING.md | ~700 lines | 20 | Problem Solving |
| .swagger-config.example.yml | ~100 lines | 8 | Configuration |

**Total**: ~3,650 lines of comprehensive documentation

## 🎓 Learning Path

### Beginner (Day 1)
- [ ] Read README.md
- [ ] Complete SETUP-GUIDE.md installation
- [ ] Build first API with Claude
- [ ] Bookmark QUICK-REFERENCE.md

### Intermediate (Week 1)
- [ ] Read full SKILL.md
- [ ] Understand all 6 workflow phases
- [ ] Customize .swagger-config.yml
- [ ] Build 3-5 APIs with different patterns

### Advanced (Month 1)
- [ ] Customize SKILL.md for your team
- [ ] Set up CI/CD integration
- [ ] Create team documentation
- [ ] Establish governance rules

## 🔗 External Resources

- **SwaggerHub**: https://app.swaggerhub.com
- **SwaggerHub Docs**: https://support.smartbear.com/swaggerhub/
- **OpenAPI Spec**: https://spec.openapis.org/oas/latest.html
- **MCP Protocol**: https://modelcontextprotocol.io/
- **VS Code**: https://code.visualstudio.com/
- **Claude**: https://claude.ai/

## 💡 Tips for Using This Documentation

### For Reading
1. **Start with README** - Always begin here
2. **Follow examples** - Try the examples as you read
3. **Use search** - Ctrl+F is your friend
4. **Bookmark key sections** - Keep them open while working

### For Reference
1. **QUICK-REFERENCE** should be your go-to
2. **TROUBLESHOOTING** second when issues arise
3. **SKILL.md** for understanding "why"
4. **PROJECT-STRUCTURE** for "how to organize"

### For Teams
1. **Share README first** - Quick overview
2. **Walk through SETUP-GUIDE** - Hands-on session
3. **Provide QUICK-REFERENCE** - Desk reference
4. **Make TROUBLESHOOTING accessible** - Common problems

## 📝 Giving Feedback

Found an issue or have a suggestion?

1. **Edit the relevant file** - Documentation is code
2. **Test your changes** - Verify they work
3. **Share with team** - Contribute improvements
4. **Keep it updated** - Documentation evolves with usage

## 🎉 You're Ready!

Now that you know where everything is, you can:

1. **Start building** - Ask Claude to build your API
2. **Learn as you go** - Reference docs when needed
3. **Troubleshoot efficiently** - Know where to look
4. **Share with others** - Help your team succeed

## Final Checklist

Before building your first API:

- [ ] MCP server is running
- [ ] SKILL.md is in `.vscode/` directory
- [ ] .swagger-config.yml is configured
- [ ] Git is set up and authenticated
- [ ] SwaggerHub credentials are valid
- [ ] You've read README.md
- [ ] You have QUICK-REFERENCE.md bookmarked

**All set? Ask Claude:** "Build a REST API for [your use case]" 🚀

---

**Last Updated**: April 2026  
**Version**: 1.0.0  
**Maintained by**: Your Team

Happy API building! 🎊
