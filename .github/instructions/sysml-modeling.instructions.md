---
applyTo: "**/*.sysml"
---
# SysML v2 Modeling Instructions

When editing or creating `.sysml` files in this project:

## File Header Pattern

Every `.sysml` file must start with explicit imports. Follow the required import matrix in
`KnowledgeSource/integration/okf-ontology.md §6.3`. Standard pattern:

```sysml
package <PackageName> {
    private import <Dependency1>::*;
    private import <Dependency2>::*;

    // ... model elements follow
}
```

## Requirements Pattern

Use the two-layer pattern (see `KnowledgeSource/integration/crossmapping/requirements.md §2`):
- Layer 1: `requirement def` templates (category types: FunctionalReq, PerformanceReq, SafetyReq, InterfaceReq)
- Layer 2: `requirement` usages typed by those templates — these are the actual project requirements
- Annotate every requirement usage with `@RequirementMeta { source, priority, verificationMethod, rationale }`
- `satisfy` and `verify` always target requirement **usages**, never bare `requirement def` names

## Architecture Decomposition

Follow the 4-level decomposition from `KnowledgeSource/integration/okf-ontology.md §7`:
- L0: System Context — `part def`, `port def`, `connection def`
- L1: Functional Architecture — `part def` + `action def` + `flow def` (technology-independent)
- L2: Logical Architecture — `part def` + typed `port def` + `allocation def`
- L3: Product Architecture — concrete `part def` with `attribute` values + `satisfy` links

## System Context Rules

- Model actors as `part def` (not SysML `actor` element) — see `KnowledgeSource/sysmod/tools/death-of-actor.md`
- Use proxy ports exclusively (`port def`) — see `KnowledgeSource/sysmod/tools/proxy-versus-full-port.md`
- Every external interface must have a typed `port def` with `flow def` item types
- Every `connect` statement must reference typed ports

## Perform Action Pattern

Use `perform action <name> : <DefName>` to invoke use case defs or action defs by reference:
```sysml
perform action receiveRequest : ReceiveControlRequest;  // correct
action receiveRequest : ReceiveControlRequest { ... }   // only if adding parameter bindings
```

## Common Anti-Patterns to Avoid

- ❌ `requirement def REQ_001 { doc /* specific text */ }` — bare def with project-specific doc text
- ✅ `requirement <'REQ-001'> myReq : FunctionalReq { doc /* specific text */ }`
- ❌ Missing `import` statements causing unresolved-type errors
- ❌ `actor` keyword (SysML v1) — use `part def` instead
- ❌ Full ports — use `port def` (proxy ports) exclusively
