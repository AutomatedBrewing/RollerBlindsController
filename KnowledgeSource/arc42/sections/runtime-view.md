---
type: arc42 Section
title: Runtime View
description: Illustrates the dynamic behavior of the system through runtime scenarios showing how building block instances interact.
timestamp: 2026-07-01T00:00:00Z
---

The Runtime View complements the static Building Block View by showing how the system behaves at runtime. Rather than depicting components in isolation, it captures scenarios — sequences of interactions between building block instances, external actors, and data stores — that illustrate how the system fulfils its key use cases or handles important situations such as error conditions or concurrent requests.

Each runtime scenario is documented with a runtime diagram (such as a sequence or activity diagram) and a textual description of the notable aspects of the interactions depicted. The arc42 template defines numbered scenario slots (Scenario 1, Scenario 2, … Scenario n) to encourage architects to cover the most architecturally significant cases without exhaustively documenting every possible execution path.

Architects select scenarios based on their architectural significance: scenarios that exercise important quality attributes (e.g., fault tolerance, performance under load), scenarios involving complex orchestration across many components, or scenarios where the interaction design is non-obvious. This section is particularly valuable for communicating with developers who need to understand the intended dynamic behaviour before implementing it.

# Schema

| Element | Description |
|---------|-------------|
| Runtime Scenario (1 … n) | A named scenario describing a significant runtime behaviour of the system |
| Runtime diagram | Sequence diagram, activity diagram, or equivalent visual representation of the scenario |
| Notable aspects description | Textual explanation of the key interactions, message flows, or timing considerations shown in the diagram |

# Relationships

* [Building Block View](building-block-view.md) — The building block instances that participate in runtime scenarios are defined in Section 5.
* [Deployment View](deployment-view.md) — The infrastructure on which runtime scenarios execute is described in Section 7.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
