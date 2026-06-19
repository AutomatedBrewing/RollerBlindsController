package Verification {
    private import VerificationCases::*;
    private import BaseArchitecture::*;

    package Functional {
        verification def VerifyLocalControl {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyRemoteControl {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyAutomaticOpening {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyAutomaticClosing {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyManualPositioning {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyMovementStop {
            subject controller : BaseArchitecture::ShutterController;
        }
    } // package Functional

    package Quality {
        verification def VerifyEaseOfInstallation {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyReliability {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyAvailability {
            subject controller : BaseArchitecture::ShutterController;
        }
    } // package Quality

    package Constraints {
        verification def VerifySupplyVoltageRange {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyMaximumSwitchingLoad {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyDimensions {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyOperatingTemperatureRange {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyTimeBasedOperation {
            subject controller : BaseArchitecture::ShutterController;
        }
        verification def VerifyNoPositionFeedbackDependency {
            subject controller : BaseArchitecture::ShutterController;
        }
    } // package Constraints
} // package Verification
