package ProblemStatement {
    comment
    /* The Problem Statement is a clear and concise statement of
     * an unwelcome situation that the system of interest should
     * resolve.
     */

    concern def NeedForConvenientShutterOperation {
        doc
        /* Users need convenient local and remote control of window roller
         * shutters, which today are typically manual-only and disconnected
         * from home automation. Scope is residential retrofit installations
         * with an existing wall switch; new-build wiring, commercial systems,
         * and multi-shutter scene control are out of scope.
         */
    }

    concern needForConvenientShutterOperation : NeedForConvenientShutterOperation;
} // package ProblemStatement
