#include "GMSMassResidual.h"

template <>
InputParameters
validParams<GMSMassResidual>()
{
  InputParameters params = validParams<Kernel>();
  return params;
}

GMSMassResidual::GMSMassResidual(const InputParameters & parameters)
  : Kernel(parameters),
    _bulk_density(getMaterialProperty<Real>("bulk_density")),
    _gravity(getMaterialProperty<RealVectorValue>("gravity"))
{
}

Real
GMSMassResidual::computeQpResidual()
{
  return (_grad_u[_qp] - _bulk_density[_qp] * _gravity[_qp]) * _grad_test[_i][_qp];
}

/******************************************************************************/
/*                                  JACOBIAN                                  */
/******************************************************************************/
Real
GMSMassResidual::computeQpJacobian()
{
  return _grad_phi[_j][_qp] * _grad_test[_i][_qp];
}
