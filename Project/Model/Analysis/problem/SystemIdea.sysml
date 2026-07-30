package SystemIdea {
    private import ProblemStatement::*;

    comment
    /* The System Idea describes the core idea and leading features
     * of the system.
     */
     
    requirement systemIdea {
        doc
        /* Compact controller for convenient local and remote control of
         * window roller shutters. Uses time-based movement instead of
         * position sensors for cost-effectiveness and easy installation,
         * with movement timing configurable per shutter type.
         */

        frame ProblemStatement::needForConvenientShutterOperation;
    }
} // package SystemIdea
