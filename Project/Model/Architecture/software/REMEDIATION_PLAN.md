# Software Architecture Review — Remediation Plan (Pass 3)

Supersedes Pass 2's "READY" verdict (Pass 2's 13-item plan, and Pass 1's
18-item plan before it, are both implemented; preserved as history below).
This pass addresses the 11 new findings (SWR-042…SWR-052) from the third,
independent pedantic re-review recorded in `REVIEW_FINDINGS.md` — two signal
chains (install→fault, simultaneous-hold→config-mode/motor-safety) that
neither prior pass traced end-to-end. Numbered action items, grouped into
phases only where a real dependency exists. Each item: **What** / **Where**
/ **Resolves**. Bullets only — no paragraphs.

## Phase 1 — Install → verify → fault path (blocks SDD handoff for UC_02)

1. **What:** Add a bounded retry to `InstallController`: introduce an explicit second-attempt action (e.g. `action def RetryVerifyWorking`) with a retry counter/limit, and an explicit failure branch that exits the loop after the bound instead of looping forever.
   **Where:** `Analysis/use_case_activities/UCActivities.sysml` — `InstallController`.
   **Resolves:** SWR-043.

2. **What:** Add `action def ReportInstallationFault` (signature-only) and have the retry action from item 1 actually produce `InstallationVerified`/`InstallationFaultReported`; replace the fictional `retryVerifyWorking` citations elsewhere with the new action's real name.
   **Where:** `Analysis/use_case_activities/UCActivities.sysml`; update citations in `cross_cutting_concepts/SWEventCatalog.sysml`, `Architecture/scenarios/Scenarios.sysml`, `Verification/test_cases/SystemTestCases.sysml`.
   **Resolves:** SWR-042, SWR-043.

## Phase 2 — `MovementDirection::both` safety chain (Critical, REQ-S-01)

3. **What:** Add an explicit `both`-direction guard to `DetermineMovementRequest` so `passThrough` can never carry `direction==both` (route it to `suppressMovement` or a new dedicated branch).
   **Where:** `Analysis/use_case_activities/UCActivities.sysml` — `DetermineMovementRequest`.
   **Resolves:** SWR-044 (source half).

4. **What:** Add an explicit `both`-direction guard to `StartShutterMovement`'s `decide` (route to `suppressMotor`, not just `direction==none`) so `activateMotor` can never fire for `both`.
   **Where:** `Analysis/use_case_activities/UCActivities.sysml` — `StartShutterMovement`.
   **Resolves:** SWR-044 (state-machine-entry half).

5. **What:** Add a structural enforcement (`require constraint` or explicit guarded assign) inside `MotorRelayOutputDriver` that guarantees both coils are never asserted together, replacing the current doc-only claim.
   **Where:** `building_block_view/SWBuildingBlocks.sysml` — `MotorRelayOutputDriver`.
   **Resolves:** SWR-044 (driver half — final safety net).

## Phase 3 — Configuration-mode trigger & routing (REQ-F-07/F-08)

6. **What:** Realize `DetermineConfigurationMode` at the Functional layer (alongside `parseRequest : DetermineMovementRequest`) and at the Software layer, giving the config-mode trigger a traceable realization path instead of stopping at Use Case Activities.
   **Where:** `Architecture/functional/FunctionalArchitecture.sysml`, `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-045.

7. **What:** Add a `ConfigModeEvent` flow (or a second, distinct event) from `ConfigurationManagerSoftware`/`logicalControlUnit` to `MovementSupervisorSoftware`/`logicalMovementSupervisor` at both Logical and Product layers, giving `AssessingSimultaneousHold`/`ConfigurationMode`'s `accept ConfigModeEvent` transitions a real producer reaching the state-machine host.
   **Where:** `Architecture/logical/LogicalArchitecture.sysml`, `Architecture/product/ProductComponents.sysml`, `Analysis/domain/DomainKnowledge.sysml` (if a second flow def is needed).
   **Resolves:** SWR-046.

## Phase 4 — arc42 diagnostics cleanup (independent — do anytime)

8. **What:** Remove/correct every remaining `DiagnosticsSoftware`/`LogicalDiagnostics`/`FaultIndicationPort`/`FaultClass` reference to match the model (component permanently removed per `PLAN.md`), mirroring the correction already applied to `09-architecture-decisions.md`.
   **Where:** `Project/Documentation/arc42/05-building-block-view.md` §5.2/§5.3, `06-runtime-view.md` Scenario 10, `07-deployment-view.md` §7.2, `08-cross-cutting-concepts.md` Concept 5, `10-quality-requirements.md` verification table.
   **Resolves:** SWR-047.

## Phase 5 — Event-routing port discipline

9. **What:** Give `EventDispatcher` proxy ports (e.g. one `in`/`out` port pair per event kind) and reroute `SWBuildingBlocks.sysml`'s raw attribute-flows through them, mirroring `CrossLifecycleEventRelay`'s port-mediated pattern.
   **Where:** `cross_cutting_concepts/SWEventCatalog.sysml`, `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-048.

