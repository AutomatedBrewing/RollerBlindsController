---
type: SYSMOD Tool
title: Coupling of System Architectures
description: A pattern describing loose coupling (allocate relationship) and strong coupling (generalization relationship) between different SYSMOD architecture kinds, with trade-offs between both approaches.
timestamp: 2026-07-01T00:00:00Z
---

Tool 11.7 in SYSMOD. Different kinds of System Architectures cover different aspects of the system. The coupling approach determines how changes in one architecture propagate to others.

# Purpose

Understanding coupling approaches helps model the relationships between architecture kinds appropriately in the system model.

# Description

Conceptually, all architecture kinds are related: Base Architecture, Functional Architecture, Logical Architecture, and Product Architecture. Two coupling approaches exist in the model:

**Loose Coupling (allocate relationship):** Defines a mapping between the architectures without further impact. A change in one architecture does not automatically update the other in the model—it must be tracked manually. The Functional Architecture and the Logical Architecture are always loosely coupled by an allocate relationship.

**Strong Coupling (generalization relationship):** Defines a specialization of architecture elements. A change in the leading architecture is automatically forwarded to the dependent architecture in the model. In theory, this is a straightforward approach. In practice, the model can get very complex depending on the capabilities of the modeling tool and the modelers.

The loose coupling defines only a mapping, while the strong coupling defines a specialization. Both approaches have advantages and disadvantages.

# Relationships

**Related Products:**
- [5.7 Base Architecture](../products/base-architecture.md)
- [5.18 Functional Architecture](../products/functional-architecture.md)
- [5.20 Logical Architecture](../products/logical-architecture.md)
- [5.21 Product Architecture](../products/product-architecture.md)

**Related Methods:**
- [4.18 Model the Logical Architecture](../methods/model-logical-architecture.md)
- [4.19 Model the Product Architecture](../methods/model-product-architecture.md)

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 11.7.
