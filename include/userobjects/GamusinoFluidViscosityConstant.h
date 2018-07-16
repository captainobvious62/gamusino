#ifndef GAMUSINOFLUIDVISCOSITYCONSTANT_H
#define GAMUSINOFLUIDVISCOSITYCONSTANT_H

#include "GamusinoFluidViscosity.h"

class GamusinoFluidViscosityConstant;

template <>
InputParameters validParams<GamusinoFluidViscosityConstant>();

class GamusinoFluidViscosityConstant : public GamusinoFluidViscosity
{
public:
  GamusinoFluidViscosityConstant(const InputParameters & parameters);
  Real computeViscosity(Real, Real, Real mu0) const;
  Real computedViscositydT(Real, Real, Real, Real) const;
  Real computedViscositydp(Real, Real, Real) const;
};

#endif // GAMUSINOFLUIDVISCOSITYCONSTANT_H
