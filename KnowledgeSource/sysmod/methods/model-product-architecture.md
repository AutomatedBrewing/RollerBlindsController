---
type: SYSMOD Method
title: Model the Product Architecture
description: Model a concrete specification of the physical architecture as the most detailed system architecture specification in the system model.
timestamp: 2026-07-01T00:00:00Z
---

Method 4.19 in SYSMOD. The Product Architecture is the most concrete specification of a Physical Architecture of the system of interest in the system model.

# Purpose

The Product Architecture is the most concrete specification of a Physical Architecture of the system of interest in the system model.

# Description

The Product Architecture specializes the technical concepts and principles of the Logical Architecture. For example, an Electric motor in the Logical Architecture is specialized by an Electric motor type 42X in the Product Architecture, including a specification of the vendor, size, power consumption, and mechanical, electrical, and software interfaces.

If strongly coupled, the Product Architecture is a specialization of the Logical Architecture. If loosely coupled, there are only allocate relationships between both architectures.

In practice, strictly separating Logical Architectures and Product Architectures is often not necessary. When there is no benefit, model only one architecture and call it Physical or Product Architecture.

# Relationships

**Primary Performer:** [System Architect](../roles/system-architect.md)

**Inputs:**
- [5.20 Logical Architecture](../products/logical-architecture.md)

**Outputs:**
- [5.21 Product Architecture](../products/product-architecture.md)

**ISO 15288 Process:** Design Definition

**Guidance:**
- [7.16 How to Model the Product Architecture](../guidances/model-product-architecture.md)

**Part of Process:**
- [SYSMOD Architecture Process](../processes/architecture-process.md)

**Related Tools:**
- [Coupling of System Architectures](../tools/coupling-system-architectures.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 4.19.
