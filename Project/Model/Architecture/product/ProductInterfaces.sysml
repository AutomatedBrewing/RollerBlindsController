/* Product Architecture (SM-PRD-21) — New Interface (Port) Definitions.
 * Introduces only technology-specific port defs with no earlier-layer counterpart,
 * per ADR_006_ProductRealizationStrategy and ADR_007_ProductCoupling. arc42: ARC-05. */
package ProductInterfaces {
    private import SI::*;
    private import ScalarValues::Boolean;

    port def RelayControlPort {
        doc
        /* Two mutually-exclusive relay-coil drive signals (upCoil, downCoil) from
         * MotorDriveControlSoftware to MotorDriveRelayModule; firmware enforces break-before-make. */

        out attribute upCoil : Boolean;
        out attribute downCoil : Boolean;
    }

    port def BuzzerControlPort {
        doc
        /* Single GPIO drive line from UserFeedbackSoftware to AudibleNotificationBuzzer (ADR-008);
         * firmware-generated beep patterns encode configuration-mode transitions (REQ-F-08). */

        out attribute buzzerOn : Boolean;
    }

    port def LogicPowerRailPort {
        doc
        /* Regulated 3.3V logic supply rail distributed by PowerSupplyModule
         * to all logic-level Product components. */

        attribute nominalVoltage = 3.3 [SI::V];
    }

    port def ProgrammingPort {
        doc
        /* In-circuit programming/debug interface (SWIM/UART-bootloader) used exclusively
         * during manufacturing; not connected in normal operation (REQ-Q-01). */

        attribute enabled : Boolean;
    }
} // package ProductInterfaces
