---
type: Software Architecture Artifact
title: Software Cross-cutting Concepts
description: Firmware-wide principles applied consistently across modules — error handling, state-machine binding conventions, persistence/EEPROM access patterns, timing and debounce conventions.
timestamp: 2026-07-01T00:00:00Z
---

Artifact SWA-06. Software Cross-cutting Concepts capture the recurring
firmware-level principles that apply across multiple software `part def`
components rather than belonging to any single one — the software-discipline
counterpart of arc42's Cross-cutting Concepts (ARC-08).

# Purpose

Several concerns recur across the firmware modules identified in the Product
Architecture but are not the responsibility of any single one of them: how
debounce timing is applied consistently, how EEPROM access is
serialized/wear-levelled, how a module signals an invalid or fault condition
so that it reaches an observable outcome (e.g. `SystemStates::
InstallationFaultReported`/`InstallationFault` for a fault-handling state, or
a plain boolean signal such as `MemoryManagerSoftware::lastReadValid` for a
fault that is not wired into any state model), and
how every module that exhibits part of a system state machine (SWA-03)
follows the same event-naming and guard-condition conventions. Documenting
these once, here, avoids inconsistent ad-hoc solutions scattered across
firmware modules.

# Description

Candidate cross-cutting concepts for this project (to be elaborated once
modeling starts):

| Category | Firmware-specific example |
|----------|---------------------------|
| Error handling | How a fault detected in any module reaches an observable outcome — either a dedicated fault state (`SystemStates::InstallationFault`, triggered by `InstallationFaultReported`) or a plain signal attribute not (yet) wired to any state-model consumer (`MemoryManagerSoftware::lastReadValid`); whether faults are pushed (flow) or polled. Note: a dedicated diagnostics subsystem was considered and explicitly removed from project scope (behavior-clarification pass; see `PLAN.md`) — this concept does NOT reintroduce it. |
| Persistence | `MemoryManagerSoftware`'s EEPROM read/write conventions reused by any future module needing non-volatile storage |
| Timing/debounce | The arbitration/debounce window convention (`arbitrationWindowMs`, `calibrationHoldThresholdS`) — is the same debounce approach reused elsewhere? |
| State-machine binding | Naming convention for events accepted by `exhibit state` blocks when the trigger originates from an interrupt vs. a polled flag |
| Resource discipline | Whether dynamic memory allocation is disallowed project-wide (typical for a 1 KB RAM target) |

# Relationships

**Responsibility:** Software Architect (project role).

**Primary Inputs:**
- [Software Building Block View](building-block-view.md) (SWA-03) — internal module patterns that recur across components are candidates for promotion here.
- [Software Architecture Constraints](architecture-constraints.md) (SWA-01) — resource constraints often *cause* a cross-cutting concept (e.g. "no dynamic allocation" because of the RAM budget).

**Outputs consumed by:**
- [Software Architecture Decisions](architecture-decisions.md) (SWA-07) — a cross-cutting concept is often the direct consequence of one or more ADRs.
- Every [Software Building Block View](building-block-view.md) (SWA-03) module — cross-cutting concepts constrain internal module design.

**Representation:** `doc` block on a dedicated cross-cutting-concepts package, plus `metadata def` annotations where a concept needs to be checked/traced (e.g. a `NoDynamicAllocation` marker `metadata def` applied to relevant `part def`s) — no new SysML v2 concepts.

**Cross-mapping:** [crossmapping/cross-cutting-concepts.md](../crossmapping/cross-cutting-concepts.md)

# Citations

- arc42 Architecture Documentation Framework, Section 8 (Cross-cutting Concepts).
