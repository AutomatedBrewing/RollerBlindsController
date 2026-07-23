---
type: SysML v2 Concept
title: Case Usage
description: A case usage is a kind of calculation usage that is a usage of a case definition, specifying a particular performance of a case with a specific subject and actors to achieve the case objective.
timestamp: 2026-07-01T00:00:00Z
---

A case usage is declared using the keyword `case` (without `def`). It is typed by exactly one case definition and specializes calculation usage (§7.19). A case usage can:

- Redefine the **subject** parameter to bind it to a specific entity
- Redefine or add **actor** bindings
- Refine the **objective** by adding constraints
- Add subactions or subcalculations to the body

Case usages may appear inside packages, part definitions/usages, or other appropriate contexts.

# Syntax

```sysml
case faultAnalysis : FaultRecovery {
  subject :>> system = myAutomationSystem;
  actor   :>> engineer = seniorEngineer;

  objective {
    doc /* Resolve the specific fault detected on 2026-06-01. */
  }
}
```

# Semantics

- A case usage is a calculation usage typed by exactly one case definition.
- It inherits the subject, actors, and objective from its definition.
- Specializations (analysis, verification, use case usages) apply additional constraints to the objective subject binding.

# Rules

- Declared with keyword `case`.
- A case usage must be typed by exactly one case definition.
- Subject redefinition uses `subject redefines <name> = <value>` or `:>> <name> = <value>`.
- Actor redefinition uses `:>> actor = <value>`.

# Examples

```sysml
case faultRecovery1 : FaultRecovery {
  subject :>> system = productionSystem;
  actor   :>> engineer = maintenanceEngineer;
}
```

# Relationships

- [case.md](case.md) — general concept
- [case-definition.md](case-definition.md) — the definition being instantiated
- [analysis-case.md](analysis-case.md) — specialization
- [verification-case.md](verification-case.md) — specialization
- [use-case.md](use-case.md) — specialization
- [calculation.md](calculation.md) — supertype

# Citations

[1] OMG SysML v2 Specification, §7.22.2
