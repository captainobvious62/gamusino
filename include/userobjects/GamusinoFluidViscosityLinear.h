#ifndef GAMUSINOFLUIDVISCOSITYLINEAR_H
#define GAMUSINOFLUIDVISCOSITYLINEAR_H

#include "GamusinoFluidViscosity.h"

class GamusinoFluidViscosityLinear;

template <>
InputParameters validParams<GamusinoFluidViscosityLinear>();

class GamusinoFluidViscosityLinear : public GamusinoFluidViscosity
{
public:
  GamusinoFluidViscosityLinear(const InputParameters & parameters);
  Real computeViscosity(Real temperature, Real, Real mu0) const;
  Real computedViscositydT(Real temperature, Real, Real, Real mu0) const;
  Real computedViscositydp(Real, Real, Real) const;

private:
  Real _Tc;
  Real _Tv;
};

#endif // GAMUSINOFLUIDVISCOSITYLINEAR_H
