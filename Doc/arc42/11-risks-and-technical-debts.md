# 11. Risks and Technical Debt

> Rendered from `model/Analysis/risks/Risks.sysml`
> (`@RiskMeta`: probability × impact → severity matrix) and
> `// GAP:` comments in `model/Architecture/scenarios/Scenarios.sysml`.

## Risk Register

| ID | Category | Risk | Prob. | Impact | Severity | Status | Owner | Mitigation |
|---|---|---|---|---|---|---|---|---|
| RISK-T-01 | Technical | Positioning drift (no position feedback → cumulative timing error) | medium | medium | **major** | open | System Architect | +5s open/close margin (`timingMarginS`); see [08](08-cross-cutting-concepts.md) Concept 2 |
| RISK-T-03 | Technical | Motor relay/triac wear-out under repeated switching | medium | medium | **major** | open | Hardware Engineer | ≥10,000-cycle rated components; validated by `VerifyReliability`/TC_Q_003 |
| RISK-T-04 | Technical | Shutter motor type incompatibility (speed/torque variance defeats one fixed timing profile) | medium | medium | **major** | open | System Architect | Per-installation configurable `TimingProfile`; `VerifyTimeBasedOperation` |
| RISK-T-05 | Technical | Installer misconfiguration during timing calibration | medium | low | **minor** | open | System Architect | Guided config-mode procedure + out-of-range calibration rejection (MAJ-8 fix, `RejectOutOfRangeCalibration`, Scenarios::SCEN_22) |
| RISK-S-01 | Safety | Insufficient galvanic isolation → electric shock hazard | low | high | **critical** (escalated) | open | Safety Engineer | Mandatory `motorIsolation`/`inputIsolation` constraints; `VerifySupplyVoltageRange`/`VerifyMaximumSwitchingLoad` |
| RISK-B-01 | Business | Isolation/switching-load components push unit cost above 50 PLN target | medium | medium | **major** | open | Project Manager | Early sourcing engagement; track vs. `Business::costEffective` |
| RISK-SC-01 | Schedule | Isolation-component sourcing/qualification delay | medium | medium | **major** | open | Project Manager | HIL/bench-test fallback; second-source qualification in parallel |
| RISK-I-01 | Integration | Wall-switch wiring topology incompatibility (momentary vs. latching) | medium | medium | **major** | open | System Architect | Documented topologies + configurable input mode; `VerifyLocalControl` |

**Note on severity escalation (RISK-S-01):** the standard probability×impact
matrix would yield *major* for low×high; severity is escalated one level to
**critical** by explicit project convention whenever impact is a
safety-of-life hazard (ALARP-style treatment), per the risk's own
`rationale` field.

**Note on numbering:** there is no `RISK-T-02` — a gap in the ID sequence in
`Risks.sysml`, not a missing/removed risk.

All 8 risks remain `status = open`; none are `mitigated` or `closed` in the
current model.

## Technical Debt (Documented Model Gaps)

Explicit `// GAP:` comments in `Scenarios.sysml` mark intentionally
unresolved modeling detail — deferred by choice, not defect:

| Scenario | Gap |
|---|---|
| SCEN_05 | `MonitorUserInterruption`/`LogicalMovementSupervisor` do not explicitly state a "latched-stopped-until-release" guard against immediate re-trigger (behavior asserted only in `TC_N_001`'s pass criterion). |
| SCEN_07 | `ReceiveControlRequest`'s fork/merge models "whichever fires first" but does not distinguish the same-direction non-conflicting case from the opposite-direction conflicting case at the UCA layer (guard logic lives one layer down, in `DetermineMovementRequest`). |
| SCEN_21 (`DisposeController_EndOfLife`) | `UseCaseActivities::DisposeController` remains an intentionally underspecified single-action stub at the UCA layer (UC_05); the disposal scenario's steps are inferred from UC_05 metadata rather than a decomposed UCA. |
| SCEN_23 (`LocalControl_WiringModeMismatch`) | No existing UCA action models wiring-mode-mismatch **detection** specifically (recorded twice — in the scenario's header doc and in step `s3`); closest anchor is `HandleConflictingMovementCommands` (SR-8, explicitly left open). |
| SCEN_24 (`TimingProfile_PersistenceFailure_FirstPowerOn`) | `LoadTimingProfile`'s doc does not specify a default-value or fault-signaling behavior for a missing/invalid EEPROM read. |

These gaps are cross-cutting with RISK-T-01 (SCEN_24), RISK-I-01 (SCEN_23),
and RISK-T-05 (SCEN_05) — they are the concrete scenario-level
manifestations of the risk register's open items, not independent defects.
