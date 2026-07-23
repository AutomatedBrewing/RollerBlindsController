---
type: SYSMOD Process
title: SYSMOD Architecture Process
description: The SYSMOD Architecture Process groups the methods that create the physical architecture of the system, including logical architecture, product architecture, scenarios, and system states.
timestamp: 2026-07-01T00:00:00Z
---

The SYSMOD Architecture Process is one of the four primary SYSMOD Processes. It covers the derivation of the solution space from the problem space, starting from analysis artifacts and producing the physical architecture of the system.

# Purpose

The Architecture Process translates requirements and analysis results into a concrete system architecture. It produces the logical architecture, product architecture, scenarios, and system states.

# Description

The Architecture Process receives outputs from the Analysis Process (particularly use case activities, requirements, and system context) and the optional FAS (Functional Architectures for Systems) method as inputs. The Functional Architecture, though not a core SYSMOD product, acts as a bridge between the analysis and architecture processes.

The process results in the Physical Architecture of the system, comprising the Logical Architecture and Product Architecture. Scenarios validate the architecture by testing paths through use case activities against the architecture elements.

# Relationships

**Methods (contained in this process):**
- [4.17 Model the Functional Architecture](../methods/model-functional-architecture.md)
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)
- [4.19 Model the Product Architecture](../methods/model-product-architecture.md)
- [4.20 Revise an Architecture with Scenarios](../methods/revise-architecture-scenarios.md)
- [4.21 Define System States](../methods/define-system-states.md)

**Products (results of this process):**
- [5.18 Functional Architecture](../products/functional-architecture.md)
- [5.20 Logical Architecture](../products/logical-architecture.md)
- [5.21 Product Architecture](../products/product-architecture.md)
- [5.22 Scenarios](../products/scenarios.md)
- [5.23 System States](../products/system-states.md)

**Primary Roles:**
- [System Architect](../roles/system-architect.md)

**Related Tools:**
- [Functional Architectures for Systems (FAS)](../tools/functional-architectures-for-systems.md)
- [Coupling of System Architectures](../tools/coupling-system-architectures.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Chapter 3, Figures 3.5 and 3.6 (SYSMOD Architecture Process and FAS integration).
