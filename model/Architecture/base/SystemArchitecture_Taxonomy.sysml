package SystemArchitecture_Taxonomy {

    /* Abstract taxonomy for all SYSMOD System Architecture products (SM-PRD-17).
     * Establishes the shared abstract supertype from which every concrete
     * architecture layer (Base, Functional, Logical, Product, Physical, Test)
     * specializes, per KnowledgeSource/integration/crossmapping/
     * system-architecture.md §2.
     *
     * This package is a baseline: it must not change once concrete
     * architecture packages depend on it (system-architecture.md §5 step 3).
     * Every concrete architecture package MUST import this package and
     * carry ':> SystemArchitecture' on its top-level composite part def
     * (Traceability Rule 2). Concrete composites specialize the abstract
     * root directly rather than the same-named intermediate headers below,
     * to avoid an unqualified-name collision with their own enclosing
     * package (e.g. package FunctionalArchitecture vs. the header
     * 'FunctionalArchitecture' declared here). */

    // ── Abstract root — NEVER instantiated directly ──────────────────────────
    abstract part def SystemArchitecture {
        doc
        /* Abstract root for all SYSMOD architecture products (SM-PRD-17).
         * Concrete subtypes: BaseArchitecture (SM-PRD-07), FunctionalArchitecture
         * (SM-PRD-18), LogicalArchitecture (SM-PRD-20), ProductArchitecture
         * (SM-PRD-21), PhysicalArchitecture (SM-PRD-19), TestArchitecture
         * (SM-PRD-24). */
    }

    // ── Concrete specializations (headers; bodies live in their own packages) ─
    // NOTE: these headers document the taxonomy shape for future architecture
    // packages (Logical/Product/Physical/Test, not yet modeled). The current
    // concrete composites (BaseArchitecture::ShutterController,
    // FunctionalArchitecture::RollerShutterControllerFunctions) specialize
    // 'SystemArchitecture' directly instead, per the note above.
    abstract part def BaseArchitecture :> SystemArchitecture {
        doc /* Fundamental system decomposition; refined by all other architectures (SM-PRD-07). */
    }

    abstract part def FunctionalArchitecture :> SystemArchitecture {
        doc /* Technology-independent functional decomposition derived via FAS (SM-PRD-18). */
    }

    abstract part def LogicalArchitecture :> SystemArchitecture {
        doc /* Technology-independent logical component structure (SM-PRD-20). */
    }

    abstract part def ProductArchitecture :> SystemArchitecture {
        doc /* Technology-specific HW/SW component allocation (SM-PRD-21). */
    }

    abstract part def PhysicalArchitecture :> SystemArchitecture {
        doc /* Physical deployment and hardware topology (SM-PRD-19). */
    }

    abstract part def TestArchitecture :> SystemArchitecture {
        doc /* Test suite organization and test infrastructure (SM-PRD-24). */
    }

    // ── Cross-architecture allocation relationship type ───────────────────────
    allocation def ArchitectureAllocation {
        doc /* Typed allocation between architecture layers (e.g., Functional → Logical). */
    }
} // package SystemArchitecture_Taxonomy
