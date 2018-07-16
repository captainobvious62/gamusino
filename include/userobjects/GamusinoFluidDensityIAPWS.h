#ifndef GAMUSINOFLUIDDENSITYIAPWS_H
#define GAMUSINOFLUIDDENSITYIAPWS_H

#include "GamusinoFluidDensity.h"

class GamusinoFluidDensityIAPWS;

template <>
InputParameters validParams<GamusinoFluidDensityIAPWS>();

class GamusinoFluidDensityIAPWS : public GamusinoFluidDensity
{
public:
  GamusinoFluidDensityIAPWS(const InputParameters & parameters);
  Real computeDensity(Real pressure, Real temperature, Real) const;
  Real computedDensitydT(Real pressure, Real temperature, Real) const;
  Real computedDensitydp(Real pressure, Real temperature) const;

  bool _has_kelvin;
};

#endif // GAMUSINOFLUIDDENSITYIAPWS_H
