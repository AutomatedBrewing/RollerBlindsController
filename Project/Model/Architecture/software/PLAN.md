# Software Architecture — Plan

## Context

SYSMOD stops at **Product Architecture** (SM-PRD-21): it identifies *that*
firmware modules exist (`ProductComponents::CommandArbitrationSoftware`,
`MovementControlSoftware`, `MotorDriveControlSoftware`,
`MovementSupervisorSoftware`, `ConfigurationManagerSoftware`,
`MemoryManagerSoftware`, `UserFeedbackSoftware`, all
hosted on `ControlMCU`) and *what* data flows between them. SYSMOD has no
method beyond this point.

This folder continues the model past that point using **arc42's own
mechanism for going deeper: the iterative, recursive Building Block View**
(whitebox Level 1 → Level 2 → Level 3 → ...). arc42 remains the *target
publication format* — the SysML v2 model below is still the single source
of truth; only the modeling elements change (from "which module talks to
which" to "how is each module actually organized internally, executed, and
fitted into the MCU's resource budget"). No new SYSMOD product is invented;
every element created here traces back to an existing `ProductComponents`
`part def`.

## Scope

In scope: the internal software design of the seven firmware modules
already declared in Product Architecture, their execution model, their
binding to the existing `SystemStates::ControllerLifecycleState` state
machine, and their mapping onto `ControlMCU`'s resource budget
(flash/RAM/GPIO/timers).

Out of scope (unchanged, not revisited): Use Cases, Use Case Activities,
Functional Architecture, Logical Architecture, and the *existence* of the
seven Product-layer firmware components — this work decomposes them
further, it does not re-derive or rename them. (The diagnostics/service
scope -- an eighth module, `DiagnosticsSoftware`, and its
`DiagnosticState`/`diagnosticLifecycle` state machine -- was removed from
the model entirely in the behavior-clarification pass; see
Requirements.sysml, Stakeholders.sysml, ProductComponents.sysml,
SystemStates.sysml. It is out of scope permanently, not merely deferred.)

## Workspace (created now)

```
Architecture/software/
  architecture_decisions/     ← ADR-0xx for SW-specific decisions (ARC-09)
  architecture_constraints/   ← SW-specific constraints: timing, memory, coding rules (ARC-02)
  building_block_view/        ← Level 3/4 whitebox decomposition of firmware modules (ARC-05)
  runtime_view/               ← Key SW scenarios / sequences (ARC-06)
  deployment_view/            ← Flash/RAM/GPIO/timer budget on ControlMCU (ARC-07)
  cross_cutting_concepts/     ← Shared SW patterns: state-machine execution, error handling, persistence (ARC-08)
  solution_strategy/          ← Summary of fundamental SW approach decisions (ARC-04)
  PLAN.md                     ← this file
```

Sections already covered globally and NOT duplicated here:
`introduction_and_goals`, `context_and_scope`, `quality_requirements`,
`risks_and_technical_debts`, `glossary` (system-level, already populated
from Analysis/ outputs).

## Guiding principle

Each phase below produces `.sysml` file(s) in the matching subfolder above,
following the same one-file-per-product / explicit-import conventions as
the rest of the model (`.github/instructions/sysml-modeling.instructions.md`),
and is written up in the corresponding `Documentation/arc42/0N-*.md` section
once the model content is stable.

## Phased plan (execute in order — later phases depend on earlier decisions)

### Phase 1 — Execution model decision (`architecture_decisions/`)
Decide and record as an ADR how the firmware is actually scheduled on
`ControlMCU`: bare-metal super-loop with polling, cooperative round-robin
scheduler, or interrupt-driven state machine dispatch. This determines how
the already-modeled `accept`/`do` actions in `SystemStates.sysml` are
actually triggered at runtime (timer tick? GPIO interrupt? polled flag?),
and constrains every module's internal design below it. Must consider the
already-fixed constraints: 8-bit MCU, 16 KB flash, 1 KB RAM, 16 MHz clock
(`ProductComponents::ControlMCU`), and the timer-based movement supervision
already decided in `ADR_003_TimeBased`.

### Phase 2 — SW-specific architecture constraints (`architecture_constraints/`)
Record constraints that flow from Phase 1 and from the existing hardware
attributes: max stack depth, ISR latency budget, coding-standard
constraints (if any, e.g. MISRA-C subset), determinism requirements for
the state machine dispatcher validated earlier in `SystemStates.sysml`
(Traceability Rule 6 — mutually exclusive guards).

### Phase 3 — Bind state machines to firmware modules (`building_block_view/`)
Attach `exhibit state` usages from the existing `SystemStates::
ControllerLifecycleState` state def onto the concrete firmware `part def`
that owns it (most likely `MovementSupervisorSoftware` for the lifecycle
machine — to be confirmed against responsibilities in
`ProductComponents.sysml`). No new states are introduced; this phase only
wires the existing state model onto the existing Product components.

### Phase 4 — Internal decomposition of complex modules (`building_block_view/`)
For the modules with the most internal complexity (`CommandArbitrationSoftware`
— arbitration + conflict detection; `MovementControlSoftware` — command-to-
request translation), decompose into Level-3/4 whitebox building blocks
(`part def`/`action def` for internal sub-functions).

**Updated (remediation Phase 3, resolves SWR-013):** the "2 modules" scope above
is now stale — the software-architecture-remediation pass (ADR-SW-011 layering)
decomposed **5 modules** in total, each with exactly one nested Driver/HAL
`part def`: `CommandArbitrationSoftware` (`GpioInputDriver`),
`MovementSupervisorSoftware` (`TimerDriver`), `MotorDriveControlSoftware`
(`MotorRelayOutputDriver`), `UserFeedbackSoftware` (`BuzzerOutputDriver`), and
`MemoryManagerSoftware` (`EepromDriver`). `ConfigurationManagerSoftware` stays
blackbox — a documented choice (`SWSolutionStrategy.sysml`), not a silent gap,
since it owns no hardware-facing port.

### Phase 5 — Runtime scenarios (`runtime_view/`)
Model 2-4 key SW-level sequences building on the existing
`Architecture/scenarios/Scenarios.sysml` (e.g. movement request handling
end-to-end, simultaneous-hold conflict handling, configuration-mode entry)
at the firmware-module level, showing actual call/flow order across the
Phase 3/4 building blocks.

### Phase 6 — Resource budget (`deployment_view/`)
Map every firmware module onto `ControlMCU`'s budget: estimated flash
bytes, RAM bytes (extending the existing `estimatedRamBytes` attributes
already referenced in `ProductComponents.sysml` PA-9 fix), GPIO pin
assignment, and timer/peripheral usage. Validate the sum against
`ControlMCU.flashSizeKB` / `internalRamBytes`.

### Phase 7 — Cross-cutting SW concepts (`cross_cutting_concepts/`)
Document shared patterns used across modules: how EEPROM persistence is
accessed (`MemoryManagerSoftware`), how the state-machine dispatch pattern
from Phase 1 is applied uniformly, and any shared timing/debounce utility
pattern reused across modules.

### Phase 8 — Solution strategy summary (`solution_strategy/`)
Summarize the fundamental SW approach (execution model, module boundaries,
state-machine binding, resource strategy) as the arc42 §4-equivalent
narrative, cross-referencing the ADRs from Phase 1 and the constraints from
Phase 2.

### Phase 9 — Documentation sync
Populate `Documentation/arc42/04-solution-strategy.md`,
`05-building-block-view.md`, `06-runtime-view.md`, `07-deployment-view.md`,
`08-cross-cutting-concepts.md`, `09-architecture-decisions.md`,
`02-architecture-constraints.md` with rendered content from the phases
above (arc42 as target publication, not a parallel document).

## Notes / open questions to resolve before modeling starts

- Confirm which firmware module actually owns `exhibit state
  systemLifecycle` — currently `SystemStates.sysml` does not yet exhibit
  this on any `ProductComponents` part (to be resolved in Phase 3).
- Confirm whether an RTOS is even a realistic candidate given the 1 KB RAM
  budget, or whether Phase 1 should treat bare-metal vs. cooperative
  scheduler as the only two real alternatives.
- No new Product-layer components are anticipated; if Phase 4 reveals a need
  for one, ADR-007's coupling rules apply unchanged.
