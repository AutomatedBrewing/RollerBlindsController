---
okf_version: "0.1"
type: OKF Bundle Index
title: Software Architecture Knowledge Bundle
description: Knowledge bundle describing the Software Architecture level that continues the SYSMOD Architecture process where the Product Architecture (SM-PRD-21) stops, expressed in SysML v2 and published through the SW-relevant arc42 sections.
timestamp: 2026-07-01T00:00:00Z
---

# Software Architecture Knowledge Bundle

SYSMOD's Product Architecture (SM-PRD-21) is, by definition, the most detailed
system-model architecture — SYSMOD explicitly states that anything below it
("software model, CAD model") belongs to domain-specific engineering models
and is **out of scope** for SYSMOD itself
([SYSMOD Product Architecture](../sysmod/products/product-architecture.md), §Description).

This bundle fills that gap for the software/firmware discipline. It treats
**Software Architecture** as a first-class, project-defined artifact set — not
a SYSMOD product — that:

1. Takes the firmware `part def` components already identified in the
   Product Architecture (SM-PRD-21) as its starting point.
2. Elaborates them using the **same SysML v2 language** already used
   throughout the model (no new notation, no UML/SysML v1 constructs).
3. Is organised **per SW-relevant arc42 artifact** rather than per SYSMOD
   product, because SYSMOD has no method/product pair for this level.
4. Is discoverable from the existing integration layer via
   [`../integration/okf-ontology.md` §7](../integration/okf-ontology.md)
   (System Decomposition Strategy, level L5) and
   [`../integration/index.md`](../integration/index.md).

**ID namespace:** `SWA-01` … `SWA-07` (Software Architecture artifacts —
distinct from `SM-PRD-*`, since these are not SYSMOD products).

# Subdirectories

* [products](products/index.md) — Definitions of the 7 SW-relevant Software Architecture artifacts (constraints, solution strategy, building block view, runtime view, deployment view, cross-cutting concepts, architecture decisions).
* [crossmapping](crossmapping/index.md) — Per-artifact SysML v2 + arc42 cross-mapping files, following the same §1–§5 structure used in [`../integration/crossmapping/`](../integration/crossmapping/index.md).

# Relationship to Other Bundles

| Bundle | Role for Software Architecture |
|--------|--------------------------------|
| [SYSMOD](../sysmod/index.md) | Provides the predecessor artifact (SM-PRD-21 Product Architecture) and the general Architecture process (SM-PRC-02); does **not** cover this level. |
| [SysML v2](../sysml2/index.md) | Same language elements as the rest of the model (`part def`, `action def`, `exhibit state`, `allocation def`, `constraint usage`, `metadata def`) — no new concepts are introduced. |
| [arc42](../arc42/index.md) | Target publication sections: Architecture Constraints (ARC-02), Solution Strategy (ARC-04), Building Block View (ARC-05, deeper whitebox levels), Runtime View (ARC-06), Deployment View (ARC-07), Cross-cutting Concepts (ARC-08), Architecture Decisions (ARC-09). |
| [Integration](../integration/index.md) | Unified ontology; updated to reference this bundle (see `okf-ontology.md` §1.4, §3.1, §6, §7). |

# Citations

- SYSMOD – The Systems Modeling Toolbox, 3rd edition. Tim Weilkiens, MBSE4U, 2020. Section 5.21 (Product Architecture) — establishes that the next level of detail is out of SYSMOD's scope.
- arc42 Architecture Documentation Framework — sections 02, 04, 05, 06, 07, 08, 09.
- Project convention: `Project/Model/Architecture/software/PLAN.md` (RollerBlindsController project).
