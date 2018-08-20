#include "GamusinoVelocityBC.h"

template <>
InputParameters
validParams<GamusinoVelocityBC>()
{
  InputParameters params = validParams<PresetNodalBC>();
  params.addRequiredParam<Real>("velocity", "Value of the velocity applied.");
  return params;
}
/*******************************************************************************
Routine: GamusinoVelocityBC --- constructor
*******************************************************************************/
GamusinoVelocityBC::GamusinoVelocityBC(const InputParameters & parameters)
  : PresetNodalBC(parameters), _u_old(valueOld()), _velocity(getParam<Real>("velocity"))
{
}

/*******************************************************************************
Routine: computeQpResidual
*******************************************************************************/
Real
GamusinoVelocityBC::computeQpValue()
{
  return _u_old[_qp] + _velocity * _dt;
}
