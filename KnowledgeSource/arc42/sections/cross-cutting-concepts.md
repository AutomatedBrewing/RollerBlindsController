---
type: arc42 Section
title: Cross-cutting Concepts
description: Documents overarching, recurring solution patterns, principles, and concepts that span multiple building blocks or subsystems.
timestamp: 2026-07-01T00:00:00Z
---

The Cross-cutting Concepts section captures recurring principles, patterns, and solution approaches that apply across multiple building blocks or subsystems rather than belonging to a single component. These are the concerns that cannot be cleanly assigned to one place in the structural hierarchy — they cut across module boundaries and must be consistently applied throughout the system.

Examples of cross-cutting concepts include security and authentication mechanisms, logging and monitoring strategies, error handling conventions, transaction management approaches, internationalisation patterns, and coding guidelines that enforce a consistent style across the codebase. By documenting these concepts explicitly, arc42 ensures that architects and developers share a common understanding of how to handle these recurring concerns consistently, reducing the risk of ad-hoc, incompatible implementations scattered across the system.

Each concept is documented with an explanation of its intent, its applicable scope, and any implementation guidelines or constraints. The arc42 template provides numbered concept slots (Concept 1, Concept 2, … Concept n) to accommodate as many cross-cutting concerns as the system requires.

# Schema

| Element | Description |
|---------|-------------|
| Concept (1 … n) | A named cross-cutting concern with its explanation, scope, and implementation guidance |

Typical categories of cross-cutting concepts:

| Category | Examples |
|----------|---------|
| Security | Authentication, authorisation, encryption, input validation |
| Observability | Logging, monitoring, tracing, alerting |
| Error handling | Exception strategies, retry policies, circuit breakers |
| Persistence | Transaction management, caching, data access patterns |
| Communication | Inter-process communication protocols, serialisation formats |
| Development conventions | Coding standards, naming conventions, testing strategies |

# Relationships

* [Building Block View](building-block-view.md) — Cross-cutting concepts apply to the building blocks defined in Section 5 and constrain their internal design.
* [Architecture Decisions](architecture-decisions.md) — Many cross-cutting concepts originate from architectural decisions documented in Section 9.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
