#include "GamusinoMSEnergyResidual.h"

template <>
InputParameters
validParams<GamusinoMSEnergyResidual>()
{
  InputParameters params = validParams<Kernel>();
  return params;
}

GamusinoMSEnergyResidual::GamusinoMSEnergyResidual(const InputParameters & parameters)
  : Kernel(parameters),
    _bulk_thermal_conductivity(getMaterialProperty<Real>("bulk_thermal_conductivity")),
    _heat_production(getMaterialProperty<Real>("heat_production")),
    _bulk_specific_heat(getMaterialProperty<Real>("bulk_specific_heat")),
    _bulk_density(getMaterialProperty<Real>("bulk_density")),
    _scale_factor(getMaterialProperty<Real>("scale_factor"))
{
}

Real
GamusinoMSEnergyResidual::computeQpResidual()
{
  Real diff;
  Real e_source;
  if (_fe_problem.isTransient())
  {
    diff = _scale_factor[_qp] * _bulk_thermal_conductivity[_qp] /
           (_bulk_density[_qp] * _bulk_specific_heat[_qp]);
    e_source = _scale_factor[_qp] * _heat_production[_qp] /
               (_bulk_density[_qp] * _bulk_specific_heat[_qp]);
  }
  else
  {
    diff = _bulk_thermal_conductivity[_qp];
    e_source = _heat_production[_qp];
  }
  return diff * _grad_u[_qp] * _grad_test[_i][_qp] - e_source * _test[_i][_qp];
}

/******************************************************************************/
/*                                  JACOBIAN                                  */
/******************************************************************************/
Real
GamusinoMSEnergyResidual::computeQpJacobian()
{
  Real diff;
  if (_fe_problem.isTransient())
    diff = _scale_factor[_qp] * _bulk_thermal_conductivity[_qp] /
           (_bulk_density[_qp] * _bulk_specific_heat[_qp]);
  else
    diff = _bulk_thermal_conductivity[_qp];
  return diff * _grad_phi[_j][_qp] * _grad_test[_i][_qp];
}
