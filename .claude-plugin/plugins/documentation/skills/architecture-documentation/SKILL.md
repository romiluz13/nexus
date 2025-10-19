---
name: Architecture Documentation
description: |
  Generate system architecture documentation including design decisions, component
  diagrams, data flow, and technical specifications. Create ADRs, architecture
  guides, and system overviews. Activate for architecture documentation needs.
allowed-tools: Read, Write, Edit, Grep, Glob
---

# Architecture Documentation

## Purpose

Document system architecture, design decisions, and technical specifications. Create clear diagrams, explain component interactions, and record architectural decision records (ADRs).

## When to Activate

**Trigger Keywords:**
- "document architecture"
- "system design docs"
- "create ADR"
- "architecture diagram"
- "how does the system work"

**Examples:**
- "Document the system architecture"
- "Create architecture decision record"
- "Explain how components interact"

## Documentation Types

### 1. Architecture Overview

**Purpose:** High-level system understanding

**Structure:**
```markdown
# System Architecture

## Overview
[Brief description of what the system does]

## Architecture Style
- Microservices / Monolithic / Serverless / Event-Driven

## Key Components

### Frontend
- **Technology:** React 18
- **Responsibility:** User interface, client-side state
- **Communication:** REST API calls to backend

### Backend API
- **Technology:** Node.js + Express
- **Responsibility:** Business logic, data validation
- **Communication:** PostgreSQL database, Redis cache

### Database
- **Technology:** PostgreSQL 15
- **Responsibility:** Persistent data storage
- **Schema:** Users, Orders, Products tables

## Data Flow

```
User → Frontend → Backend API → Database
              ↓
           Redis Cache (read-through)
```

## External Dependencies
- Stripe API (payments)
- SendGrid (email)
- AWS S3 (file storage)
```

### 2. Architecture Decision Record (ADR)

**Purpose:** Document why architectural choices were made

**Template:**
```markdown
# ADR-001: Use PostgreSQL for Primary Database

**Status:** Accepted
**Date:** 2025-10-19
**Context:** Need reliable database for transactional data

## Decision
Use PostgreSQL instead of MongoDB

## Rationale
- Strong ACID guarantees needed for financial transactions
- Complex queries benefit from SQL
- Established tooling and team expertise
- Better consistency for relational data

## Consequences

**Positive:**
- Data integrity guaranteed
- Complex joins supported natively
- Mature ecosystem

**Negative:**
- Less flexible schema
- Horizontal scaling more complex
- Migration overhead for schema changes

## Alternatives Considered
- MongoDB: Rejected due to weaker consistency
- MySQL: Similar, but less advanced features
```

### 3. Component Interaction Diagram

**Purpose:** Show how components communicate

**ASCII Diagram:**
```
┌─────────────┐
│   User      │
└──────┬──────┘
       │ HTTPS
       ↓
┌─────────────────┐
│  Load Balancer  │
└────────┬────────┘
         │
    ┌────┴────┐
    ↓         ↓
┌─────┐   ┌─────┐
│ API │   │ API │  (Multiple instances)
│  1  │   │  2  │
└──┬──┘   └──┬──┘
   │         │
   └────┬────┘
        ↓
   ┌─────────┐
   │Database │
   └─────────┘
```

### 4. Data Flow Diagram

**Purpose:** Show data movement through system

**Example:**
```markdown
## Order Processing Flow

1. **User submits order** (Frontend)
   ↓ POST /api/orders with order data

2. **Validation** (Backend)
   - Check inventory
   - Validate payment info
   ↓

3. **Payment Processing** (Stripe Integration)
   - Charge credit card
   - Receive confirmation
   ↓

4. **Order Creation** (Database)
   - Create order record
   - Update inventory
   - Transaction commit
   ↓

5. **Confirmation** (Email Service)
   - Send order confirmation
   - Queue fulfillment

6. **Response** (Frontend)
   ← Success response with order ID
```

## Architecture Analysis Process

### Step 1: Identify Components

