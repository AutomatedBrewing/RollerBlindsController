# 4. Solution Strategy

> Rendered from `model/Architecture/base/ADR_*.sysml` and
> `model/Analysis/problem/SystemIdea.sysml`.

## 4.1 Fundamental Technology / Architectural Style Decisions

| Decision | ADR | Summary |
|---|---|---|
| Cost-driven simplicity | ADR-001 | Target < 50 PLN BOM via relay-based motor switching and dry-contact I/O (originally "no MCU"); enclosure/isolation choices flow from this |
| Time-based, sensorless positioning | ADR-003 | No position sensor; timing-profile-driven movement supervision. Accepts RISK-T-01 (positioning drift) as residual risk, mitigated by a +5s margin convention |
| Single 8-bit MCU platform | ADR-006 | Partially supersedes ADR-001's "no MCU" clause: one low-cost MCU (`ControlMCU`, STM8S003F3P6-class) hosts 8 firmware modules, replacing a fragile discrete-timer design while keeping relay switching and dry-contact-only I/O unchanged |
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
2. **Functional Architecture** — 9 technology-independent Functional
   Elements derived from Use Case Activities (see
   [05-building-block-view.md](05-building-block-view.md) §Level 1).
3. **Logical Architecture** — 7 components; loosely allocated from
   Functional Elements (ADR-004), strongly coupled (`:>`) to Base
   Architecture where a 1:1 counterpart exists.
4. **Product Architecture** — 7 hardware components hosting 8 firmware
   modules on the single MCU (ADR-006/ADR-007), loosely allocated from
   Logical components wherever ADR-006's software split crosses one
   Logical component into multiple Product components.

## 4.3 Quality Goal Achievement

| Quality Goal (§1.2) | Strategy |
|---|---|
| Safety | Galvanic isolation constraints (`motorIsolation`, `inputIsolation`); UP+DOWN conflict suppression (`DetermineMovementRequest`/`CommandArbitrationSoftware`) with mandatory user-observable indication (REQ-S-02, ADR-008 buzzer) |
| Reliability | Relay/triac components rated ≥10,000 switching cycles (mitigates RISK-T-03); verified by `Verification::Quality::VerifyReliability` |
| Availability | ADR-002: passive hardware-MTBF realization, no dedicated behavioral sub-system |
| Ease of Installation | Explicit, signaled configuration mode (REQ-F-08); guided calibration procedure with out-of-range rejection (MAJ-8 fix, `RejectOutOfRangeCalibration`) |
| Diagnosability / Field Replaceability | `LogicalDiagnostics`/`DiagnosticsSoftware` fault classification (`FaultClass`: `noResponseToControlInput`, `motorDriveFault`); single shared wiring across install/repair (REQ-Q-05) |

## 4.4 Constraint Adherence

- Cost (`costEffective` ≤ 50 PLN): `ProductArchitecture::totalUnitCostPLN =
  14.5`, asserted `<= 50.0`.
- Compact size (`compactDimensions`): single-PCB, single-MCU design (ADR-006)
  keeps the BOM within a ⌀60 flush-mount enclosure.
- No position feedback (`noPositionFeedback`/`timeBasedOperation`): enforced
  architecturally — no Functional Element, Logical, or Product component
  reads shutter position; only elapsed time (`TravelTime`, `TravelTime`).
