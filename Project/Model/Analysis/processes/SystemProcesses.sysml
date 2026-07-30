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
        /* Full lifecycle: installation, configuration, repeated operational use, and end-of-life disposal (UC_05). */
        @ProcessMeta { processType = "lifecycle"; }

        perform action install references SystemUseCases::installController;
        perform action configure references SystemUseCases::configureController;
        perform action operate references SystemUseCases::controlRollerShutter;
        perform action dispose references SystemUseCases::disposeController;

        // Day-to-day path loops through operate; end-of-life exits to dispose instead.
        // 'decide' makes these two successors mutually exclusive (previously two
        // unconditional 'then'/'first' successors from operate, which modeled
        // concurrency, not a loop-vs-exit choice). Guard mirrors
        // SystemStates::DecommissionRequest, the event that ends day-to-day operation.
        attribute decommissionRequested : Boolean default false;

        first install;
        then configure;
        then merge operateLoop;
        then operate;
        then decide lifecycleChoice;
        if decommissionRequested == false then operateLoop; // repeated day-to-day operation (loop)
        else dispose;                                       // end-of-life retirement (UC_05)
    }

    action controllerLifecycle : ControllerLifecycle;
} // package SystemProcesses
