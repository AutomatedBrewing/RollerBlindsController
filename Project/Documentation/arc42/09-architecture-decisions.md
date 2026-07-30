# 9. Architecture Decisions

> Rendered from `Project/Model/Architecture/base/ADR_001..008_*.sysml`
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
  configurable `TravelTime`; no position feedback of any kind.
- **Accepted residual risk:** RISK-T-01 (positioning drift), mitigated by a
  documented `+5s`/`timingMarginS` margin convention.

## ADR-004 — Functional↔Logical↔Base Coupling Strategy

- **Context:** SYSMOD mandates loose (allocation) Functional→Logical
  coupling; Logical→Base coupling is a project choice given 5 preset Base
  parts independent of the 8-FE functional decomposition.
- **Decision:** (1) Functional→Logical always loose (`allocation def
  FunctionToLogicalComponent`). (2) Strong (`:>`) Logical→Base for the 4
  components with an unambiguous 1:1 counterpart (`LogicalControlUnit`,
  `LogicalMotorDrive`, `LogicalLocalRequestInterface`,
  `LogicalRemoteRequestInterface`). (3) `PowerModule` has no Logical
  counterpart — reappears only from Product Architecture onward. (4)
  `LogicalMovementSupervisor` and `LogicalUserNotification` are plain
  `part def` (no Base precedent). (5) `requestAcquisitionFunctions` is the
  one documented 1-FE-to-2-component split.
- **Note (resolves SWR-037):** an earlier `LogicalDiagnostics` component was
  removed from the model permanently (`PLAN.md`); this rendering no longer
  lists it.

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
  modularization (7 firmware modules: `CommandArbitrationSoftware`,
  `MovementControlSoftware`, `MotorDriveControlSoftware`,
  `ConfigurationManagerSoftware`, `MemoryManagerSoftware`,
  `UserFeedbackSoftware`, `MovementSupervisorSoftware`)
  rather than hardware fragmentation. (3) `TravelTime` stored in internal
  EEPROM. (4) Motor switching remains relay-based (reaffirms ADR-001). (5)
  All external interfaces remain dry-contact/relay-only (reaffirms ADR-001,
  ADR-005). (6) User feedback via bi-color LED — **superseded by ADR-008**.
- **Note (resolves SWR-037):** an earlier eighth module, `DiagnosticsSoftware`,
  was removed from the model permanently (`PLAN.md`); this rendering lists
  the current 7 modules only.

## ADR-007 — Logical→Product Coupling Strategy

