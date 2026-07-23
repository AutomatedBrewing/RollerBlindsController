---
type: arc42 Section
title: Glossary
description: Defines important domain-specific and technical terms used throughout the architecture documentation to ensure shared understanding.
timestamp: 2026-07-01T00:00:00Z
---

The Glossary section establishes a shared vocabulary for the architecture documentation. It defines the key domain-specific and technical terms used throughout the document, ensuring that all readers — regardless of background — interpret the same concepts consistently. Misaligned terminology is a frequent source of misunderstanding between business stakeholders, architects, and developers; a well-maintained glossary mitigates this risk directly.

The arc42 template structures the glossary as a two-column table with Term and Definition columns, making it easy to scan and reference. Each entry should define the term as it is used within this specific system's context, which may differ from generic industry definitions. Terms that appear prominently in multiple sections — particularly in the Context and Scope, Building Block View, or Quality Requirements sections — are the best candidates for inclusion.

Architects maintain the glossary as a living document, adding new terms as the domain understanding evolves and the documentation grows. It is also a useful onboarding resource for new team members, who can use it as a quick reference when reading unfamiliar sections of the architecture documentation.

# Schema

| Column | Description |
|--------|-------------|
| Term | The domain-specific or technical term being defined |
| Definition | The meaning of the term within the context of this system |

**Glossary table structure (from template):**

| Term | Definition |
|------|------------|
| `<Term-1>` | `<definition-1>` |
| `<Term-2>` | `<definition-2>` |

# Relationships

* [Context and Scope](context-and-scope.md) — Domain terms appearing in the business context description should be defined in this glossary.
* [Introduction and Goals](introduction-and-goals.md) — Business terminology used in the requirements overview benefits from a corresponding glossary entry.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
