package L0_Constraints {
    private import ISQ::*;
    private import SI::*;
    private import Stakeholders::*;
    private import BaseArchitecture::*;
    private import SystemObjectives::*;

    requirement def costEffective specializes SystemObjectives::affordability {
        subject controller : BaseArchitecture::ShutterController;
        stakeholder manufacturer : Stakeholders::Manufacturer;
        
        doc
        /* The controller shall achieve manufacturing cost below 50 PLN per unit. */

        attribute maxCost;

        require constraint {
            maxCost <= 50
        }

        frame manufacturer.costConcern {
            redefines cost = maxCost;
        }
    }

    requirement def minimalSize
    {
        subject controller : BaseArchitecture::ShutterController;
        stakeholder user : Stakeholders::User;
        
        doc
        /* The controllers dimentions shall not exceed 40x40mm. */

        attribute maxWidth subsets ISQ::length;
        attribute maxLength subsets ISQ::length;

        require constraint {
            maxWidth <= 40[SI::mm] and
            maxLength <= 40[SI::mm]
        }

        frame user.miminalSize {
            redefines width = maxWidth;
            redefines length = maxLength;
        }
    }

    requirement operatingConditions {
        subject controller : BaseArchitecture::ShutterController;
        stakeholder manufacturer : Stakeholders::Manufacturer;
        doc
        /* The controller shall operate in typical residential environmental conditions. */

        attribute minEnviromentTemperature subsets ISQ::thermodynamicTemperature = -30 [C];
        attribute maxEnviromentTemperature subsets ISQ::thermodynamicTemperature = 50 [C];
        
        frame manufacturer.operatingConditionsConcern {
            redefines minimalWorkingTemperature = minEnviromentTemperature;
            redefines maximumWorkingTemperature = maxEnviromentTemperature;
        }
    }
} // package L0_Constraints
