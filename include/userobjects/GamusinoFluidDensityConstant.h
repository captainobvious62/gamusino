#ifndef GAMUSINOFLUIDDENSITYCONSTANT_H
#define GAMUSINOFLUIDDENSITYCONSTANT_H

#include "GamusinoFluidDensity.h"

class GamusinoFluidDensityConstant;

template <>
InputParameters validParams<GamusinoFluidDensityConstant>();

class GamusinoFluidDensityConstant : public GamusinoFluidDensity
{
public:
  GamusinoFluidDensityConstant(const InputParameters & parameters);
  Real computeDensity(Real, Real, Real rho0) const;
  Real computedDensitydT(Real, Real, Real) const;
  Real computedDensitydp(Real, Real) const;
};

#endif // GAMUSINOFLUIDDENSITYCONSTANT_H
