---
type: arc42 Section
title: Deployment View
description: Describes the technical infrastructure and how software building blocks are mapped onto hardware and infrastructure elements across deployment levels.
timestamp: 2026-07-01T00:00:00Z
---

The Deployment View describes the technical infrastructure on which the system runs and shows how software building blocks from the Building Block View are distributed across that infrastructure. It answers the question of where the system runs, not just what it is made of. This is essential for understanding operational characteristics such as latency between nodes, single points of failure, and scalability boundaries.

The section is organised into infrastructure levels, mirroring the hierarchical approach used in the Building Block View. Infrastructure Level 1 presents the top-level picture with an overview diagram, a motivation explaining why the infrastructure was structured this way, a description of the quality and performance features provided by the infrastructure, and a mapping of software building blocks to infrastructure nodes. Infrastructure Level 2 then provides individual descriptions of each significant infrastructure element, accompanied by diagrams and explanations as needed.

Architects use this section to communicate with infrastructure engineers, operations teams, and security reviewers. It is also the natural place to document deployment-related constraints such as network topology, containerisation boundaries, or cloud region placement.

# Schema

| Level | Elements |
|-------|---------|
| Infrastructure Level 1 | Overview Diagram; Motivation (text explanation); Quality and/or Performance Features; Mapping of Building Blocks to Infrastructure |
| Infrastructure Level 2 | Per infrastructure element: diagram and explanation |

**Infrastructure Level 1 fields:**

| Field | Description |
|-------|-------------|
| Overview Diagram | Visual representation of the top-level infrastructure topology |
| Motivation | Explanation of why the infrastructure was designed this way |
| Quality and/or Performance Features | Infrastructure properties that contribute to system quality attributes |
| Mapping of Building Blocks to Infrastructure | Which software components run on which infrastructure nodes |

**Infrastructure Level 2 fields:**

| Field | Description |
|-------|-------------|
| Infrastructure Element (1 … n) | Individual node, cluster, or service with its own diagram and explanation |

# Relationships

* [Building Block View](building-block-view.md) — Software building blocks mapped to infrastructure nodes here are defined in Section 5.
* [Runtime View](runtime-view.md) — Runtime scenarios in Section 6 execute on the infrastructure topology described here.
* [Context and Scope](context-and-scope.md) — Technical channels identified in Section 3 correspond to network connections between infrastructure elements.

# Citations

[1] [arc42 Template](../references/arc42-template.md)
