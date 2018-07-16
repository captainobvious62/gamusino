#ifndef GAMUSINOSCALING_H
#define GAMUSINOSCALING_H

#include "GeneralUserObject.h"

class GamusinoScaling;

template <>
InputParameters validParams<GamusinoScaling>();

class GamusinoScaling : public GeneralUserObject
{
public:
  GamusinoScaling(const InputParameters & parameters);
  virtual void initialize() {}
  virtual void execute() {}
  virtual void finalize() {}
  // Characteristic values
  Real _s_time;
  Real _s_length;
  Real _s_temperature;
  Real _s_stress;
  // Secondary variables
  Real _s_force;        // stress * area
  Real _s_energy;       // force * length
  Real _s_power;        // energy / time
  Real _s_velocity;     // length / time
  Real _s_acceleration; // lenght / time / time
  Real _s_mass;         // force / acceleration
  // Material parameters - T
  Real _s_density;         // mass / volume
  Real _s_specific_heat;   // energy / mass / temperature
  Real _s_conductivity;    // power * length * temperature
  Real _s_heat_production; // power / mass
  Real _s_heat_flow;       // power / area
  // Material parameters - H
  Real _s_permeability;    //
  Real _s_viscosity;       // stress * time
  Real _s_compressibility; // stress
  // Material parameters - M
  Real _s_expansivity; // 1 / temperature
};

#endif // GAMUSINOSCALING_H
