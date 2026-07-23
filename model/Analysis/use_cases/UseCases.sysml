package SystemUseCases {
    private import ScalarValues::*;
    private import BaseArchitecture::*;
    private import Stakeholders::*;
    // Part C-3 fix (SMRR corrective pass): replaced the non-standard '::**'
    // deep-import operator (tool-portability risk per finalReviewReport.md
    // minor findings) with the standard '::*' wildcard import already used
    // by every other import in this file/model. Only WallSwitch and
    // HomeAutomationSystem (both direct, top-level members of SystemContext)
    // are referenced below, so a non-recursive import is sufficient --
    // confirmed safe, no nested-member reference is used from this package.
    private import SystemContext::*;
    private import L0_Requirements::*;

    /* The System Use Cases are the services and the essential ends
     * of a system. The system is developed and operated to achieve
     * these services.
     */

    metadata def UseCaseMeta {
        attribute trigger        : String;
        attribute result         : String;
        attribute preconditions  : String;
        attribute postconditions : String;
        attribute type           : String;   // systemUseCase | continuousUseCase
        attribute priority       : String;   // mandatory | high | medium | low -- see SystemObjectives::RequirementMeta's
                                              // priority-taxonomy cross-map comment for the intentional relationship
                                              // between this vocabulary and RequirementPriority/TestCaseMeta.priority.
    }

    // =====================================================================
    // UC-01: Control Roller Shutter
    //
    // Kept as a single generic use case per SYSMOD SM-PRD-12 (a coarse
    // "table of contents of services"); the discrete trigger/result
    // variants below specialize it (`specializes`), mirroring the same
    // specialization already used one layer down in
    // UseCaseActivities::ControlRollerShutter's OpenShutterAutomatically /
    // CloseShutterAutomatically / OpenShutterManually / CloseShutterManually.
    // =====================================================================
    use case def UC_01_ControlRollerShutter {
        subject controller : BaseArchitecture::ShutterController;
        actor user : Stakeholders::User;
        actor wallSwitch : SystemContext::WallSwitch;
        actor homeAutomationSystem : SystemContext::HomeAutomationSystem;

        objective {
            doc
            /* Change shutter state: open, close, move to position or stop current movement. */
            require L0_Requirements::Functional::controlRollerShutter;
            require L0_Requirements::Functional::localControl;
            require L0_Requirements::Functional::remoteControl;
            require L0_Requirements::Functional::fullShutterMovement;
            require L0_Requirements::Functional::manualPositioning;
            require L0_Requirements::Functional::stopShutterMovement;
            require L0_Requirements::Interface::wallSwitchWiringCompatibility;
            require L0_Requirements::Interface::remoteControlWiringCompatibility;
        }

        @UseCaseMeta {
            trigger        = "User operates the wall switch, or the home automation system asserts an UP/DOWN remote input";
            result         = "Shutter moves in the requested direction until fully open, fully closed, a configured position is reached, or a stop condition occurs";
            preconditions  = "Controller powered from control and mains supply; no conflicting simultaneous UP+DOWN signal active";
            postconditions = "Shutter motor de-energized; shutterState reflects the final position/direction";
            type           = "systemUseCase";
            priority       = "mandatory";
        }
    }

    use case controlRollerShutter : UC_01_ControlRollerShutter;

    use case def UC_01a_OpenShutterAutomatically specializes UC_01_ControlRollerShutter {
        doc /* Shutter travels fully open under timed automatic control. */

        @UseCaseMeta {
            trigger        = "User or home automation system requests full-open movement";
            result         = "Shutter travels to the fully open position and stops automatically on timeout";
            preconditions  = "Controller powered; shutter not already fully open";
            postconditions = "Shutter fully open; motor de-energized";
            type           = "systemUseCase";
            priority       = "mandatory";
        }
    }

    use case openShutterAutomatically : UC_01a_OpenShutterAutomatically;

    use case def UC_01b_CloseShutterAutomatically specializes UC_01_ControlRollerShutter {
        doc /* Shutter travels fully closed under timed automatic control. */

        @UseCaseMeta {
            trigger        = "User or home automation system requests full-close movement";
            result         = "Shutter travels to the fully closed position and stops automatically on timeout";
            preconditions  = "Controller powered; shutter not already fully closed";
            postconditions = "Shutter fully closed; motor de-energized";
            type           = "systemUseCase";
            priority       = "mandatory";
        }
    }

    use case closeShutterAutomatically : UC_01b_CloseShutterAutomatically;

    use case def UC_01c_OpenShutterManually specializes UC_01_ControlRollerShutter {
        doc /* Shutter moves upward only while the command is held/asserted. */

        @UseCaseMeta {
            trigger        = "User holds/asserts the UP command";
            result         = "Shutter moves upward only while the command is asserted; stops on release or timeout";
            preconditions  = "Controller powered";
            postconditions = "Shutter stopped at an intermediate or fully open position; motor de-energized";
            type           = "systemUseCase";
            priority       = "medium";
        }
    }

    use case openShutterManually : UC_01c_OpenShutterManually;

    use case def UC_01d_CloseShutterManually specializes UC_01_ControlRollerShutter {
        doc /* Shutter moves downward only while the command is held/asserted. */

        @UseCaseMeta {
            trigger        = "User holds/asserts the DOWN command";
            result         = "Shutter moves downward only while the command is asserted; stops on release or timeout";
            preconditions  = "Controller powered";
            postconditions = "Shutter stopped at an intermediate or fully closed position; motor de-energized";
            type           = "systemUseCase";
            priority       = "medium";
        }
    }

    use case closeShutterManually : UC_01d_CloseShutterManually;

    use case def UC_01e_HandleConflictingMovementCommands specializes UC_01_ControlRollerShutter {
        doc
        /* Abnormal-scenario extension of UC_01: if UP and DOWN are
         * asserted simultaneously (e.g. wiring fault, stuck switch, or
         * conflicting local/remote commands), the controller shall not
         * energize the motor in either direction, avoiding a
         * short-circuit-equivalent drive condition. This is the
         * use-case-level behavioral counterpart to the electrical safety
         * constraint in REQ-S-01; the galvanic-isolation/accessible-voltage
         * aspect of REQ-S-01 remains a physical design property, not a
         * behavior, and stays modeled purely as a constraint (see
         * model_issues.md). The suppressed-movement state is additionally
         * made user-observable via REQ-S-02 conflictIndication (system
         * model review corrective pass, closes Major finding M2): a
         * distinct user-facing indication now distinguishes this state from
         * normal idle/at-rest behavior.
         */

        objective {
            doc
            /* Suppress motor activation when simultaneous UP+DOWN conflict is detected. */
            require L0_Requirements::Safety::safety;
            require L0_Requirements::Safety::conflictIndication;
        }

        @UseCaseMeta {
            trigger        = "UP and DOWN commands asserted simultaneously from any combination of local/remote sources";
            result         = "Motor remains de-energized in both directions; no movement occurs";
            preconditions  = "Controller powered";
            postconditions = "Motor de-energized; no shutter movement";
            type           = "systemUseCase";
            priority       = "mandatory";
        }
    }

    use case handleConflictingMovementCommands : UC_01e_HandleConflictingMovementCommands;

    // =====================================================================
    // UC-02: Install Controller
    // =====================================================================
    use case def UC_02_InstallController {
        subject controller : BaseArchitecture::ShutterController;
        actor installer : Stakeholders::Installer;

        objective {
            doc
            /* Install the controller into the shutter system. */
            require L0_Requirements::Quality::easeOfInstallation;
            require L0_Requirements::Interface::wallSwitchWiringCompatibility;
        }

        @UseCaseMeta {
            trigger        = "Installer begins physical installation of the controller";
            result         = "Controller wired to wall switch, remote interface, power, and shutter motor, and verified working";
            preconditions  = "Power supply to the shutter circuit isolated/off";
            postconditions = "Controller connected and verified working; wall switch reassembled";
            type           = "systemUseCase";
            priority       = "mandatory";
        }
    }

    use case installController : UC_02_InstallController;

    // =====================================================================
    // UC-03: Configure Controller
    // =====================================================================
    use case def UC_03_ConfigureController {
        subject controller : BaseArchitecture::ShutterController;
        actor installer : Stakeholders::Installer;

        objective {
            doc
            /* Configure controller movement timing parameters required for
             * time-based operation, without disassembling the device. */
            require L0_Requirements::Functional::configurableTimingProfile;
            require L0_Requirements::Functional::configurationMode;
        }

        @UseCaseMeta {
            trigger        = "Installer explicitly activates the configuration mode";
            result         = "Opening/closing travel times measured and saved; configuration mode exited";
            preconditions  = "Controller installed and powered; configuration mode not already active";
            postconditions = "Timing profile saved; configuration mode deactivated; user notified of activation and deactivation";
            type           = "systemUseCase";
            priority       = "mandatory";
        }
    }

    use case configureController : UC_03_ConfigureController;

    // =====================================================================
    // UC-04: Diagnose and Repair Controller (maintenance, SM-PRD-08
    // MaintenanceTechnician stakeholder)
    // =====================================================================
    use case def UC_04_DiagnoseAndRepairController {
        subject controller : BaseArchitecture::ShutterController;
        actor maintenanceTechnician : Stakeholders::MaintenanceTechnician;

        objective {
            doc
            /* Diagnose a failed or malfunctioning controller in the field
             * and repair or replace it on-site without modifying the
             * existing installation wiring. */
            require L0_Requirements::Quality::diagnosability;
            require L0_Requirements::Quality::fieldReplaceability;
            require L0_Requirements::Quality::reliability;
        }

        @UseCaseMeta {
            trigger        = "Reported shutter malfunction (no movement, wrong direction, or intermittent operation)";
            result         = "Fault diagnosed and controller repaired or replaced on-site using the existing wiring";
            preconditions  = "Reported malfunction; access to the installed controller";
            postconditions = "Controller diagnosed; faulty unit repaired or replaced; normal operation restored";
            type           = "systemUseCase";
            priority       = "medium";
        }
    }

    use case diagnoseAndRepairController : UC_04_DiagnoseAndRepairController;

    // =====================================================================
    // UC-05: Dispose Controller (end-of-life, DisposalFacility stakeholder).
    // REQ-E-01 (Environmental::regulatedDisposal) formally closes the
    // WEEE/RoHS disposal requirement gap; the objective below requires it
    // directly (stale "gap not yet closed" comment removed, system model
    // review corrective pass -- the requirement has existed since the
    // Requirements formal review, see model_issues.md item 12).
    // =====================================================================
    use case def UC_05_DisposeController {
        subject controller : BaseArchitecture::ShutterController;
        actor disposalFacility : Stakeholders::DisposalFacility;

        objective {
            doc
            /* Collect, disassemble, and dispose of/recycle a retired
             * controller in compliance with applicable electronic-waste
             * and hazardous-substance regulation. */
            require L0_Requirements::Environmental::regulatedDisposal;
        }

        @UseCaseMeta {
            trigger        = "Controller retired at end of life";
            result         = "Controller collected, disassembled, and disposed of/recycled per WEEE/RoHS regulation";
            preconditions  = "Controller decommissioned and removed from installation";
            postconditions = "Controller materials disposed of/recycled in compliance with regulation";
            type           = "systemUseCase";
            // MAJ-1 fix (SMRR corrective pass): was "low", contradicting its
            // backing requirement REQ-E-01 (RequirementPriority::mandatory).
            // Aligned per the priority taxonomy cross-map in
            // SystemObjectives.sysml (mandatory -> mandatory).
            priority       = "mandatory";
        }
    }

    use case disposeController : UC_05_DisposeController;
} // package SystemUseCases
