---
type: arc42 Section
title: Solution Strategy
description: Summarizes the fundamental decisions and solution approaches that shape the architecture in response to quality goals and constraints.
timestamp: 2026-07-01T00:00:00Z
---

The Solution Strategy section provides a high-level summary of the core architectural decisions that were made to achieve the system's quality goals within the given constraints. It serves as a bridge between the "what" captured in Sections 1–3 and the "how" elaborated in the subsequent structural and runtime views. Rather than detailing individual decisions, this section captures the overall direction and the reasoning behind it.

Typical content includes the fundamental technology choices (e.g., choice of architectural style, key frameworks, or platforms), the decomposition strategy that drives the building block structure, and any significant trade-off decisions made to balance competing quality attributes. Because this section must remain consistent with the quality goals from Section 1 and the constraints from Section 2, it acts as an internal audit point: any strategy that violates a constraint or fails to address a quality goal should be visible here.

Architects use this section as an executive summary of architectural intent, making it valuable for onboarding new team members and for architecture reviews. It intentionally remains concise — deeper justification lives in the Architecture Decisions section.

# Schema

| Element | Description |
|---------|-------------|
| Technology decisions | Choices of architectural style, key technologies, frameworks, and platforms |
| Decomposition strategy | Rationale for how the system is split into building blocks |
| Quality goal achievement | How the strategy addresses each top quality goal from Section 1 |
| Constraint adherence | How the strategy respects constraints from Section 2 |

# Relationships

* [Introduction and Goals](introduction-and-goals.md) — Quality goals and requirements stated in Section 1 motivate the solution strategy.
* [Architecture Constraints](architecture-constraints.md) — All strategy choices must respect constraints from Section 2.
* [Architecture Decisions](architecture-decisions.md) — Individual decisions underpinning the strategy are documented in detail in Section 9.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
