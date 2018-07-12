
#include "GamusinoFluidDensityConstant.h"

template <>
InputParameters
validParams<GamusinoFluidDensityConstant>()
{
  InputParameters params = validParams<GamusinoFluidDensity>();
  params.addClassDescription("Constant fluid density formulation.");
  return params;
}

GamusinoFluidDensityConstant::GamusinoFluidDensityConstant(const InputParameters & parameters)
  : GamusinoFluidDensity(parameters)
{
}

Real
GamusinoFluidDensityConstant::computeDensity(Real, Real, Real rho0) const
{
  return rho0;
}

Real GamusinoFluidDensityConstant::computedDensitydT(Real, Real, Real) const { return 0.0; }

Real GamusinoFluidDensityConstant::computedDensitydp(Real, Real) const { return 0.0; }
