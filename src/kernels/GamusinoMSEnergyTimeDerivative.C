#include "GamusinoMSEnergyTimeDerivative.h"

template <>
InputParameters
validParams<GamusinoMSEnergyTimeDerivative>()
{
  InputParameters params = validParams<TimeDerivative>();
  return params;
}

GamusinoMSEnergyTimeDerivative::GamusinoMSEnergyTimeDerivative(const InputParameters & parameters)
  : TimeDerivative(parameters)
{
}

Real
GamusinoMSEnergyTimeDerivative::computeQpResidual()
{
  return TimeDerivative::computeQpResidual();
}

/******************************************************************************/
/*                                  JACOBIAN                                  */
/******************************************************************************/
Real
GamusinoMSEnergyTimeDerivative::computeQpJacobian()
{
  return TimeDerivative::computeQpJacobian();
}