**Find Services/Modules:**
```bash
# Find main directories
ls -d src/*/

# Find entry points
Grep: pattern="app\\.listen|createServer" path="src/"

# Find service definitions
Grep: pattern="class.*Service|export.*service" path="src/"
```

### Step 2: Map Dependencies

**Analyze Imports:**
```bash
# Find internal dependencies
Grep: pattern="from ['\"]@/" path="src/"

# Find external dependencies
Read: package.json → "dependencies"
```

### Step 3: Understand Data Flow

**Trace Request Lifecycle:**
```
1. Entry point (server.ts, main.ts)
2. Middleware chain
3. Route handlers
4. Service layer
5. Data layer
6. Response formation
```

### Step 4: Document Decisions

**Key Decisions to Document:**
- Why this tech stack?
- Why this architectural pattern?
- What trade-offs were made?
- What alternatives were considered?
- What are the constraints?

## Best Practices

### Use Clear Diagrams

**✅ Good (Clear labels):**
```
Frontend (React)
    ↓ HTTP POST /api/login
Backend API
    ↓ SQL Query
Database
```

**❌ Poor (No context):**
```
A → B → C
```

### Explain Trade-offs

**Always Document:**
- Performance implications
- Scalability considerations
- Maintenance costs
- Security implications

**Example:**
```markdown
## Caching Strategy

**Decision:** Redis in-memory cache

**Trade-off:**
- ✅ Faster reads (10ms → 1ms)
- ✅ Reduced database load
- ❌ Additional infrastructure cost
- ❌ Cache invalidation complexity
- ❌ Potential stale data
```

### Keep It Updated

**Triggers for Updates:**
- New component added
- Architecture pattern changed
- External dependency added
- Major refactoring completed

## Output Format

```markdown
# [System Name] Architecture

**Last Updated:** 2025-10-19
**Status:** Production
**Team:** Platform Engineering

## Executive Summary

[System Name] is a [architecture style] system that [primary purpose].
Built with [key technologies], handling [scale metrics].

## Architecture Overview

### System Components

```
[ASCII diagram of main components]
```

### Technology Stack

**Frontend:**
- React 18.3.1
- TypeScript 5.2
- Vite

**Backend:**
- Node.js 20
- Express 4.18
- PostgreSQL 15

**Infrastructure:**
- AWS (ECS, RDS, S3)
- Redis (ElastiCache)
- Nginx (Load Balancer)

## Component Details

### [Component Name]

**Responsibility:** [What it does]
**Technology:** [Stack used]
**Interfaces:** [APIs it exposes]
**Dependencies:** [What it calls]

**Key Design Decisions:**
- [Decision 1 with rationale]
- [Decision 2 with rationale]

## Data Architecture

### Database Schema

```sql
-- Key tables
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  created_at TIMESTAMP
);
```

### Data Flow

[Diagram showing data movement]

## Security Architecture

- Authentication: JWT tokens
- Authorization: Role-based (admin, user)
- Data encryption: TLS 1.3, AES-256 at rest
- Secrets management: AWS Secrets Manager

## Scalability

- Horizontal: API servers auto-scale
- Database: Read replicas for queries
- Caching: Redis for hot data
- CDN: CloudFront for static assets

## Monitoring & Observability

- Logging: CloudWatch
- Metrics: Prometheus + Grafana
- Tracing: OpenTelemetry
- Alerting: PagerDuty

## Known Limitations

- Maximum 10,000 concurrent users
- File uploads limited to 100MB
- API rate limit: 1000 req/min

## Future Improvements

- [ ] Add GraphQL API
- [ ] Implement event sourcing
- [ ] Multi-region deployment
```

## Integration

Coordinate with api-documentation for API details.
Works with code-comments for implementation-level docs.

## Success Criteria

- ✅ Clear system overview
- ✅ All components documented
- ✅ Data flow explained
- ✅ Design decisions recorded
- ✅ Diagrams are accurate and helpful
- ✅ Non-technical stakeholders can understand high-level
