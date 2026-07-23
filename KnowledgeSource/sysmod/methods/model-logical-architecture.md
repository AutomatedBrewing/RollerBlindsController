---
type: SYSMOD Method
title: Model the Logical Architecture
description: Model a physical architecture on a high abstraction level that satisfies the given requirements, describing the technical concepts and principles of the system.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.18 in SYSMOD. The Logical Architecture describes the technical concepts and principles of the system and is the first version of a Physical Architecture in a top-down development approach.

# Purpose

The Logical Architecture describes the technical concepts and principles of the system.

# Description

The Logical Architecture is an abstract Physical Architecture. Thinking top-down in the development process, the Logical Architecture is the first version of a Physical Architecture. It covers architectural and technical principles and concepts—for example, an electric motor, a valve, or a display as technical concepts.

The Logical Architecture must conform to the Base Architecture. If strongly coupled, the Logical Architecture is a specialization of the Base Architecture. If loosely coupled, there are only allocate relationships between both architectures.

If you do not need a separate Logical Architecture, you can merge this step and the architecture with the Product Architecture. You would then have a Physical Architecture with both logical and concrete product aspects.

# Relationships

**Primary Performer:** [System Architect](../roles/system-architect.md)

**Inputs:**
- [5.12 System Use Cases](../products/system-use-cases.md)
- [5.11 System Context](../products/system-context.md)
- [5.10 Requirements](../products/requirements.md)
- [5.7 Base Architecture](../products/base-architecture.md)
- [5.18 Functional Architecture](../products/functional-architecture.md)

**Outputs:**
- [5.20 Logical Architecture](../products/logical-architecture.md)

**ISO 15288 Process:** Architecture Definition

**Guidance:**
- [7.15 How to Model the Logical Architecture](../guidances/model-logical-architecture.md)

**Part of Process:**
- [SYSMOD Architecture Process](../processes/architecture-process.md)

**Related Tools:**
- [Coupling of System Architectures](../tools/coupling-system-architectures.md)
- [Proxy versus Full Port](../tools/proxy-versus-full-port.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.18.
