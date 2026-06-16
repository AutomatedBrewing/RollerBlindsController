package SystemIdea {
    private import ProblemStatement::*;

    comment
    /* The System Idea describes the core idea and leading features
     * of the system.
     */
     
    requirement systemIdea {
        doc
        /* The Window Roller Shutter Controller (WRSC) is a compact control system
         * that enables convenient opening and closing of window roller shutters
         * in residential and building environments.
         *
         * The system provides both local control via wall switches and remote
         * control via home automation systems.
         *
         * Its key differentiator is simplicity: the controller operates without
         * position sensors and instead uses time-based movement control,
         * making it cost-effective and easy to install.
         *
         * The system is designed to be configurable to different shutter types
         * by adjusting movement timing parameters.
         */

        frame ProblemStatement::NeedOfWindowRollerShutterController;
    }
} // package SystemIdea
