---
type: arc42 Section
title: Architecture Decisions
description: Records important, hard-to-reverse architecture decisions along with their context, alternatives considered, and rationale.
timestamp: 2026-07-01T00:00:00Z
---

The Architecture Decisions section captures the most significant decisions made during the architecture process — those that are hard to reverse and have wide-reaching consequences for the system. The goal is not to document every decision, but to ensure that future architects and developers can understand why the system was built the way it was, what alternatives were considered, and what trade-offs were accepted.

This section is often populated using Architecture Decision Records (ADRs), a lightweight format that captures the context, the decision made, the alternatives considered, and the consequences of each significant choice. By recording decisions with their rationale, teams avoid the common situation where an architectural choice is questioned by newcomers who do not know why it was made, leading to unnecessary re-evaluation or inadvertent reversal.

Decisions documented here should be genuinely architectural in nature — choices that affect the system's structure, quality attributes, or long-term evolvability. Routine implementation decisions that can be easily changed belong elsewhere. The relationship with the Solution Strategy section is important: the Solution Strategy provides the high-level summary, while this section provides the detailed justification.

# Schema

| Element | Description |
|---------|-------------|
| Decision title | A short descriptive name for the decision |
| Context | The situation, problem, or forces that necessitated the decision |
| Decision | What was decided |
| Alternatives considered | Other options that were evaluated and why they were not chosen |
| Consequences | The positive and negative implications of the decision |

# Relationships

* [Solution Strategy](solution-strategy.md) — The Solution Strategy in Section 4 summarises the high-level intent that individual decisions recorded here support.
* [Cross-cutting Concepts](cross-cutting-concepts.md) — Many cross-cutting concerns in Section 8 originate from decisions captured here.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
