package SystemIdea {
    private import ProblemStatement::*;

    requirement def WindowRollerShutterControllerIdea {
        doc
        /* Window Roller Shutter Controller (WRSC) system is system based on controller used to control
         * window roller shutters by moving them up or down.
         *
         * It is controlled from:
         * - wallswitch with buttons UP and DOWN.
         * - external system (i.e home automation system)
         *
         * The controller does not track the roller shutter position. It operates
         * on principle of time needed to open/close the shutter.
         * This time needs to be configurable.
         *
         * The controller will be powered from external system (same system that
         * can control the roller shutter controller).
         */

         frame ProblemStatement::NeedOfWindowRollerShutterController;
    }
} // package SystemIdea