## Phase 6 — Constraint & documentation nits

10. **What:** Either add a real ISR-execution-time estimate/attribute and check it against `isrExecutionBudgetMs`, or rewrite the constraint's `doc` to state it only fixes the *budget value*, not a verified execution time (defer verification to SDD/measurement).
    **Where:** `architecture_constraints/SWConstraints.sysml` — `Timing::isrLatencyBudget`.
    **Resolves:** SWR-049.

11. **What:** Fix the `determineConfiguratedMode` → `determineConfigurationMode` naming typo.
    **Where:** `Analysis/use_case_activities/UCActivities.sysml:172`.
    **Resolves:** SWR-050.

12. **What:** Clarify `GpioInputDriver`'s doc to state it owns 2 ports each carrying an up/down pair (4 lines total), not 4 discrete ports.
    **Where:** `building_block_view/SWBuildingBlocks.sysml` — `GpioInputDriver`.
    **Resolves:** SWR-051.

13. **What:** Add `flow`/binding statements realizing `lastLocalEdgeMs`/`lastRemoteEdgeMs`'s use in the conflict-window comparison, or remove the attributes if truly SDD-deferred (state which, explicitly).
    **Where:** `building_block_view/SWBuildingBlocks.sysml` — `CommandArbitrationSoftwareInternal`.
    **Resolves:** SWR-052.

---

## Status — Pass 4: all 13 items independently re-verified as implemented

A follow-up pass re-read the actual `.sysml`/arc42 files (not this plan's
stale status line) for all 13 items above and confirmed every one is
genuinely implemented — see `REVIEW_FINDINGS.md`'s "Pass 4 — Independent
Re-Verification" section for file:line evidence per item.

One additional, real gap was found during that re-check (not a Pass 3 item):
**SWR-024** (Pass 1) was marked "Closed" but its claimed fix — `Traceability.sysml`
importing 10 `SWA-0x` packages and adding ~17 `Derivation` links — did not
actually exist in the file. It has now been fixed for real: 3 imports
(`SWRuntimeScenarios`, `SWEventCatalog`, `SWResourceBudget`) and 6
`connection : Trace` links were added, registering the software runtime
scenarios, firmware events, and resource budget against already-traced
main-model elements.

A final conciseness pass also stripped ~65 `(resolves SWR-0NN)` tracking
parentheticals from `doc`/comment text across all 7 software files (comment-
only, no structural change), per the "simple, compact, easy to understand"
baseline requirement.

**0 Critical / 0 Major / 0 Minor open — READY for baseline.**

---

## History — Pass 2 (13 items, implemented; verdict superseded by Pass 3 above)

Pass 2 closed SWR-031…041 and declared "READY". Pass 3 found new gaps in
parts of the model Pass 2 did not touch (install/fault path, config-mode
trigger chain, arc42 diagnostics remnants) — none of Pass 2's own closures
are contradicted; see `REVIEW_FINDINGS.md` for the spot-check note.

## Phase 1 — Wire the whitebox internal data flow (blocks everything else)

1. **What:** Add `flow` statements binding `CommandArbitrationSoftwareInternal`'s internal actions end-to-end: `gpioInputDriver.rawLocalIn.up/down` → `confirmLocalUp/confirmLocalDown.rawLevel` (and the `remote` equivalents); each `confirmed*.confirmedLevel` → `arbitrateChannels`' corresponding input; `arbitrateChannels`' output → `commandOut`/`commandRelayOut`.
   **Where:** `building_block_view/SWBuildingBlocks.sysml` — `CommandArbitrationSoftwareInternal`.
   **Resolves:** SWR-031, SWR-041 (partial).

