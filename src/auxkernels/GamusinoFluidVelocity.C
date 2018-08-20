#include "GamusinoFluidVelocity.h"

template <>
InputParameters
validParams<GamusinoFluidVelocity>()
{
  InputParameters params = validParams<GamusinoDarcyVelocity>();
  return params;
}

/*******************************************************************************
Routine: GamusinoFluidVelocity -- constructor
*******************************************************************************/
GamusinoFluidVelocity::GamusinoFluidVelocity(const InputParameters & parameters)
  : GamusinoDarcyVelocity(parameters), _porosity(getMaterialProperty<Real>("porosity"))
{
}

/*******************************************************************************
Routine: computeValue
*******************************************************************************/
Real
GamusinoFluidVelocity::computeValue()
{
  return GamusinoDarcyVelocity::computeValue() / _porosity[_qp];
}
