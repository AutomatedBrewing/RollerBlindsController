---
okf_version: "0.1"
type: OKF Cross-Mapping
title: Cross-Mapping — Software Building Block View
description: Full SysML v2 and arc42 mapping for Software Architecture artifact Building Block View (SWA-03).
timestamp: 2026-07-01T00:00:00Z
---

# Cross-Mapping — Software Building Block View (SWA-03)

The Software Building Block View continues arc42's iterative Building Block
View (ARC-05) one level deeper than SYSMOD's Product Architecture (SM-PRD-21,
arc42 Level 3): it opens up each firmware `part def` blackbox to reveal its
internal sub-modules, algorithms, data, and exhibited state machines.

## §1 SysMod Definition

**Artifact ID:** SWA-03
**Not a SYSMOD product** — SYSMOD's own text states the next level of detail below Product Architecture is "part of specific engineering models... out of scope for the system model." SWA-03 is the project's own convention for keeping that engineering model inside the same SysML v2 model rather than switching tools.
**Continues:** [Product Architecture](../../sysmod/products/product-architecture.md) (SM-PRD-21) firmware `part def` components.
**Responsible Role:** Software Architect (project role).

### Purpose

To decompose selected firmware `part def` components (those complex enough
to warrant it, per arc42's own selectivity guidance) into their internal
structure: sub-modules, internal algorithms, internal data, and — critically
for this project — the concrete `exhibit state` binding of the System States
(SM-PRD-23) state machines that currently exist only on Logical-layer
specializations.

### Role in Process

Performed after the Software Solution Strategy (SWA-02) has assigned
decomposition rationale and state-machine hosts. For each firmware `part
def` selected for decomposition, the Software Architect creates a new
specializing `part def` (`:>` the existing component) and adds nested
`part`/`action`/`attribute` usages to it, plus, where assigned, the full
`exhibit state` body (state usages, transitions, entry/do/exit actions).

### Inputs (table)

| # | Input Artifact | ID | Description |
|---|---|---|---|
| 1 | Product Architecture | SM-PRD-21 | The firmware `part def` components being decomposed, with their existing ports/flows/attributes |
| 2 | Software Solution Strategy | SWA-02 | Decomposition rationale and state-machine hosting assignment |
| 3 | System States | SM-PRD-23 | The `state def` taxonomies to be exhibited on the assigned firmware host |
| 4 | Use Case Activities | SM-PRD-14 | `action def` bodies that may need firmware-level refinement |

### Outputs / Dependent Artifacts (table)

| # | Dependent Artifact | ID | Relationship |
|---|---|---|---|
| 1 | Software Runtime View | SWA-04 | Internal actions and exhibited states become scenario participants |
| 2 | Software Deployment View | SWA-05 | Internal data structures contribute to the RAM budget |
| 3 | Test Cases | SM-PRD-16 | Internal algorithms may need unit-level verification cases |

### Dependencies

- **SM-PRD-21 (Product Architecture):** Every SWA-03 decomposition MUST be added via a NEW `part def` that specializes (`:>`) an existing firmware `part def` unchanged — SysML v2 has no mechanism to "reopen" a `part def` and inject members into it from another package. SWA-03 never introduces a new top-level firmware component (that would be a Product Architecture change) and never re-declares an existing component's simple name as if extending it in place.
- **SWA-02 (Solution Strategy):** The state-machine host assignment from SWA-02 MUST be honoured exactly — `exhibit state` goes on the assigned (specializing) `part def`, not wherever is most convenient.

---

## §2 SysML v2 Mapping

### Mapping Table

| SW Architecture Element | SysML v2 Construct | Node ID | Rationale |
|---|---|---|---|
| Whitebox specialization | New `part def <Name>Internal :> <ExistingPartDef>` | [SML-META] [Subclassification](../../sysml2/concepts/subclassification.md) | SysML v2 has no partial-class/reopening mechanism; a NEW specializing `part def` inherits every existing port/attribute unchanged and is the only non-invasive way to add internal structure to an existing Product Architecture component |
| Internal sub-module | Nested `part def` / `part` usage inside the specializing `part def` | [SML-USG-PartUSG](../../sysml2/concepts/part-usage.md) | Same construct as L0–L3, applied one containment level deeper |
| Internal algorithm | `action def` + `perform action` | [SML-DEF-ActDef](../../sysml2/concepts/action-definition.md) | Reuses the same action pattern already used in Use Case Activities (SM-PRD-14) |
| Internal data structure | `attribute` usage (private/internal, not exposed via a port) | [SML-USG-AttrUSG](../../sysml2/concepts/attribute-usage.md) | Distinguishes internal state from the port-visible interface already fixed by the Product Architecture |
| State-machine hosting | `exhibit state <name> : <StateDef> {...}` | [SML-USG-StateUSG](../../sysml2/concepts/state-usage.md) | Identical mechanism already used in `SystemStates.sysml`; only the *host* `part def` changes (from a Logical specialization to the concrete firmware component's own specializing `part def`) |
| Whitebox diagram | Definition Diagram | [SML-DGM-DefDiag](../../sysml2/diagrams/definition-diagram.md) | One diagram per decomposed firmware component, showing its internal parts |

### Modeling Pattern

```sysml
package SWA_BuildingBlocks {
    private import ProductComponents::*;
    private import SystemStates::*;

    // Whitebox decomposition of MovementSupervisorSoftware (already a
    // Product Architecture part def). SysML v2 has no "reopening"/partial-
    // class mechanism — a second `part def MovementSupervisorSoftware { }`
    // declared in a different package would create an unrelated definition
    // that merely happens to share a simple name; it would NOT add members
    // to the original `ProductComponents::MovementSupervisorSoftware`. The
    // correct, non-invasive mechanism — already established in this project
    // (e.g. `SystemStates.sysml`'s `RollerShutterControllerWithLifecycle :>
    // RollerShutterControllerLogicalComponents`, and `ProductComponents`'
    // own `MovementSupervisorSoftware :> LogicalMovementSupervisor`) — is
    // subclassification (`:>`): a NEW specializing part def that inherits
    // every existing port/attribute unchanged and adds internal structure
    // alongside them.
    part def MovementSupervisorSoftwareInternal :> ProductComponents::MovementSupervisorSoftware {
        // ... every port/attribute already on MovementSupervisorSoftware is
        // inherited unchanged via ':>' — nothing is redeclared here ...

        // Internal sub-module: the timer-tick countdown algorithm.
        action def RunSupervisionTick {
            in elapsedMs : Real;
            out timedOut : Boolean;
        }

        // Internal data: current countdown state, not visible on any port.
        attribute remainingMs : Real;

        // Resolves the project's open state-machine-binding gap: the
        // firmware host now directly exhibits the state machine instead of
        // only a Logical-layer specialization doing so.
        exhibit state lifecycle : ControllerLifecycleState {
            // Body elaborated per SystemStates.sysml's existing pattern.
        }
    }

    // Package-level usage instantiating the specialized whitebox (mirrors
    // SystemStates.sysml's own package-level usage pattern for its
    // specializing part def) — this is what SWA-02's state-hosting
    // assignment would point ControlMCU's part usage at, if this component
    // is selected as the concrete firmware host.
    part movementSupervisorSoftwareInternal : MovementSupervisorSoftwareInternal;
}
```

### Recommended Package Structure

```
<System>_Architecture/
  software/
    building_block_view/
      <System>_SWBuildingBlocks.sysml   ← nested part/action/attribute additions per firmware component
```

---

## §3 arc42 Mapping

| arc42 Section | ID | Relationship | Content Contributed |
|---|---|---|---|
| [Building Block View](../../arc42/sections/building-block-view.md) | ARC-05 | **Mandatory** | Level 4+ whitebox decomposition of selected firmware components |
| [Runtime View](../../arc42/sections/runtime-view.md) | ARC-06 | Recommended | Exhibited state machines feed directly into runtime scenarios (SWA-04) |

---

## §4 Traceability

### Incoming Links (table)

| Source ID | Source Name | Link Type | Description |
|---|---|---|---|
| SM-PRD-21 | Product Architecture | `refines` | SWA-03 is a deeper whitebox refinement of an existing firmware `part def` |
| SWA-02 | Software Solution Strategy | `depends_on` | Decomposition rationale and state-hosting assignment must be followed |
| SM-PRD-23 | System States | `depends_on` | State taxonomies exhibited here are defined there |

### Outgoing Links (table)

| Target ID | Target Name | Link Type | Description |
|---|---|---|---|
| SWA-04 | Software Runtime View | `enables` | Internal actions/states become scenario participants |
| SWA-05 | Software Deployment View | `enables` | Internal data structures are counted in the RAM budget |
| ARC-05 | Building Block View | `documents` | Rendered as Level 4+ whitebox sub-sections |

### Traceability Rules

1. Every SWA-03 whitebox decomposition MUST be added via a NEW `part def` that specializes (`:>`) an existing Product Architecture firmware `part def` — never by re-declaring/nesting inside the original definition, and never as a sibling top-level component unrelated to it.
2. Every `exhibit state` added here MUST correspond to a hosting assignment already made in SWA-02.
3. Not every firmware component requires SWA-03 decomposition — omission MUST be a documented choice (e.g. in SWA-02's rationale), not a silent gap.

---

## §5 Modeling Procedure

1. **Select components to decompose.** From SWA-02's decomposition rationale, list the firmware `part def` components warranting whitebox detail (typically: any component with a non-trivial internal algorithm or an assigned state machine).

2. **Add internal sub-modules.** For each selected component, create a new specializing `part def` (`:> ExistingPartDef`) and add nested `part`/`action def` for its internal algorithms inside that specialization — the existing ports/attributes from the Product Architecture are inherited unchanged, never edited in place.

3. **Add internal data.** Add `attribute` usages for internal data not already exposed via a port.

4. **Bind state machines.** For each state-machine hosting assignment from SWA-02, add the full `exhibit state` body — reusing the `state def` taxonomy already defined in `SystemStates.sysml`, following its established transition/guard/entry-do-exit style.

5. **Draw the whitebox diagram.** One Definition Diagram per decomposed component, in the same style already used for Product Architecture diagrams.

6. **Validate against Use Case Activities.** Confirm every internal `action def` here either specializes or is consistent with the corresponding `action def` at the Use Case Activities level (SM-PRD-14) — no contradicting behaviour.

7. **Document in arc42.** Add each decomposed component as a numbered Level 4 sub-section under ARC-05, following the existing Level 1→2→3 pattern already used for Functional/Logical/Product Architecture.
