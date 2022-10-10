#pragma once

#include <types.hpp>
#include <cmath>
#include <cstdint>

struct LoadParameters {
	uint16_t LoadType;

	struct PumpStruct {
		fp32_t k_L;
		fp32_t t_constant;
	} Pump;

	struct ElectricVehicleStruct {
		fp32_t m;			                // Mass of the car in [kg]
		fp32_t rho;							// Air density [kg/m^3]
		fp32_t G;							// Gravity [m/s^2]
		fp32_t r;			                // Radius of the car wheel in [m]
		fp32_t friction;			        // Friction coefficient of the wheel [-]
		fp32_t Cw;			                // Air drag coefficient [-]
		fp32_t A_car;						// Front area of car [m^2]
		fp32_t i_gear;						// Gear ratio
		fp32_t gear_efficiency;			 	// Gear efficiency
		fp32_t velocity_lim_0;				// Optional
		fp32_t velocity_lim_1;				// Optional
	} EV;

	struct ElevatorStruct {
		fp32_t mass_elevator;			    // Mass of the elevator in [kg]
		fp32_t mass_load;					// Mass of the load in [kg]
		fp32_t i_gear;						// Gear ratio
		fp32_t gear_efficiency;			 	// Gear efficiency
		fp32_t p_0;							// Optional
		fp32_t p_1;							// Optional
	} Elevator;

	struct ShipPropulsionStruct {
		fp32_t p_0;							// Optional
		fp32_t p_1;							// Optional
	} Ship;

	struct WindPowerStruct {
		fp32_t p_0;							// Optional
		fp32_t p_1;							// Optional
	} Wind;

	struct HydroPowerStruct {
		fp32_t p_0;							// Optional
		fp32_t p_1;							// Optional
	} Hydro;

};