2. **What:** Add `flow` statements binding `MovementControlSoftwareInternal.translateCommand`: `commandIn` → `translateCommand.command`, `translateCommand.request` → `requestOut`.
   **Where:** `building_block_view/SWBuildingBlocks.sysml` — `MovementControlSoftwareInternal`.
   **Resolves:** SWR-031.

## Phase 2 — Realize event production/consumption (depends on Phase 1)

3. **What:** Give `ConfirmInputDebounce` (or a wrapping action) an `out` parameter typed `DebouncedInputChanged`, and `flow` it from each `confirm*` action into `arbitrateChannels`/`eventDispatcher`; add matching `flow` from `TimerDriver.producedEvent` into `eventDispatcher`.
   **Where:** `building_block_view/SWBuildingBlocks.sysml`, `cross_cutting_concepts/SWEventCatalog.sysml`.
   **Resolves:** SWR-032 (production half).

4. **What:** Either (a) add `accept DebouncedInputChanged`/`accept TimerTick` clauses where these events are actually consumed, replacing the native `accept after <duration>` timeout usages where equivalent, or (b) if `accept after` is kept as the authoritative mechanism, revise `EventCatalogMeta`'s `consumer` fields for `TimerTick`/`DebouncedInputChanged` to say so explicitly instead of claiming an unmodeled consumption path.
   **Where:** `Architecture/states/SystemStates.sysml`, `cross_cutting_concepts/SWEventCatalog.sysml`.
   **Resolves:** SWR-032 (consumption half).

## Phase 3 — Wire EventDispatcher (depends on Phase 2)

