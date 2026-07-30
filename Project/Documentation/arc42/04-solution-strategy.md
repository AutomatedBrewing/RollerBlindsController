# 4. Solution Strategy

> Rendered from `Project/Model/Architecture/base/ADR_*.sysml` and
> `Project/Model/Analysis/problem/SystemIdea.sysml`.

## 4.1 Fundamental Technology / Architectural Style Decisions

| Decision | ADR | Summary |
|---|---|---|
| Cost-driven simplicity | ADR-001 | Target < 50 PLN BOM via relay-based motor switching and dry-contact I/O (originally "no MCU"); enclosure/isolation choices flow from this |
| Time-based, sensorless positioning | ADR-003 | No position sensor; timing-profile-driven movement supervision. Accepts RISK-T-01 (positioning drift) as residual risk, mitigated by a +5s margin convention |
| Single 8-bit MCU platform | ADR-006 | Partially supersedes ADR-001's "no MCU" clause: one low-cost MCU (`ControlMCU`, STM8S003F3P6-class) hosts 7 firmware modules, replacing a fragile discrete-timer design while keeping relay switching and dry-contact-only I/O unchanged |
| Availability via hardware MTBF | ADR-002 | REQ-Q-02 (≥99.8% availability) satisfied passively through relay/component MTBF selection, not a behavioral sub-system |
| No dedicated security scope | ADR-005 | All external interfaces are dry-contact/relay based with no protocol stack — no attack surface exists; re-evaluation is explicitly triggered if any networked interface is introduced |
| Buzzer over LED feedback | ADR-008 | Supersedes ADR-006 sub-decision (6): an active piezo buzzer replaces the bi-color LED because the flush-mounted enclosure makes an LED non-observable |

## 4.2 Decomposition Strategy

The system is decomposed top-down through four architecture layers (SYSMOD
FAS method), each independently traceable via `allocation`/`Derivation`
links in `Traceability::Traceability`:

1. **Base Architecture** (`BaseArchitecture::ShutterController`) — 5
   preset parts (ControlUnit, MotorDriver, WallSwitchInterface,
   RemoteInterface, PowerModule), fixed at project start.
2. **Functional Architecture** — 8 technology-independent Functional
   Elements derived from Use Case Activities (see
   [05-building-block-view.md](05-building-block-view.md) §Level 1).
3. **Logical Architecture** — 6 components; loosely allocated from
   Functional Elements (ADR-004), strongly coupled (`:>`) to Base
   Architecture where a 1:1 counterpart exists.
4. **Product Architecture** — 7 hardware components hosting 7 firmware
   modules on the single MCU (ADR-006/ADR-007), loosely allocated from
   Logical components wherever ADR-006's software split crosses one
   Logical component into multiple Product components.

## 4.3 Quality Goal Achievement

| Quality Goal (§1.2) | Strategy |
|---|---|
| Safety | Galvanic isolation constraints (`motorIsolation`, `inputIsolation`); UP+DOWN conflict suppression (`DetermineMovementRequest`/`CommandArbitrationSoftware`) — motor never energizes on conflict (REQ-S-01); conflict is silently suppressed by design, no buzzer (buzzer scope is config-mode only, REQ-F-08) |
| Reliability | Relay/triac components rated ≥10,000 switching cycles (mitigates RISK-T-03); verified by `SystemTestCases::Quality::TC_Q_003_ReliabilityEndurance` |
| Availability | ADR-002: passive hardware-MTBF realization, no dedicated behavioral sub-system |
| Ease of Installation | Explicit, signaled configuration mode (REQ-F-08); guided calibration procedure with out-of-range rejection (`RejectOutOfRangeCalibration`); bounded single-retry install/verify sequence with explicit fault reporting (`ReportInstallationFault`) |

## 4.4 Constraint Adherence

- Cost (`costEffective` ≤ 50 PLN): `ProductArchitecture::totalUnitCostPLN =
  14.5`, asserted `<= 50.0`.
- Compact size (`compactDimensions` ≤ 40×40×20 mm): single-PCB, single-MCU
  design (ADR-006) fits within a typical ⌀60 flush-mount enclosure.
- No position feedback (`noPositionFeedback`/`timeBasedOperation`): enforced
  architecturally — no Functional Element, Logical, or Product component
  reads shutter position; only elapsed time (`TravelTime`, `TravelTime`).

## 4.5 Software Execution Model (SWA-02)

> Rendered from `Project/Model/Architecture/software/solution_strategy/SWSolutionStrategy.sysml`
> and `Project/Model/Architecture/software/architecture_decisions/ADR_009_SWExecutionModel.sysml`
> / `ADR_010_InputDebouncing.sysml`.

| Decision | ADR | Summary |
|---|---|---|
| Bare-metal, event-driven superloop | ADR-SW-009 | The main loop is an event dispatcher reacting to debounced input-changed events and a periodic 10 ms movement-supervision timer tick — not a flat polling loop. All seven firmware modules run as non-blocking event handlers invoked from the dispatcher, never blocking inside an ISR |
| Per-line GPIO interrupts + software debounce | ADR-SW-010 | Each of the four dry-contact input lines (local/remote up/down) has its own change-notification GPIO interrupt; `CommandArbitrationSoftware` confirms stability for `debounceConfirmMs` (30 ms) before raising a debounced event, complementing (not replacing) `RequestInterfaceCircuit`'s RC glitch filter. `arbitrationWindowMs` widened 50 ms → 100 ms as part of this decision |

**State-machine hosting assignment:** `SystemStates::ControllerLifecycleState`
is hosted on `ProductComponents::MovementSupervisorSoftware` — the sole
firmware module using strong (`:>`) ADR-007 coupling — via the
`MovementSupervisorSoftwareInternal` whitebox (see
[05-building-block-view.md §5.4](05-building-block-view.md)). Hosting means
this module structurally exhibits the state machine; every module still
coordinates entry/do/exit actions via the ADR-SW-009 dispatcher.

**Decomposition rationale:** the seven firmware `part def` boundaries fixed
by Product Architecture are reused unchanged as the internal seams for the
Software Building Block View. ADR-SW-011 (Software Layering) splits the
decomposition into three tiers: `CommandArbitrationSoftware` and
`MovementControlSoftware` receive full whitebox decomposition (the two
firmware-specific algorithms — debounce confirmation + conflict detection,
and command-to-request translation); `MovementSupervisorSoftware`,
`MotorDriveControlSoftware`, `UserFeedbackSoftware`, and
`MemoryManagerSoftware` receive driver-only whitebox decomposition (each
nests exactly one HAL/driver `part def` — see
[05-building-block-view.md §5.4](05-building-block-view.md)); only
`ConfigurationManagerSoftware` stays blackbox, its single documented
algorithm already fully captured at the Product Architecture level.

**Resource strategy outcome** (see
[07-deployment-view.md §7.4](07-deployment-view.md)): the aggregate firmware
footprint comfortably fits `ControlMCU`'s budget with the declared 10%
margin — 5600 B flash of a 14745.6 B ceiling, 216 B RAM of a 921.6 B
ceiling — so no module-boundary or execution-model change was forced by
resource pressure.
