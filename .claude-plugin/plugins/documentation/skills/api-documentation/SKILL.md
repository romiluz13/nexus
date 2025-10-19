---
name: API Documentation
description: |
  Generate comprehensive API documentation including endpoints, parameters, responses,
  and examples. Support OpenAPI/Swagger, JSDoc, and Markdown formats. Activate when
  user needs API docs or endpoint documentation.
allowed-tools: Read, Write, Edit, Grep, Glob
---

# API Documentation

## Purpose

Create accurate, comprehensive API documentation by analyzing route definitions, schemas, and request/response patterns. Generate OpenAPI specs, endpoint guides, and integration examples.

## When to Activate

**Trigger Keywords:**
- "document API"
- "API docs"
- "endpoint documentation"
- "OpenAPI spec"
- "Swagger docs"

**Examples:**
- "Generate API documentation"
- "Document these REST endpoints"
- "Create OpenAPI specification"

## Documentation Formats

### Format 1: OpenAPI 3.0 (Preferred)

**When to Use:** RESTful APIs, standard HTTP services

**Structure:**
```yaml
openapi: 3.0.0
info:
  title: [API Name]
  version: [Version]
  description: [Description]

servers:
  - url: https://api.example.com/v1

paths:
  /users:
    get:
      summary: List all users
      parameters:
        - name: limit
          in: query
          schema:
            type: integer
            default: 10
      responses:
        '200':
          description: Success
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: integer
        name:
          type: string
        email:
          type: string
      required:
        - id
        - name
        - email
```

### Format 2: Markdown API Reference

**When to Use:** Simple APIs, internal documentation

**Structure:**
```markdown
# API Reference

## Endpoints

### GET /api/users

Retrieve list of users.

**Parameters:**
- `limit` (query, optional): Number of users to return (default: 10)
- `offset` (query, optional): Pagination offset (default: 0)

**Response:**
```json
{
  "users": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    }
  ],
  "total": 100
}
```

**Errors:**
- `400 Bad Request`: Invalid parameters
- `401 Unauthorized`: Missing authentication
```

### Format 3: JSDoc (TypeScript/JavaScript)

**When to Use:** Function-level API documentation

**Structure:**
```typescript
/**
 * Fetches user data by ID
 *
 * @param {number} userId - The user ID to fetch
 * @param {Object} options - Fetch options
 * @param {boolean} options.includeProfile - Include profile data
 * @returns {Promise<User>} The user object
 * @throws {NotFoundError} If user doesn't exist
 *
 * @example
 * const user = await fetchUser(123, { includeProfile: true });
 * console.log(user.name);
 */
async function fetchUser(userId, options = {}) {
  // Implementation
}
```

## Documentation Generation Process

### Step 1: Analyze API Surface

**Find Route Definitions:**
```bash
# Express.js
Grep: pattern="app\\.(get|post|put|delete)" path="routes/"

# FastAPI
Grep: pattern="@app\\.(get|post|put|delete)" path="app/"

# Django
Grep: pattern="path\\(|re_path\\(" path="urls.py"
```

**Extract Information:**
- HTTP method (GET, POST, etc.)
- Route path (/api/users/:id)
- Parameters (path, query, body)
- Request/response formats
- Authentication requirements

### Step 2: Identify Schemas

**Find Data Models:**
```bash
# TypeScript interfaces
Grep: pattern="interface.*\\{" path="types/"

# Pydantic models
Grep: pattern="class.*\\(BaseModel\\)" path="models/"

# JSON Schema
Find: schema.json files
```

**Extract Schema Properties:**
- Field names
- Data types
- Required vs optional
- Validation rules
- Default values

### Step 3: Generate Examples

**Create Realistic Examples:**
```json
// Good Example (realistic data)
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "createdAt": "2025-10-19T10:30:00Z"
}

// Bad Example (meaningless data)
{
  "id": 1,
  "name": "string",
  "email": "string"
}
```

### Step 4: Document Error Responses

**Standard Error Format:**
```json
{
  "error": "Not Found",
  "message": "User with ID 123 does not exist",
  "code": "USER_NOT_FOUND",
  "statusCode": 404
}
```

**Common Status Codes:**
- 200: Success
- 201: Created
- 400: Bad Request (client error)
- 401: Unauthorized (missing auth)
- 403: Forbidden (insufficient permissions)
- 404: Not Found
- 500: Internal Server Error

## Best Practices

### Clear Descriptions

**✅ Good:**
```
GET /api/users/:id

Retrieves detailed user information by user ID. Includes profile data,
account status, and recent activity.
```

**❌ Poor:**
```
GET /api/users/:id

Gets user.
```

### Request Examples

**Always Include:**
- Headers (Content-Type, Authorization)
- Query parameters with values
- Request body with realistic data

```bash
# cURL Example
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com"
  }'
```

### Response Documentation

**Document All Scenarios:**
- Success response (200-299)
- Client errors (400-499)
- Server errors (500-599)

**Example:**
```yaml
responses:
  '200':
    description: User created successfully
    content:
      application/json:
        example:
          id: 123
          name: "John Doe"
  '400':
    description: Invalid input
    content:
      application/json:
        example:
          error: "Email already exists"
  '401':
    description: Unauthorized
```

## Output Format

```markdown
# [API Name] Documentation

## Base URL
`https://api.example.com/v1`

## Authentication
All endpoints require JWT Bearer token:
```
Authorization: Bearer <your_token>
```

## Endpoints

### Users

#### GET /users
List all users with pagination.

**Parameters:**
- `limit` (query, integer): Results per page (default: 10, max: 100)
- `offset` (query, integer): Pagination offset (default: 0)

**Response 200:**
```json
{
  "users": [...],
  "total": 150
}
```

**Response 401:**
```json
{
  "error": "Unauthorized"
}
```

#### POST /users
Create new user.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com"
}
```

**Response 201:**
```json
{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "createdAt": "2025-10-19T10:30:00Z"
}
```

## Error Handling

All errors follow consistent format:
```json
{
  "error": "Error type",
  "message": "Detailed message",
  "code": "ERROR_CODE"
}
```

## Rate Limiting
100 requests per minute per API key.
```

## Integration

Works with architecture-docs for high-level API design.
Coordinate with code-comments for function-level documentation.

## Success Criteria

- ✅ All endpoints documented
- ✅ Request/response examples included
- ✅ Error cases covered
- ✅ Authentication documented
- ✅ Examples are realistic and testable
