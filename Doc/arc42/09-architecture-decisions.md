# 9. Architecture Decisions

> Rendered from `model/Architecture/base/ADR_001..008_*.sysml`
> (`@ArchDecisionMeta`, `ADR_Common`). All 8 ADRs are `status = "accepted"`.

| ADR | Title | Status / Supersede Chain |
|---|---|---|
| ADR-001 | Cost target (<50 PLN BOM) via architectural simplicity: no MCU, relay switching, dry-contact I/O | Accepted; **partially superseded by ADR-006** (MCU clause only — relay switching, dry-contact I/O, form factor, and 50 PLN target remain in force) |
| ADR-002 | Availability realized by relay-hardware MTBF, not a behavioral sub-system | Accepted |
| ADR-003 | Time-based shutter positioning with no position sensor | Accepted |
| ADR-004 | Loose (allocation) Functional→Logical coupling; strong (`:>`) Logical→Base coupling where a 1:1 counterpart exists | Accepted |
| ADR-005 | No dedicated cybersecurity requirement/architecture | Accepted |
| ADR-006 | Single low-cost 8-bit MCU hosting eight modular firmware components | Accepted; **supersedes ADR-001**'s MCU clause; sub-decision (6) LED feedback **superseded by ADR-008** |
| ADR-007 | Strong coupling for clean 1:1 Logical→Product realizations; loose (allocation) wherever ADR-006 splits a Logical component across multiple Product components | Accepted |
| ADR-008 | Active buzzer replaces bi-color LED for user feedback | Accepted; **supersedes ADR-006 sub-decision (6)** only |

## ADR-001 — Cost Target via Architectural Simplicity

- **Context:** Manufacturer `costConcern` demands manufacturing cost ≤ 50 PLN
  (`costEffective`).
- **Decision:** No MCU (timer IC/discrete RC), relay-based motor switching,
  dry-contact-only I/O, compact single-PCB form factor.
- **Superseded (partial) by ADR-006:** cost/BOM math changed once sub-2-PLN
  8-bit MCUs became available; only the "no MCU" clause is revised.

## ADR-002 — Availability via Hardware MTBF

- **Context:** REQ-Q-02 (≥99.8% availability) has no natural behavioral
  chain — the controller has no OS, scheduler, or moving software parts;
  primary failure mode is relay wear-out (RISK-T-03).
- **Decision:** Satisfied passively via relay/component MTBF selection
  (expected ≤3650 cycles/year, well within the 10,000-cycle REQ-Q-03
  endurance target). No `availabilityFunctions` FE is introduced.
- **Consequences:** Intentional gap in the UC→UCA→FA behavioral chain for
  REQ-Q-02; Physical/Product Architecture review must verify component MTBF
  against the target; a future self-test FE would require a superseding ADR.
- **Alternatives considered:** (A) dedicated `selfTestFunctions` FE — deferred
  as premature/speculative; (B) product-level MTBF constraint — rejected,
  loses REQ-Q-02's time-window semantics.

## ADR-003 — Time-Based Positioning, No Position Sensor

- **Decision:** Movement stop derived purely from elapsed time against a
  configurable `TimingProfile`; no position feedback of any kind.
- **Accepted residual risk:** RISK-T-01 (positioning drift), mitigated by a
  documented `+5s`/`timingMarginS` margin convention.

## ADR-004 — Functional↔Logical↔Base Coupling Strategy

- **Context:** SYSMOD mandates loose (allocation) Functional→Logical
  coupling; Logical→Base coupling is a project choice given 5 preset Base
  parts independent of the 9-FE functional decomposition.
- **Decision:** (1) Functional→Logical always loose (`allocation def
  FunctionToLogicalComponent`). (2) Strong (`:>`) Logical→Base for the 4
  components with an unambiguous 1:1 counterpart (`LogicalControlUnit`,
  `LogicalMotorDrive`, `LogicalLocalRequestInterface`,
  `LogicalRemoteRequestInterface`). (3) `PowerModule` has no Logical
  counterpart — reappears only from Product Architecture onward. (4)
  `LogicalMovementSupervisor`, `LogicalUserNotification`, `LogicalDiagnostics`
  are plain `part def` (no Base precedent). (5)
  `requestAcquisitionFunctions` is the one documented 1-FE-to-2-component
  split.

## ADR-005 — No Dedicated Security Scope

- **Context:** All 3 external interfaces (`WallSwitch`, `HomeAutomationSystem`,
  power) are dry-contact/relay/electrical — no protocol stack, no
  addressable identity, no attack surface in the conventional sense.
- **Decision:** No `SecurityReq` category, use case, or architecture element
  introduced. Absence of a data/network interface is treated as satisfied by
  the existing `L0_Constraints::Architectural` scope.
- **Explicit re-evaluation trigger:** any networked/addressable interface,
  OTA firmware update, data-at-rest/in-transit capability, or remote
  diagnostic interface introduced in the future.
- **Alternatives considered:** (A) speculative placeholder `SecurityReq`
  category — rejected as over-engineered; (B) silent omission — rejected,
  indistinguishable from an oversight.

## ADR-006 — Single MCU, Modular Firmware

- **Context:** Logical Architecture review's mandatory follow-up: split
  `LogicalControlUnit`'s 4-FE concentration into separately
  replaceable/testable units before finalizing the design. Discrete-timer
  realization (ADR-001's original proposal) cannot practically support
  configuration-mode calibration or fault classification.
- **Decision:** (1) One low-cost 8-bit MCU (`ControlMCU`, STM8S003F3P6-class)
  as the shared compute platform. (2) Concentration resolved via **software**
  modularization (8 firmware modules: `CommandArbitrationSoftware`,
  `MovementControlSoftware`, `MotorDriveControlSoftware`,
  `ConfigurationManagerSoftware`, `MemoryManagerSoftware`,
  `DiagnosticsSoftware`, `UserFeedbackSoftware`, `MovementSupervisorSoftware`)
  rather than hardware fragmentation. (3) `TimingProfile` stored in internal
  EEPROM. (4) Motor switching remains relay-based (reaffirms ADR-001). (5)
  All external interfaces remain dry-contact/relay-only (reaffirms ADR-001,
  ADR-005). (6) User feedback via bi-color LED — **superseded by ADR-008**.

## ADR-007 — Logical→Product Coupling Strategy

- **Decision:** Mirrors ADR-004's per-component pattern. Strong (`:>`) for
  1:1 realizations (`MovementSupervisorSoftware`, `DiagnosticsSoftware`,
  `PowerSupplyModule :> PowerModule`). Loose (allocation) wherever ADR-006's
  software split crosses a Logical component into multiple Product
  components (`LogicalControlUnit`, `LogicalMotorDrive`,
  `LogicalUserNotification`, and both request interfaces). `ControlMCU` is
  allocated FROM five Logical components without itself specializing any one
  (many-to-one hosting). `EnclosureAndConnectors` has no Logical/Base
  counterpart — traced directly to constraints/requirements instead.

## ADR-008 — Buzzer Replaces LED

- **Context:** ADR-006's bi-color LED is not observable once the controller
  is flush-mounted inside a junction box.
- **Decision:** Replace the LED with a single passive piezo buzzer
  (`AudibleNotificationBuzzer`, `BuzzerControlPort`), software-timed pulse
  patterns distinguishing configuration-mode activation/deactivation
  (REQ-F-08), conflict indication (REQ-S-02), and fault indication
  (REQ-Q-04).
- **Supersedes:** ADR-006 sub-decision (6) only; all other ADR-006 decisions
  unaffected.
