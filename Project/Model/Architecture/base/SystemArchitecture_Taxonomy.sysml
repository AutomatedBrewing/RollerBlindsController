package SystemArchitecture_Taxonomy {

    /* Abstract root shared by every concrete architecture layer package (SM-PRD-17).
     * Concrete packages (BaseArchitecture, FunctionalArchitecture, LogicalArchitecture,
     * ProductArchitecture) specialize 'SystemArchitecture' directly; no intermediate
     * per-layer abstract header is declared here, to avoid dead, same-named types that
     * duplicate the concrete package names without adding structure. */

    // ── Abstract root — NEVER instantiated directly ──────────────────────────
    abstract part def SystemArchitecture {
        doc
        /* Abstract root for all SYSMOD architecture products (SM-PRD-17); never instantiated directly. */
    }

    // ── Cross-architecture allocation relationship type ───────────────────────
    allocation def ArchitectureAllocation {
        doc /* Typed allocation between architecture layers (e.g., Functional → Logical). */
    }
} // package SystemArchitecture_Taxonomy
