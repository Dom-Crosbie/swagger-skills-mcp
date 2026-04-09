# Example API Project Structure

This directory shows a sample project structure for an API built with the Smartbear Swagger skill.

## Directory Layout

```
example-api-project/
│
├── src/                           # Source code
│   ├── routes/                    # API route definitions
│   │   ├── products.routes.ts
│   │   ├── orders.routes.ts
│   │   └── index.ts
│   │
│   ├── controllers/               # Business logic
│   │   ├── products.controller.ts
│   │   └── orders.controller.ts
│   │
│   ├── models/                    # Data models
│   │   ├── product.model.ts
│   │   └── order.model.ts
│   │
│   ├── middleware/                # Express middleware
│   │   ├── auth.middleware.ts
│   │   ├── validation.middleware.ts
│   │   └── error.middleware.ts
│   │
│   ├── services/                  # External services
│   │   └── database.service.ts
│   │
│   └── app.ts                     # Express app setup
│
├── specs/                         # OpenAPI specifications
│   ├── openapi.yaml               # Main spec (tracked in git)
│   ├── openapi.dev.yaml           # Development overrides
│   └── openapi.prod.yaml          # Production overrides
│
├── tests/                         # Test suites
│   ├── unit/                      # Unit tests
│   │   ├── controllers/
│   │   └── models/
│   │
│   └── integration/               # Integration tests
│       └── api/
│           ├── products.test.ts
│           └── orders.test.ts
│
├── docs/                          # Additional documentation
│   ├── guides/
│   │   ├── getting-started.md
│   │   └── authentication.md
│   │
│   └── tutorials/
│       └── first-api-call.md
│
├── scripts/                       # Utility scripts
│   ├── validate-spec.sh
│   └── deploy.sh
│
├── .vscode/                       # VS Code configuration
│   ├── SKILL.md                   # Smartbear API skill
│   ├── settings.json
│   └── launch.json
│
├── .github/                       # GitHub configuration
│   └── workflows/
│       ├── api-validation.yml     # CI for spec validation
│       └── deploy.yml             # CD for deployment
│
├── .swagger-config.yml            # Smartbear configuration
├── .gitignore
├── package.json                   # Node.js dependencies
├── tsconfig.json                  # TypeScript config
├── README.md                      # Project documentation
└── CHANGELOG.md                   # Version history
```

## Key Files Explained

### Source Code (`src/`)

**app.ts** - Main application entry point
```typescript
import express from 'express';
import { routes } from './routes';
import { errorMiddleware } from './middleware/error.middleware';

const app = express();

app.use(express.json());
app.use('/api', routes);
app.use(errorMiddleware);

export default app;
```

**routes/products.routes.ts** - Route definitions
```typescript
import { Router } from 'express';
import { ProductController } from '../controllers/products.controller';
import { authMiddleware } from '../middleware/auth.middleware';

const router = Router();
const controller = new ProductController();

router.get('/', controller.list);
router.get('/:id', controller.get);
router.post('/', authMiddleware, controller.create);
router.put('/:id', authMiddleware, controller.update);
router.delete('/:id', authMiddleware, controller.delete);

export default router;
```

### OpenAPI Spec (`specs/openapi.yaml`)

```yaml
openapi: 3.1.0
info:
  title: Products API
  version: 1.0.0
  description: REST API for managing products
  contact:
    name: API Support
    email: api@example.com

servers:
  - url: https://api.example.com/v1
    description: Production server
  - url: https://staging-api.example.com/v1
    description: Staging server

paths:
  /products:
    get:
      summary: List all products
      operationId: listProducts
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: pageSize
          in: query
          schema:
            type: integer
            default: 20
      responses:
        '200':
          description: Successful response
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/Product'
                  pagination:
                    $ref: '#/components/schemas/Pagination'

    post:
      summary: Create a new product
      operationId: createProduct
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/ProductInput'
      responses:
        '201':
          description: Product created
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Product'

components:
  schemas:
    Product:
      type: object
      properties:
        id:
          type: string
          format: uuid
        name:
          type: string
        description:
          type: string
        price:
          type: number
          format: double
        createdAt:
          type: string
          format: date-time

    ProductInput:
      type: object
      required:
        - name
        - price
      properties:
        name:
          type: string
          minLength: 1
          maxLength: 200
        description:
          type: string
        price:
          type: number
          format: double
          minimum: 0

    Pagination:
      type: object
      properties:
        page:
          type: integer
        pageSize:
          type: integer
        totalPages:
          type: integer
        totalItems:
          type: integer

  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
```

### Configuration (`.swagger-config.yml`)

```yaml
organization: "acme-corp"

portal:
  id: "developer-portal"
  defaultProduct: "products-api"
  autoPublish: false

github:
  remote: "origin"
  branch: "main"

api:
  defaultVersion: "1.0.0"
  specFormat: "openapi-3.1.0"
  specDirectory: "./specs"

validation:
  enforceValidation: true
  autoFix: true
```

### CI/CD (`.github/workflows/api-validation.yml`)

```yaml
name: Validate API Spec

on:
  push:
    branches: [main, develop]
    paths:
      - 'specs/**'
  pull_request:
    paths:
      - 'specs/**'

jobs:
  validate:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
      
      - name: Install spectral
        run: npm install -g @stoplight/spectral-cli
      
      - name: Validate OpenAPI Spec
        run: spectral lint specs/openapi.yaml
      
      - name: Check SwaggerHub Sync
        run: |
          # Add SwaggerHub sync check
          echo "Checking if spec is synced with SwaggerHub..."
```

### Project README

```markdown
# Products API

REST API for managing products in the catalog.

## Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn
- SwaggerHub account
- GitHub account

### Installation
```bash
git clone https://github.com/your-org/products-api.git
cd products-api
npm install
```

### Development
```bash
npm run dev
```

### Testing
```bash
npm test
```

## API Documentation

View the full API documentation:
- **SwaggerHub**: https://app.swaggerhub.com/apis/acme-corp/products-api/1.0.0
- **Developer Portal**: https://developer-portal.acme.com/products-api

## Deployment

The API is automatically deployed via GitHub Actions when changes are merged to `main`.

## Contributing

1. Ask Claude to build or update API features
2. Claude will handle validation, standardization, and publishing
3. Review the changes
4. Merge the PR

## License

MIT
```

## How This Works with the Skill

When you ask Claude to:

1. **"Build a products API"**
   - Creates `src/` directory with all code
   - Generates `specs/openapi.yaml`
   - Sets up tests in `tests/`
   - Creates README.md

2. **"Validate the API"**
   - Reads `specs/openapi.yaml`
   - Scans against governance rules
   - Updates spec with fixes
   - Re-validates

3. **"Publish to SwaggerHub"**
   - Reads `.swagger-config.yml` for org name
   - Uses `create_or_update_api` tool
   - Provides SwaggerHub URL

4. **"Update portal documentation"**
   - Reads portal config
   - Lists products and sections
   - Updates or creates documentation
   - Publishes live or to preview

5. **"Push to GitHub"**
   - Stages all changed files
   - Creates commit with SwaggerHub link
   - Pushes to configured branch

## Customization

Modify this structure to fit your needs:
- Change language/framework in `src/`
- Add more spec files in `specs/`
- Customize CI/CD in `.github/workflows/`
- Update configuration in `.swagger-config.yml`

## Next Steps

1. Copy this structure to your new project
2. Update `.swagger-config.yml` with your details
3. Ask Claude: "Build a [your API description]"
4. Watch the magic happen! ✨
