# 7. Deployment View

> Rendered from `model/Architecture/product/{ProductComponents,ProductArchitecture}.sysml`.

## 7.1 Infrastructure Level 1 — Overview

**Motivation:** ADR-006 collapses all non-electromechanical logic onto a
single low-cost 8-bit MCU (representative part: STM8S003F3P6-class,
`flashSizeKB = 16`, `internalRamBytes = 1024`) rather than fragmenting the
BOM across multiple hardware nodes, keeping the design within the
`costEffective` (≤50 PLN) and `compactDimensions` (≤40×40×20 mm) constraints.

**Quality/performance features:**
- Firmware resource headroom: 8 modules sum to 6300 bytes flash / 240 bytes
  RAM (illustrative PA-9 `estimatedFlashBytes`/`estimatedRamBytes`
  estimates), leaving ~10 KB flash / ~780 bytes RAM headroom under the
  16 KB / 1024-byte `ControlMCU` budget.
- `ProgrammingPort` (in-circuit SWIM/UART-bootloader style) supports
  manufacturing test/flash without a separate production fixture (REQ-Q-01).
- `LogicPowerRailPort` (3.3 V regulated) distributes logic power to every
  logic-level node from a single `PowerSupplyModule`.

## 7.2 Mapping — Building Blocks to Infrastructure Nodes

| Infrastructure Node | Hosted Software / Realizes | Notes |
|---|---|---|
| `ControlMCU` | `CommandArbitrationSoftware`, `MovementControlSoftware`, `ConfigurationManagerSoftware`, `MemoryManagerSoftware`, `MovementSupervisorSoftware`, `MotorDriveControlSoftware`, `UserFeedbackSoftware`, `DiagnosticsSoftware` | Single MCU, many-to-one hosting via allocation (ADR-007), not specialization |
| `localRequestInterface` / `remoteRequestInterface` (`RequestInterfaceCircuit` ×2) | — (hardware signal conditioning + opto-isolation) | Two instances of the same type; qualifies both simultaneously if second-sourced (mitigates RISK-SC-01) |
| `motorDriveRelayModule` (`MotorDriveRelayModule`) | Coil-driver stage only (firmware-driven via `RelayControlPort`) | `ratedCycleCount = 10000`, `mtbfHours = 100000.0` |
| `userNotificationBuzzer` (`AudibleNotificationBuzzer`) | — (passive piezo, driven via `BuzzerControlPort`) | ADR-008 |
| `powerSupplyModule` (`PowerSupplyModule`) | — (`:> BaseArchitecture::PowerModule`) | `mtbfHours = 200000.0`; sole distributor of `LogicPowerRailPort` |
| `enclosureAndConnectors` (`EnclosureAndConnectors`) | — (mechanical containment only, no signal port) | Houses every other node |

## 7.3 Infrastructure Level 2 — Node Connections

- System boundary → `localRequestInterface`/`remoteRequestInterface`
  (`ctrlIn`, port delegation).
- System boundary → `powerSupplyModule.controlPowerIn`;
  → `motorDriveRelayModule.mainsIn`.
- `motorDriveRelayModule.driveOut` → system boundary (`shutterDrive`).
- `localRequestInterface`/`remoteRequestInterface`.`digitalOut` →
  `controlMCU.{local,remote}RawIn` (conditioned digital signal).
- `controlMCU.relayOut` → `motorDriveRelayModule.coilIn`.
- `controlMCU.buzzerOut` → `userNotificationBuzzer.driveIn`.
- `powerSupplyModule.logicRailOut` → `controlMCU.powerIn`,
  `localRequestInterface.powerIn`, `remoteRequestInterface.powerIn`,
  `userNotificationBuzzer.powerIn`, `motorDriveRelayModule.coilPowerIn`.

`mainsPower` is routed only to `MotorDriveRelayModule`, which alone switches
it onward via `shutterDrive` — no other node touches mains voltage,
supporting `motorIsolation`/`inputIsolation`.
