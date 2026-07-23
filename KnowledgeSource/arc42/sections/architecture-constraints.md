---
type: arc42 Section
title: Architecture Constraints
description: Documents all constraints — organizational, technical, or regulatory — that restrict design and architecture decisions.
timestamp: 2026-07-01T00:00:00Z
---

The Architecture Constraints section records all conditions that must be observed when making architectural decisions, and over which the development team has no discretion. Constraints can originate from the organisation (e.g., mandated technology stacks or vendor agreements), from the technical environment (e.g., required integration with existing systems), or from external regulation (e.g., legal compliance requirements, data residency laws).

Unlike quality goals or functional requirements, constraints are non-negotiable: they define the solution space before any design work begins. By documenting them explicitly, arc42 ensures that reviewers and future architects can distinguish between deliberate design choices and decisions forced upon the team by external factors.

This section typically contains a table or list of constraints, each accompanied by a brief explanation of its origin and its implications for the architecture. Architects are encouraged to be precise here — vague constraints are as unhelpful as missing ones.

# Schema

| Element | Description |
|---------|-------------|
| Constraint | A specific condition that restricts the solution space (technical, organisational, or regulatory) |
| Background / Explanation | Why the constraint exists and which architectural areas it affects |

Typical categories of constraints include:

| Category | Examples |
|----------|---------|
| Technical constraints | Mandatory operating systems, programming languages, frameworks, hardware platforms |
| Organisational constraints | Team size, budget limits, delivery timelines, internal policies |
| Regulatory constraints | Data protection laws, industry standards, certification requirements |

# Relationships

* [Introduction and Goals](introduction-and-goals.md) — Stakeholder expectations recorded in Section 1 often give rise to constraints documented here.
* [Solution Strategy](solution-strategy.md) — The solution strategy must respect all constraints listed in this section.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
