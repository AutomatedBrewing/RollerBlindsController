# 7. Deployment View

> Rendered from `Project/Model/Architecture/product/{ProductComponents,ProductArchitecture}.sysml`.

## 7.1 Infrastructure Level 1 — Overview

**Motivation:** ADR-006 collapses all non-electromechanical logic onto a
single low-cost 8-bit MCU (representative part: STM8S003F3P6-class,
`flashSizeKB = 16`, `internalRamBytes = 1024`) rather than fragmenting the
BOM across multiple hardware nodes, keeping the design within the
`costEffective` (≤50 PLN) and `compactDimensions` (≤40×40×20 mm) constraints.

**Quality/performance features:**
- Firmware resource headroom: 7 modules sum to 5600 bytes flash / 216 bytes
  RAM (`estimatedFlashBytes`/`estimatedRamBytes` estimates), leaving margin
  under the 16 KB / 1024-byte `ControlMCU` budget (authoritative check: §7.4
  below).
- `ProgrammingPort` (in-circuit SWIM/UART-bootloader style) supports
  manufacturing test/flash without a separate production fixture (REQ-Q-01).
- `LogicPowerRailPort` (3.3 V regulated) distributes logic power to every
  logic-level node from a single `PowerSupplyModule`.

## 7.2 Mapping — Building Blocks to Infrastructure Nodes

| Infrastructure Node | Hosted Software / Realizes | Notes |
|---|---|---|
| `ControlMCU` | `CommandArbitrationSoftware`, `MovementControlSoftware`, `ConfigurationManagerSoftware`, `MemoryManagerSoftware`, `MovementSupervisorSoftware`, `MotorDriveControlSoftware`, `UserFeedbackSoftware` | Single MCU, many-to-one hosting via allocation (ADR-007), not specialization |
| `localRequestInterface` / `remoteRequestInterface` (`RequestInterfaceCircuit` ×2) | — (hardware signal conditioning + opto-isolation) | Two instances of the same type; qualifies both simultaneously if second-sourced |
| `motorDriveRelayModule` (`MotorDriveRelayModule`) | Coil-driver stage only (firmware-driven via `RelayControlPort`) | `ratedCycleCount = 10000`, `mtbfHours = 100000.0` |
| `userNotificationBuzzer` (`AudibleNotificationBuzzer`) | — (active, self-oscillating piezo, driven via `BuzzerControlPort`) | ADR-008 |
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

## 7.4 Software-Level Infrastructure Detail (SWA-05)

> Rendered from `Project/Model/Architecture/software/deployment_view/SWResourceBudget.sysml`.
> Authoritative flash/RAM footprint check and MCU resource inventory,
> continuing §7.1 below the hardware-topology level.

### Flash/RAM budget (authoritative)

| Module | Flash (B) | RAM (B) |
|---|---|---|
| `CommandArbitrationSoftware` | 1200 | 48 |
| `MovementControlSoftware` | 400 | 16 |
| `ConfigurationManagerSoftware` | 700 | 24 |
| `MemoryManagerSoftware` | 900 | 32 |
| `MovementSupervisorSoftware` | 1000 | 40 |
| `MotorDriveControlSoftware` | 600 | 24 |
| `UserFeedbackSoftware` | 800 | 32 |
| **Total** | **5600** | **216** |
| Budget (90% of ceiling) | 14745.6 | 921.6 |
| Margin | ~9145.6 | ~705.6 |

Both totals comfortably pass with the SWA-01-declared 10% safety margin.

### GPIO pin assignment

Of `gpioCount` (14 pins): 4 are ADR-SW-010's change-notification inputs
(local/remote up/down); 2 drive `RelayControlPort`'s `upCoil`/`downCoil`;
1 drives `BuzzerControlPort`'s `buzzerOn`. That accounts for 7 of the 14
pins; of the 10 non-change-notification pins, 3 are used (relay + buzzer),
leaving 7 for `progPort` (production-only SWIM/UART bootloader) and design
margin.

### Timer/peripheral usage

A single periodic timer peripheral, ticking at `timerResolutionMs` (10 ms,
ADR-003/ADR-SW-009), drives both movement-timeout/hold-to-run supervision
and the superloop's periodic re-check of pending debounce-confirmation
bookkeeping (ADR-SW-010) — no second timer peripheral is needed. Combined
with the four GPIO change-notification interrupts, the MCU uses exactly
five physical interrupt lines in total (grouped into two ISR categories —
`isr:timerTick` and `isr:gpioChangeNotification` — for execution-context
tagging purposes, see below).

### Execution-context placement

Every internal action currently modeled in the Software Building Block View
(`confirmLocalUp/Down`, `confirmRemoteUp/Down`, `arbitrateChannels`,
`translateCommand`, and the exhibited lifecycle machine's own entry/do/exit
actions) executes in dispatcher (main-loop) context — tagged
`@ExecutionContext { context = "main-loop"; }`. ADR-SW-009 deliberately
keeps every ISR body minimal (flag/timestamp updates only) and unmodeled as
its own action def; the two ISR categories are enumerated as raw MCU
resources above instead.
