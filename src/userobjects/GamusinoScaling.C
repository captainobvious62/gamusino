
#include "GamusinoScaling.h"
#include "MooseError.h"

template <>
InputParameters
validParams<GamusinoScaling>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription(
      "Scales the variables and material properties by the characteristic values.");
  params.addRequiredParam<Real>("characteristic_time", "The characteristic time.");
  params.addRequiredParam<Real>("characteristic_length", "The characteristic length.");
  params.addRequiredParam<Real>("characteristic_temperature", "The characteristic temperature.");
  params.addRequiredParam<Real>("characteristic_stress", "The characteristic stress.");
  return params;
}

GamusinoScaling::GamusinoScaling(const InputParameters & parameters)
  : GeneralUserObject(parameters),
    _s_time(getParam<Real>("characteristic_time")),
    _s_length(getParam<Real>("characteristic_length")),
    _s_temperature(getParam<Real>("characteristic_temperature")),
    _s_stress(getParam<Real>("characteristic_stress"))
{
  Real area = _s_length * _s_length;
  Real volume = area * _s_length;
  Real squared_time = _s_time * _s_time;
  // Secondary variables
  _s_force = _s_stress * area;
  _s_energy = _s_force * _s_length;
  _s_power = _s_energy / _s_time;
  _s_velocity = _s_length / _s_time;
  _s_acceleration = _s_length / squared_time;
  _s_mass = _s_force / _s_acceleration;
  // Material properties - T
  _s_density = _s_mass / volume;
  _s_specific_heat = _s_energy / _s_mass / _s_temperature;
  _s_conductivity = _s_power / _s_length / _s_temperature;
  _s_heat_production = _s_power / volume;
  _s_heat_flow = _s_power / area;
  // Material properties - H
  _s_permeability = area;
  _s_viscosity = _s_stress * _s_time;
  _s_compressibility = 1.0 / _s_stress;
  // Material properties - M (plus compressibility)
  _s_expansivity = 1.0 / _s_temperature;
}
