---
type: arc42 Section
title: Building Block View
description: Describes the static decomposition of the system into building blocks arranged in hierarchical whitebox and blackbox levels.
timestamp: 2026-07-01T00:00:00Z
---

The Building Block View is the central structural section of an arc42 document. It describes how the system is decomposed into building blocks — components, modules, subsystems, or classes — arranged in a containment hierarchy. Each level of the hierarchy refines the previous one: higher levels show less detail (blackboxes), while lower levels open selected blackboxes to reveal their internal structure (whiteboxes).

The first level, Whitebox Overall System, presents the system as a whole opened up to reveal its top-level building blocks. Each building block at this level is a blackbox from the perspective of its container, and is described with its purpose, interfaces, and optionally its quality characteristics, directory location, and fulfilled requirements. Subsequent levels (Level 2, Level 3, …) progressively decompose selected building blocks, each time showing a whitebox view of one component from the level above.

Architects use this section as the primary reference for understanding static structure. It supports onboarding, impact analysis, and architectural reviews by providing a consistent map of all system components and their relationships. The number of levels documented should be driven by the complexity of the system and the communication needs of the audience.

# Schema

| Level | Elements |
|-------|---------|
| Whitebox Overall System | Overview Diagram; Motivation (text explanation); Contained Building Blocks (list/description of blackboxes); Important Interfaces |
| Black Box Template | Purpose/Responsibility; Interface(s); Optional: Quality/Performance Characteristics, Directory/File Location, Fulfilled Requirements, Open Issues/Problems/Risks |
| Level 2 | One whitebox description per building block from Level 1 that warrants further decomposition |
| Level 3 | One whitebox description per building block from Level 2 that warrants further decomposition |

**Black box description fields:**

| Field | Required | Description |
|-------|----------|-------------|
| Purpose/Responsibility | Yes | What this building block does |
| Interface(s) | Yes | How it communicates with the rest of the system |
| Quality/Performance Characteristics | No | Relevant non-functional properties |
| Directory/File Location | No | Where the implementation lives in the repository |
| Fulfilled Requirements | No | Which requirements this building block satisfies |
| Open Issues/Problems/Risks | No | Known issues or risks associated with this block |

# Relationships

* [Runtime View](runtime-view.md) — Building block instances from this section appear as participants in runtime scenarios in Section 6.
* [Deployment View](deployment-view.md) — Building blocks defined here are mapped to infrastructure nodes in Section 7.
* [Context and Scope](context-and-scope.md) — External interfaces visible at the system boundary in Section 3 are implemented by top-level building blocks here.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
