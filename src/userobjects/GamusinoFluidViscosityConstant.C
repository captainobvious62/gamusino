

#include "GamusinoFluidViscosityConstant.h"

template <>
InputParameters
validParams<GamusinoFluidViscosityConstant>()
{
  InputParameters params = validParams<GamusinoFluidViscosity>();
  params.addClassDescription("Constant fluid viscosity formulation.");
  return params;
}

GamusinoFluidViscosityConstant::GamusinoFluidViscosityConstant(const InputParameters & parameters)
  : GamusinoFluidViscosity(parameters)
{
}

Real
GamusinoFluidViscosityConstant::computeViscosity(Real, Real, Real mu0) const
{
  return mu0;
}

Real GamusinoFluidViscosityConstant::computedViscositydT(Real, Real, Real, Real) const { return 0.0; }

Real GamusinoFluidViscosityConstant::computedViscositydp(Real, Real, Real) const { return 0.0; }
