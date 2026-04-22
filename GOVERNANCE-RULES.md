# SPSCommerce API Governance Rules

These are the critical rules that ALL generated OpenAPI specs must follow. Use this as a reference when generating and fixing specs.

## Critical Rules (MUST HAVE - Zero Tolerance)

### 1. Security/Authorization
**Rule**: Every API MUST have a security scheme defined at the root level.

**Implementation**:
```yaml
components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      
security:
  - bearerAuth: []
```

**Error**: "Missing Authorization - Security field MUST be present at root"

---

### 2. Naming Convention - camelCase Required
**Rule**: All parameter names, property names, and field names MUST use camelCase (never snake_case).

**Incorrect** ❌:
```yaml
parameters:
  - name: start_date
  - name: price_range
properties:
  price_per_day:
  boat_id:
```

**Correct** ✅:
```yaml
parameters:
  - name: startDate
  - name: priceRange
properties:
  pricePerDay:
  boatId:
```

**Errors**: 
- "Query Parameter Naming - parameters use snake_case instead of camelCase"
- "Invalid Parameter Characters - parameters contain underscores"
- "Property Name Casing - properties must use camelCase consistently"

---

### 3. Response Structure - No Bare Arrays
**Rule**: Endpoints returning lists MUST wrap the array in an object with a `data` property.

**Incorrect** ❌:
```yaml
responses:
  '200':
    content:
      application/json:
        schema:
          type: array
          items:
            $ref: '#/components/schemas/Boat'
```

**Correct** ✅:
```yaml
responses:
  '200':
    content:
      application/json:
        schema:
          type: object
          properties:
            data:
              type: array
              items:
                $ref: '#/components/schemas/Boat'
            paging:
              type: object
              properties:
                total: 
                  type: integer
                limit:
                  type: integer
                offset:
                  type: integer
```

**Error**: "Invalid Response Bodies - Response bodies from array-type endpoints must be objects, not arrays"

---

### 4. Query Parameters - camelCase & Optional
**Rule**: Query parameters must use camelCase and most should be optional.

**Incorrect** ❌:
```yaml
parameters:
  - name: start_date
    required: true
  - name: price_range
    required: true
```

**Correct** ✅:
```yaml
parameters:
  - name: startDate
    required: false
  - name: priceRange
    required: false
  - name: limit
    required: false
  - name: offset
    required: false
```

**Errors**:
- "Query Parameter Naming - Parameters use snake_case"
- "Required Query Parameters - date parameters marked as required but MUST be optional"

---

### 5. Type Constraints Required
**Rule**: Every string property must have `maxLength`. Every integer must have `format`.

**Incorrect** ❌:
```yaml
properties:
  name:
    type: string
  boatId:
    type: integer
  age:
    type: integer
```

**Correct** ✅:
```yaml
properties:
  name:
    type: string
    maxLength: 255
  boatId:
    type: string
    format: uuid
  age:
    type: integer
    format: int32
    maximum: 150
```

**Errors**:
- "String Limits - String properties must specify maxLength, enum, or const"
- "Integer Format - Integer properties must specify format (int32 or int64)"
- "ID Type - IDs should be string type, not integer"

---

### 6. ID Fields - String Type Only
**Rule**: All ID fields (`boatId`, `reservationId`, `customerId`, etc.) must be `type: string` and typically `format: uuid`.

**Incorrect** ❌:
```yaml
boatId:
  type: integer
customerId:
  type: integer
reservationId:
  type: integer
```

**Correct** ✅:
```yaml
boatId:
  type: string
  format: uuid
customerId:
  type: string
  format: uuid
reservationId:
  type: string
  format: uuid
```

**Error**: "ID Type - IDs should be string type, not integer"

---

## Important Rules (SHOULD HAVE - Warnings)

### 7. Operation Documentation
**Rule**: Every operation (GET, POST, PUT, DELETE) MUST have:
- A non-empty `description` explaining what it does
- A `tags` array for organization

**Example**:
```yaml
get:
  operationId: listBoats
  summary: List all available boats
  description: Retrieve a paginated list of all boats available for rental
  tags:
    - Boats
```

**Errors**:
- "Missing Operation Descriptions - Every operation needs a non-empty description field"
- "Missing Operation Tags - Every operation needs a non-empty tags array"

---

### 8. Error Response Documentation
**Rule**: Every endpoint must document a 500 error response.

**Example**:
```yaml
responses:
  '200':
    description: Success
  '400':
    description: Bad request
  '500':
    description: Internal server error
```

**Error**: "Missing 500 Responses - Every endpoint should document a 500 error response"