5. **What:** Add `connect`/`flow` from every event producer (`GpioInputDriver`/`ConfirmInputDebounce`, `TimerDriver`) into `eventDispatcher`'s `pendingDebouncedInputChanged`/`pendingTimerTick`, and from `eventDispatcher` out to each documented consumer (`arbitrateChannels`, `monitorStopCondition`, `monitorUserInterruption`).
   **Where:** `cross_cutting_concepts/SWEventCatalog.sysml`, `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-033.

## Phase 4 — Deployment view completeness

6. **What:** Add `ExecutionContext` metadata (`"main-loop"` or `"isr:<name>"`) to `motorDriveControlSoftwareInternal`, `userFeedbackSoftwareInternal`, `memoryManagerSoftwareInternal`, and their nested drivers.
   **Where:** `deployment_view/SWResourceBudget.sysml`.
   **Resolves:** SWR-034.

## Phase 5 — Cross-cutting concept markers

7. **What:** Add a checkable `metadata def` for each of Concepts 2–4 (e.g. `SharedTimingSourceMeta`, `EventDispatcherExecutionMeta`, `SingleOwnerEepromMeta`) and apply to the relevant `part def`s, mirroring Concept 1's `NoDynamicAllocationMeta` pattern.
   **Where:** `cross_cutting_concepts/SWCrossCuttingConcepts.sysml`.
   **Resolves:** SWR-035.

## Phase 6 — arc42 publication sync

8. **What:** Add an "ADR-SW-011 — Software Layering" subsection (context/decision/consequences/alternatives/rationale) to the Software Architecture Decisions section, alongside ADR-SW-009/010.
   **Where:** `Project/Documentation/arc42/09-architecture-decisions.md`.
   **Resolves:** SWR-036 (ADR half).

9. **What:** Add the 5 drivers (`GpioInputDriver`, `TimerDriver`, `MotorRelayOutputDriver`, `BuzzerOutputDriver`, `EepromDriver`) and the event catalog/`EventDispatcher` as Level 4 whitebox sub-sections.
   **Where:** `Project/Documentation/arc42/05-building-block-view.md`, `08-cross-cutting-concepts.md`.
   **Resolves:** SWR-036 (driver/event-catalog half).

10. **What:** Remove/correct the stale `DiagnosticsSoftware`/`LogicalDiagnostics` references in the ADR-004/006/007 renderings to match the model (component permanently removed per `Architecture/software/PLAN.md`).
    **Where:** `Project/Documentation/arc42/09-architecture-decisions.md`.
    **Resolves:** SWR-037.

## Phase 7 — HSM completeness

11. **What:** Add an explicit `accept PowerLost via crossLifecycleEventRelay then Unpowered;` (or equivalent) to `Installing`, or document why installation-phase power loss is intentionally unhandled (e.g. covered by the bounded single-retry install procedure).
    **Where:** `Architecture/states/SystemStates.sysml` — `Installing`.
    **Resolves:** SWR-039.

## Phase 8 — Housekeeping

12. **What:** Either rename `decisionId` values to `"ADR-009"`/`"ADR-010"`/`"ADR-011"` to match the documented crossmapping convention, or update `KnowledgeSource/swarch/crossmapping/architecture-decisions.md`'s worked example to explicitly sanction the `"ADR-SW-0NN"` format used project-wide — pick one and make them consistent.
    **Where:** `architecture_decisions/ADR_009_SWExecutionModel.sysml`, `ADR_010_InputDebouncing.sysml`, `ADR_011_SoftwareLayering.sysml`, or the crossmapping doc.
    **Resolves:** SWR-038.

13. **What:** Confirmed self-correcting — `REVIEW_FINDINGS.md` (this pass) already closes/corrects prior SWR-017 in its "Prior-pass findings" note. No further action needed.
    **Where:** `Architecture/software/REVIEW_FINDINGS.md`.
    **Resolves:** SWR-040.

---

## Pass 2's own status note (historical — verdict superseded by Pass 3 above)

All 13 Pass-2 items were implemented across `.sysml` model files, arc42
publication docs, and the `KnowledgeSource` crossmapping doc (see
`REVIEW_FINDINGS.md`'s Pass-2 `Status` column for the per-finding
disposition). Pass 2 declared **0 Critical / 0 Major / 0 Minor open — READY
for SDD handoff** on the strength of closing all 11 of its own findings plus
the 2 Minor items carried over from Pass 1 (`SWR-017`, `SWR-027`). That
verdict stood only for the ground Pass 2 covered — Pass 3 (top of this file)
found 11 new findings in parts of the model neither prior pass traced, and
the current, authoritative verdict is Pass 3's: **NOT READY**.

---

## History — Pass 1 (18 items, implemented)

## Phase 1 — Record the layering decision (do first — everything else depends on it)

1. **What:** Add `ADR-SW-011` — "Software Layering: Application / Driver-HAL / Hardware", stating no Application module may touch a hardware-facing port directly.
   **Where:** `architecture_decisions/ADR_011_SoftwareLayering.sysml`.
   **Resolves:** SWR-001, SWR-004.

## Phase 2 — Event catalog + dispatcher element

2. **What:** Create one `attribute def` table for every event (add the two missing: `DebouncedInputChanged`, `TimerTick`; list the six already-modeled `SystemStates.sysml` events alongside them with producer/consumer/trigger columns).
   **Where:** new `cross_cutting_concepts/SWEventCatalog.sysml`.
   **Resolves:** SWR-014, SWR-015, SWR-016.

3. **What:** Add `part def EventDispatcher` as the structural home for ADR-SW-009's "dispatcher" prose; wire `DebouncedInputChanged`/`TimerTick` production→consumption through it (mirrors `CrossLifecycleEventRelay`'s pattern).
   **Where:** `cross_cutting_concepts/SWEventCatalog.sysml` (same file as #2).
   **Resolves:** SWR-018.

## Phase 3 — Driver layer + inventory (depends on Phase 1 ADR, Phase 2 events)

4. **What:** Add `GpioInputDriver` nested under `CommandArbitrationSoftwareInternal`; route `localRawIn`/`remoteRawIn` through it before `ConfirmInputDebounce`.
   **Where:** `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-006.

5. **What:** Add `TimerDriver` nested under `MovementSupervisorSoftwareInternal`, producing the `TimerTick` event from Phase 2.
   **Where:** `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-007, SWR-016.

6. **What:** Decompose `MotorDriveControlSoftware` into a new `MotorDriveControlSoftwareInternal` with nested `MotorRelayOutputDriver` (owns `upCoil`/`downCoil` break-before-make).
   **Where:** `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-002 (partial), SWR-008.

