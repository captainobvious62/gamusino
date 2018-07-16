#include "GamusinoFluidVelocity.h"

template <>
InputParameters
validParams<GamusinoFluidVelocity>()
{
  InputParameters params = validParams<GamusinoDarcyVelocity>();
  return params;
}

GamusinoFluidVelocity::GamusinoFluidVelocity(const InputParameters & parameters)
  : GamusinoDarcyVelocity(parameters), _porosity(getMaterialProperty<Real>("porosity"))
{
}

Real
GamusinoFluidVelocity::computeValue()
{
  return GamusinoDarcyVelocity::computeValue() / _porosity[_qp];
}