- **Decision:** Mirrors ADR-004's per-component pattern. Strong (`:>`) for
  1:1 realizations (`MovementSupervisorSoftware`,
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
- **Decision:** Replace the LED with a single active buzzer
  (`AudibleNotificationBuzzer`, `BuzzerControlPort`), software-timed pulse
  patterns distinguishing configuration-mode activation and deactivation
  (REQ-F-08) — the buzzer's only two purposes.
- **Supersedes:** ADR-006 sub-decision (6) only; all other ADR-006 decisions
  unaffected.

## Software Architecture Decisions

> Rendered from `Project/Model/Architecture/software/architecture_decisions/ADR_009_SWExecutionModel.sysml`,
> `ADR_010_InputDebouncing.sysml`, and `ADR_011_SoftwareLayering.sysml`. All 3 `status = "accepted"`.

| ADR | Title | Status |
|---|---|---|
| ADR-SW-009 | Bare-metal, event-driven superloop execution model | Accepted |
| ADR-SW-010 | Per-line GPIO change-notification interrupts + software debounce confirmation | Accepted |
| ADR-SW-011 | Three-layer software architecture (Application / Driver-HAL / Hardware) | Accepted |

### ADR-SW-009 — Firmware Execution Model

- **Context:** `ControlMCU` is an 8-bit MCU (16 KB flash / 1 KB RAM / 16 MHz,
  ADR-006); ADR-001's cost ceiling already rules out an RTOS-capable
  upgrade. ADR-003 established timer-based movement supervision
  (`timerResolutionMs = 10 ms`). ADR-SW-010 separately establishes
  per-line GPIO debouncing; this ADR only decides HOW the firmware is
  scheduled given both event sources.
- **Decision:** The main loop is an event dispatcher reacting to (a)
  debounced input-changed events (ADR-SW-010) and (b) the periodic 10 ms
  timer tick. All seven firmware modules are non-blocking event
  handlers/functions invoked from the dispatcher, never blocking inside an
  ISR.
- **Alternatives considered:** (A) RTOS — rejected, no flash/RAM headroom
  and no genuine concurrency need. (B) Cooperative round-robin scheduler
  with per-module task control blocks — rejected, RAM overhead with no
  benefit. (C) Flat sequential polling loop — rejected, does not compose
  cleanly with porting the team's existing event-driven abstraction library
  to bare-metal.
- **Consequences:** ISR bodies stay minimal (flag/timestamp updates only);
  GPIO/timer resource accounting deferred to
  [07-deployment-view.md §7.4](07-deployment-view.md).
- **Open item:** whether the team's existing FreeRTOS-backed event-driven
  abstraction library is reused (vs. a from-scratch bare-metal dispatcher)
  is deferred pending review of its sources.

### ADR-SW-010 — Input Debouncing & GPIO Strategy

- **Context:** `RequestInterfaceCircuit`'s RC glitch filter
  (`debounceTimeConstantMs = 20 ms`) filters electrical noise only — not
  genuine mechanical wall-switch bounce. Reliable input handling requires
  the four underlying signal lines (local/remote up/down) to be
  individually observable.
- **Decision:** Each of the four input lines gets its own dedicated GPIO
  change-notification interrupt (`inputChangeNotificationGpioCount = 4`).
  Each interrupt only timestamps/flags the raw transition;
  `CommandArbitrationSoftware` confirms stability for `debounceConfirmMs`
  (30 ms) before raising a debounced event. `arbitrationWindowMs` widened
  from 50 ms to 100 ms as part of this decision, so the ~50 ms worst-case
  combined RC+software debounce latency stays well below the arbitration
  window.
- **Alternatives considered:** (A) Hardware RC debounce only, no software
  confirmation — rejected, misclassifies genuine mechanical bounce as
  separate commands. (B) Sampling all four lines each timer tick instead of
  per-line interrupts — rejected, loses precise per-line timestamping for
  no resource saving. (C) Sampling only the two combined dry-contact ports
  — rejected, loses the ability to individually debounce each physical
  line.
- **Consequences:** 4 of `ControlMCU`'s 14 GPIOs reserved for
  change-notification interrupts, leaving 10 for relay/buzzer/prog port and
  margin (see [07-deployment-view.md §7.4](07-deployment-view.md) for the
  full pin accounting).

### ADR-SW-011 — Software Layering

- **Context:** No layer boundary was ever recorded, so every firmware module
  was free to reach hardware directly; ADR-SW-009 (execution model) and
  ADR-SW-010 (debouncing) already assumed a driver/hardware split implicitly
  but never stated it.
- **Decision:** Three layers — Application (arbitration/translation/
  supervision/persistence logic) → Driver/HAL (`GpioInputDriver`,
  `TimerDriver`, `MotorRelayOutputDriver`, `BuzzerOutputDriver`,
  `EepromDriver`, nested `part def`s in `SWBuildingBlocks.sysml`) → Hardware
  (`ControlMCU` peripherals, `RequestInterfaceCircuit`,
  `MotorDriveRelayModule`, `AudibleNotificationBuzzer`, already in
  `ProductComponents.sysml`). No Application-level action may reference a
  hardware-facing port directly; it goes through its module's driver only.
- **Alternatives considered:** (A) No explicit layering (status quo) —
  rejected, the exact gap this ADR closes. (B) Runtime-polymorphic HAL
  abstraction — rejected, RAM/flash overhead unjustified on a
  fixed-peripheral 8-bit MCU (`SWConstraints::Resource::memoryDiscipline`
  forbids the dynamic dispatch tables such an abstraction needs).
- **Consequences:** every hardware-facing port on `CommandArbitrationSoftware`,
  `MovementSupervisorSoftware`, `MotorDriveControlSoftware`,
  `UserFeedbackSoftware`, `MemoryManagerSoftware` is reached via a nested
  driver.