7. **What:** Decompose `UserFeedbackSoftware` into `UserFeedbackSoftwareInternal` with nested `BuzzerOutputDriver`.
   **Where:** `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-002 (partial), SWR-009.

8. **What:** Decompose `MemoryManagerSoftware` into `MemoryManagerSoftwareInternal` with nested `EepromDriver`, realizing Cross-cutting Concept 4's "single-owner EEPROM access".
   **Where:** `building_block_view/SWBuildingBlocks.sysml`.
   **Resolves:** SWR-002 (partial), SWR-010.

9. **What:** Keep every driver signature-free — existence, responsibility, and layer placement only; no method/API design.
   **Where:** applies to items 4–8 above.
   **Resolves:** SWR-011 (scope guard).

10. **What:** Update Phase 4's "2 modules" scoping note to reflect 5 modules now decomposed.
    **Where:** `Architecture/software/PLAN.md`.
    **Resolves:** SWR-013.

## Phase 4 — Hierarchical state machine (independent — may run in parallel with Phases 1–3)

11. **What:** Introduce a composite super-state `Operational` grouping `Idle`, `AssessingSimultaneousHold`, `MovingAutomatic`, `MovingManual`, `ConflictSuppressed`, `ConfigurationMode`; hoist the single `accept PowerLost via crossLifecycleEventRelay then Unpowered` onto `Operational` once, removing the 4 duplicates.
    **Where:** `Architecture/states/SystemStates.sysml` — `ControllerLifecycleState`.
    **Resolves:** SWR-019, SWR-020, SWR-021.

12. **What:** Resolve the open gap — name the structural owner of `MovingManual`'s latched-stopped-until-release guard — before declaring the HSM complete.
    **Where:** `Architecture/states/SystemStates.sysml` — `MovingManual`.
    **Resolves:** SWR-022.

13. **What:** Add one summary table listing both `exhibit state` hosts (`RollerShutterControllerWithLifecycle` at Logical layer, `MovementSupervisorSoftwareInternal` at Product/Software layer) side by side, confirming deliberate reuse.
    **Where:** `Architecture/states/SystemStates.sysml` package doc.
    **Resolves:** SWR-023.

## Phase 5 — Traceability wiring (do after Phases 1–4 settle the final file set)

14. **What:** Import all `SWA-0x` packages (`ADR_009_SWExecutionModel`, `ADR_010_InputDebouncing`, `ADR_011_SoftwareLayering`, `SWConstraints`, `SWBuildingBlocks`, `SWEventCatalog`, `SWRuntimeScenarios`, `SWResourceBudget`, `SWCrossCuttingConcepts`, `SWSolutionStrategy`) into `Traceability.sysml`; register `refines`/`depends_on` connections per `swarch/crossmapping/*.md` §4 tables.
    **Where:** `Traceability/Traceability.sysml`.
    **Resolves:** SWR-024.

## Phase 6 — Documentation conciseness pass

15. **What:** Split the single ~100-line `doc` block into ≤5-line per-topic docs (one per sub-topic: constraints, ADR-010 recap, ADR-009 recap, decomposition rationale, state-hosting, resource outcome).
    **Where:** `solution_strategy/SWSolutionStrategy.sysml`.
    **Resolves:** SWR-026.

16. **What:** Trim the header comment to a 1–2 line pointer to `PLAN.md` instead of restating it.
    **Where:** `building_block_view/SWBuildingBlocks.sysml` lines 1–16.
    **Resolves:** SWR-028.

17. **What:** Apply the same ≤5-line doc-field discipline to every new element created in Phases 1–5; defer retroactive tightening of `ADR_001`–`010`'s prose fields to a separate, explicitly-scoped cleanup pass.
    **Where:** all new files above.
    **Resolves:** SWR-027.

## Phase 7 — Housekeeping

18. **What:** Add an `Architecture/software/` row to the documented model tree; decide lowercase-vs-PascalCase and rename the folder if lowercase is chosen, for consistency with every sibling folder.
    **Where:** `Project/Model/README.md`.
    **Resolves:** SWR-025.

---

## Status — all 7 phases implemented; final adversarial re-review complete

All 18 items above are implemented in `.sysml` model files (see
`REVIEW_FINDINGS.md`'s `Status` column for the per-finding disposition).
The Step 4 final acceptance pass surfaced 2 new findings (`SWR-029`,
`SWR-030`) — both self-inflicted documentation staleness from earlier
phases — and both were fixed immediately during that same pass.

**0 Critical / 0 Major / 2 Minor open — READY for SDD handoff.** The 2 open
Minor items are intentionally deferred by design, not overlooked:
- `SWR-017` (fork/merge internal structure) — out of this plan's scope;
  candidate for a future, separately-scoped `UseCaseActivities.sysml` pass.
- `SWR-027` (retroactive `ADR_001`–`010` prose tightening) — explicitly
  deferred per item 17 above to a separate, explicitly-scoped cleanup pass.
