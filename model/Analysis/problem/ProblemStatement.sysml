package ProblemStatement {
    comment
    /* The Problem Statement is a clear and concise statement of
     * an unwelcome situation that the system of interest should
     * resolve.
     */

    concern NeedForConvenientShutterOperation {
        doc
        /* Users need a way to control window roller shutters in both
         * local and remote contexts.
         *
         * Currently, roller shutters are often controlled only manually,
         * which limits convenience and integration with modern home
         * automation systems.
         *
         * This creates a gap between user expectations for automated,
         * remote-controlled environments and the limited capability
         * of existing installations.
         *
         * The problem exists in residential and building automation
         * contexts, where users want to control shutters conveniently
         * without being physically present at each window.
         *
         * This matters because improved control increases comfort,
         * energy efficiency, and integration with smart home systems.
         *
         * Scope: residential and light building-automation retrofit
         * installations where a wall switch already exists and is being
         * replaced/augmented; new-build wiring, commercial/industrial
         * shutter systems, and multi-shutter group/scene control are
         * explicitly out of scope for this problem statement (see
         * SystemIdea::systemIdea for the resulting product boundary).
         *
         * Success criteria: the problem is considered resolved when a user
         * can open, close, position, and stop a window roller shutter both
         * locally (wall switch) and remotely (home automation system)
         * without being physically present at the shutter, using a
         * controller that a first-time installer can fit and configure in a
         * typical retrofit wall-switch box within the effort budget defined
         * by the System Objectives (see SystemObjectives::easeOfUse,
         * SystemObjectives::localControl, SystemObjectives::remoteControl).
         */
    }
} // package ProblemStatement
