#ifndef GAMUSINOFLUIDDENSITYLINEAR_H
#define GAMUSINOFLUIDDENSITYLINEAR_H

#include "GamusinoFluidDensity.h"

class GamusinoFluidDensityLinear;

template <>
InputParameters validParams<GamusinoFluidDensityLinear>();

class GamusinoFluidDensityLinear : public GamusinoFluidDensity
{
public:
  GamusinoFluidDensityLinear(const InputParameters & parameters);
  Real computeDensity(Real, Real temperature, Real rho0) const;
  Real computedDensitydT(Real, Real, Real rho0) const;
  Real computedDensitydp(Real, Real) const;

private:
  Real _alpha;
  Real _Tc;
};

#endif // GAMUSINOFLUIDDENSITYLINEAR_H