---

### 9. Pagination for Collection Endpoints
**Rule**: GET endpoints that return lists should support pagination via query parameters.

**Required parameters**:
- `limit` (int32, default 20, max 100)
- `offset` (int32, default 0)

**Alternative**: Use `cursor` based pagination.

**Example**:
```yaml
parameters:
  - name: limit
    in: query
    required: false
    schema:
      type: integer
      format: int32
      default: 20
      maximum: 100
  - name: offset
    in: query
    required: false
    schema:
      type: integer
      format: int32
      default: 0
```

**Error**: "Missing Pagination - Collection GET endpoints should support pagination"

---

### 10. HTTP Status Codes
**Rule**: Use correct status codes for operations:
- GET → 200 (OK)
- POST → 201 (Created)
- PUT → 202 (Accepted) or 204 (No Content) - NOT 200/201
- DELETE → 204 (No Content)
- PATCH → 200 (OK)

**Incorrect** ❌:
```yaml
put:
  responses:
    '200':
      description: Updated
    '201':
      description: Created
```

**Correct** ✅:
```yaml
put:
  responses:
    '202':
      description: Update accepted
    '204':
      description: Update completed
```

**Error**: "Invalid PUT Status Codes - PUT operations should use 202 or 204, not 200/201"

---

### 11. Domain Standard
**Rule**: APIs should be under the `api.spscommerce.com` domain.

**Example**:
```yaml
servers:
  - url: https://api.spscommerce.com/boat-rental/v1
    description: Production
```

**Warning**: "Domain Recommendation - APIs SHOULD be under api.spscommerce.com"

---

## Quick Fix Checklist

When you see governance errors, use this checklist:

- [ ] **Authorization defined?** Add `securitySchemes` + `security` at root
- [ ] **All params camelCase?** Replace start_date → startDate, price_range → priceRange
- [ ] **No underscores?** Remove underscores from all names
- [ ] **Array responses wrapped?** Use `{ data: [...] }` not bare `[...]`
- [ ] **Optional date params?** Mark required: false for dates
- [ ] **Properties camelCase?** boatId, pricePerDay (not boat_id, price_per_day)
- [ ] **String maxLength?** Every string property has maxLength
- [ ] **Integer format?** Every integer has format: "int32" or "int64"
- [ ] **IDs are strings?** All ID fields are type: string, not integer
- [ ] **Descriptions on operations?** Every GET/POST/PUT/DELETE has description
- [ ] **Tags on operations?** Every operation has tags: [...]
- [ ] **500 responses documented?** Every endpoint has 500 error response
- [ ] **Pagination on collections?** GET list endpoints have limit/offset parameters

---

## Example: Boat Rental API (Correct Implementation)

```yaml
openapi: 3.1.0
info:
  title: Boat Rental API
  version: 1.0.0
  description: API for managing boat rentals
  contact:
    name: API Support

servers:
  - url: https://api.spscommerce.com/boat-rental/v1

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
  
  schemas:
    Boat:
      type: object
      properties:
        boatId:
          type: string
          format: uuid
        name:
          type: string
          maxLength: 255
        pricePerDay:
          type: number
          format: float
        capacity:
          type: integer
          format: int32
      required:
        - boatId
        - name
        - pricePerDay

security:
  - bearerAuth: []

paths:
  /boats:
    get:
      operationId: listBoats
      summary: List boats
      description: Retrieve a paginated list of boats available for rental
      tags:
        - Boats
      parameters:
        - name: limit
          in: query
          required: false
          schema:
            type: integer
            format: int32
            default: 20
        - name: offset
          in: query
          required: false
          schema:
            type: integer
            format: int32
            default: 0
      responses:
        '200':
          description: List of boats
          content:
            application/json:
              schema:
                type: object
                properties:
                  data:
                    type: array
                    items:
                      $ref: '#/components/schemas/Boat'
                  paging:
                    type: object
                    properties:
                      total:
                        type: integer
                      limit:
                        type: integer
                      offset:
                        type: integer
        '500':
          description: Internal server error
```

---

## When Generating Specs

Before you generate ANY OpenAPI spec, keep these rules in mind:
1. Start with the security scheme
2. Use camelCase EVERYWHERE (parameters, properties, tags)
3. Wrap array responses in `{ data: [...] }` objects
4. Add descriptions and tags to every operation
5. Specify constraints for all types (maxLength, format, etc.)
6. Include pagination on collection GETs
7. Use correct status codes (202/204 for PUT, not 200/201)
8. Never use underscores in names

**If a spec doesn't follow these rules, it WILL fail governance validation.**
