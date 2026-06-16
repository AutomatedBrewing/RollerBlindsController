package L0_Constraints {
    private import ISQ::*;
    private import SI::*;
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import SystemObjectives::*;
    private import DerivationConnections::*;

    package Business {
        requirement costEffective {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;

            doc
            /* The controller shall achieve manufacturing cost below 50 PLN per unit. */

            attribute manufacturingCost;

            require constraint {
                manufacturingCost <= 50
            }

            frame manufacturer.costConcern {
                redefines cost = manufacturingCost;
            }
            connection : Derivation connect SystemObjectives::affordability to self;
        }
    } // package Business

    package Physical {
        requirement compactDimensions {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder user : Stakeholders::User;

            doc
            /* The controllers dimentions shall not exceed 40x40x20mm. */

            attribute width subsets ISQ::length;
            attribute length subsets ISQ::length;
            attribute height subsets ISQ::length;

            require constraint {
                width <= 40 [SI::mm] and length <= 40 [SI::mm] and height <= 20 [SI::mm]
            }

            frame user.miminalSize {
                redefines width = width;
                redefines length = length;
                redefines height = height;
            }
        }
    } // package Physical

    package Environmental {
        requirement operatingConditions {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall operate in typical residential environmental conditions. */

            attribute minEnviromentTemperature subsets ISQ::thermodynamicTemperature;
            attribute maxEnviromentTemperature subsets ISQ::thermodynamicTemperature;

            require constraint {
                minEnviromentTemperature >= 0 ['°C'] and maxEnviromentTemperature <= 40 ['°C']
            }

            frame manufacturer.operatingConditionsConcern {
                redefines minimalWorkingTemperature = minEnviromentTemperature;
                redefines maximumWorkingTemperature = maxEnviromentTemperature;
            }
        }
    } // package Environmental

    package Electrical {
        requirement supplyVoltage {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall operate from a 12 VDC ±10% supply. */

            attribute supplyVoltage = 12 [SI::V];

            require constraint {
                supplyVoltage >= 10 [SI::V] and supplyVoltage <= 14 [SI::V]
            }
        }

        requirement switchingLoad {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall support shutter motors with operating current up to 8 A at 230 VAC. */

            attribute switchingCurrent = 8 [SI::A];
            attribute switchingVoltage = 230 [SI::V];

            require constraint {
                switchingCurrent <= 8 [SI::A] and switchingVoltage <= 230 [SI::V]
            }
        }

        requirement motorIsolation {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The motor control circuitry shall be galvanically isolated from low-voltage control logic. */
        }

        requirement inputIsolation {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall provide galvanic isolation for all external input interfaces. */
        }

    } // package Electrical

    package Architectural {
        requirement noPositionFeedback {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall operate without position feedback from the shutter. */
        }

        requirement timeBasedOperation {
            subject controller : BaseArchitecture::ShutterController;
            stakeholder manufacturer : Stakeholders::Manufacturer;
            doc
            /* The controller shall operate using configurable time-based shutter positioning. */
        }
    } // package Architectural
} // package L0_Constraints
