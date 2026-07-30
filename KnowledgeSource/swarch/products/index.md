# Software Architecture Artifact

* [Software Architecture Constraints](architecture-constraints.md) (SWA-01) — Non-negotiable technical/resource constraints (MCU flash/RAM budget, execution model, timing) that bound the software design space, continuing SYSMOD's Base Architecture (SM-PRD-07) constraint pattern into the firmware level.
* [Software Solution Strategy](solution-strategy.md) (SWA-02) — The high-level technology and decomposition strategy for the firmware (execution model, concurrency approach, module decomposition rationale) bridging Product Architecture components to their internal software design.
* [Software Building Block View](building-block-view.md) (SWA-03) — Deeper whitebox decomposition (Level 4+) of individual firmware `part def` components already identified in Product Architecture — internal modules, algorithms, and data structures.
* [Software Runtime View](runtime-view.md) (SWA-04) — Firmware-level dynamic behaviour: task/loop scheduling, inter-module scenarios, interrupt handling, and state-machine execution traces.
* [Software Deployment View](deployment-view.md) (SWA-05) — Mapping of firmware building blocks onto the MCU's execution context: memory layout, flash/RAM budget allocation, and (if applicable) task/thread placement.
* [Software Cross-cutting Concepts](cross-cutting-concepts.md) (SWA-06) — Firmware-wide principles applied consistently across modules: error handling, state-machine binding conventions, persistence/EEPROM access patterns, timing/debounce conventions.
* [Software Architecture Decisions](architecture-decisions.md) (SWA-07) — ADRs specific to the software level (execution model choice, task vs. superloop, module boundaries) — extending the existing `ADR_NNN` pattern established in Base/Product Architecture.
