---
okf_version: "0.1"
type: OKF Cross-Mapping Bundle
title: Software Architecture Cross-Mapping — SWA × SysML v2 × arc42
description: Bundle index for the 7 per-artifact cross-mapping files covering the Software Architecture level below SYSMOD's Product Architecture. Each file follows the same §1-§5 structure as integration/crossmapping/.
timestamp: 2026-07-01T00:00:00Z
---

# Software Architecture Cross-Mapping — SWA × SysML v2 × arc42

This bundle provides detailed cross-mapping files for the 7 Software
Architecture artifacts (SWA-01…07). Unlike
[`../../integration/crossmapping/`](../../integration/crossmapping/index.md),
which is indexed 1:1 by the 24 SYSMOD products, this bundle is indexed by
**SW-relevant arc42 artifact**, because SYSMOD has no product/method pair
below the Product Architecture (SM-PRD-21).

**Ontology reference:** [Software Architecture Bundle Index](../index.md) · [OKF Ontology](../../integration/okf-ontology.md)

| ID | Artifact | Brief Description | File |
|----|----------|-------------------|------|
| SWA-01 | Architecture Constraints | Flash/RAM budget, execution-model, and timing constraints derived from the Product Architecture's hardware attributes | [architecture-constraints.md](./architecture-constraints.md) |
| SWA-02 | Solution Strategy | Execution model, concurrency approach, and decomposition rationale for the firmware | [solution-strategy.md](./solution-strategy.md) |
| SWA-03 | Building Block View | Whitebox decomposition (Level 4+) of individual firmware `part def` components | [building-block-view.md](./building-block-view.md) |
| SWA-04 | Runtime View | Firmware execution mechanics: superloop iteration, interrupts, timer-driven scenarios | [runtime-view.md](./runtime-view.md) |
| SWA-05 | Deployment View | Flash/RAM budget validation and execution-context (task/interrupt) placement on the MCU | [deployment-view.md](./deployment-view.md) |
| SWA-06 | Cross-cutting Concepts | Firmware-wide conventions: error handling, persistence, timing/debounce, state-binding naming | [cross-cutting-concepts.md](./cross-cutting-concepts.md) |
| SWA-07 | Architecture Decisions | ADRs for software-level choices, reusing the project's existing `ADR_Common::ArchDecisionMeta` | [architecture-decisions.md](./architecture-decisions.md) |

---

## Traceability Link Types

Same link types as [`../../integration/crossmapping/index.md`](../../integration/crossmapping/index.md#traceability-link-types): `depends_on`, `refines`, `implements`, `documents`, `enables`, `verifies`.

## Usage Notes

- All relative links within these mapping files are resolved from the `swarch/crossmapping/` directory.
- SysML v2 element references reuse the existing `SML-` namespace defined in [`../../integration/okf-ontology.md`](../../integration/okf-ontology.md) §1.2 — no new SysML v2 elements are introduced at this level.
- arc42 section references use the standard `ARC-NN` identifiers.
- SWA artifacts are **not** SYSMOD products — they have no `SM-PRD-*` ID and no entry in `integration/crossmapping/`. They are referenced from `integration/okf-ontology.md` as an extension row (see §7.1 L4/L5 breakdown).
