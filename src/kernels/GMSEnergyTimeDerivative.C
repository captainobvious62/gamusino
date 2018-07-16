#include "GMSEnergyTimeDerivative.h"

template <>
InputParameters
validParams<GMSEnergyTimeDerivative>()
{
  InputParameters params = validParams<TimeDerivative>();
  return params;
}

GMSEnergyTimeDerivative::GMSEnergyTimeDerivative(const InputParameters & parameters)
  : TimeDerivative(parameters)
{
}

Real
GMSEnergyTimeDerivative::computeQpResidual()
{
  return TimeDerivative::computeQpResidual();
}

/******************************************************************************/
/*                                  JACOBIAN                                  */
/******************************************************************************/
Real
GMSEnergyTimeDerivative::computeQpJacobian()
{
  return TimeDerivative::computeQpJacobian();
}
