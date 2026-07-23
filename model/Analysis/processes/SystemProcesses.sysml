package SystemProcesses {
    private import ScalarValues::*;
    private import SystemUseCases::*;

    /* The System Processes specify the logical order of execution of
     * the System Use Cases, describing uses of the system on a higher
     * level than the individual use cases.
     */

    metadata def ProcessMeta {
        attribute processType : String; // lifecycle | mission | operational
    }

    action def ControllerLifecycle {
        doc
        /* Full lifecycle of the controller: installation, configuration,
         * repeated operational use to control the roller shutter, and
         * (MAJ-7 fix, SMRR corrective pass) its eventual maintenance and
         * end-of-life disposal phases, using the existing UC_04/UC_05
         * use cases (no redesign -- simply closes lifecycle consistency
         * by naming phases that were already fully modeled one layer
         * down but omitted from this top-level process). */
        @ProcessMeta { processType = "lifecycle"; }

        perform action install references SystemUseCases::installController;
        perform action configure references SystemUseCases::configureController;
        perform action operate references SystemUseCases::controlRollerShutter;
        perform action maintain references SystemUseCases::diagnoseAndRepairController;
        perform action dispose references SystemUseCases::disposeController;

        // Original day-to-day path, unchanged (no redesign): operateLoop is
        // a merge node with a single outgoing edge (to operate); its only
        // change below is gaining an additional INCOMING edge (from
        // maintain), which is exactly what a merge node is for.
        first install;
        then configure;
        then merge operateLoop;
        then operate;
        then operateLoop; // repeated day-to-day operation (loop)

        // MAJ-7 fix: maintain and dispose are additive completions reachable
        // directly from 'operate' -- a field fault (UC_04) can arise at any
        // point during day-to-day operation, and end-of-life retirement
        // (UC_05) likewise occurs from the operational phase rather than
        // being redesigned into the day-to-day loop itself. Once repaired,
        // maintain rejoins the same operational loop via the existing
        // operateLoop merge node.
        first operate  then maintain;
        first maintain then operateLoop;
        first operate  then dispose;
    }

    action controllerLifecycle : ControllerLifecycle;
} // package SystemProcesses
