---
type: arc42 Section
title: Introduction and Goals
description: Defines the essential requirements, top quality goals, and key stakeholder expectations that drive the architecture of the system.
timestamp: 2026-07-01T00:00:00Z
---

The Introduction and Goals section serves as the entry point for any arc42-documented architecture. It establishes the purpose of the system, captures the most important requirements, and identifies the key stakeholders whose expectations the architecture must satisfy. By grounding the documentation in concrete goals from the outset, this section ensures that every subsequent architectural decision can be traced back to an explicit need.

This section contains three subsections: the Requirements Overview, which summarises the business goals and essential functional requirements; the Quality Goals, which lists the top three to five quality attributes (such as reliability, performance, or security) that have the highest priority for the architecture; and the Stakeholders table, which records all parties that have an interest in the system or its documentation, together with their contact information and expectations.

Architects use this section as a communication tool with non-technical stakeholders, ensuring that business intent and quality expectations are documented before any design work begins. It also acts as a traceability anchor: quality goals recorded here are later elaborated as quality scenarios in Section 10, and constraints that emerge from stakeholder expectations inform the Architecture Constraints section.

# Schema

| Subsection | Content |
|------------|---------|
| Requirements Overview | Business context and essential functional requirements of the system |
| Quality Goals | Top three to five quality attributes prioritised for the architecture (e.g., reliability, maintainability, security) |
| Stakeholders | Table with columns Role/Name, Contact, and Expectations listing all interested parties |

**Stakeholder table structure:**

| Role/Name | Contact | Expectations |
|-----------|---------|--------------|
| `<Role-1>` | `<Contact-1>` | `<Expectation-1>` |
| `<Role-2>` | `<Contact-2>` | `<Expectation-2>` |

# Relationships

* [Architecture Constraints](architecture-constraints.md) — Stakeholder expectations and requirements often surface constraints that restrict design freedom.
* [Quality Requirements](quality-requirements.md) — Quality goals stated here are elaborated into measurable quality scenarios in Section 10.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
