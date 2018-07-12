
#ifndef GAMUSINOFLUIDDENSITY_H
#define GAMUSINOFLUIDDENSITY_H

#include "GeneralUserObject.h"
#include "GamusinoScaling.h"

class GamusinoFluidDensity;

template <>
InputParameters validParams<GamusinoFluidDensity>();

class GamusinoFluidDensity : public GeneralUserObject
{
public:
  GamusinoFluidDensity(const InputParameters & parameters);
  void initialize() {}
  void execute() {}
  void finalize() {}
  virtual Real computeDensity(Real pressure, Real temperature, Real rho0) const = 0;
  virtual Real computedDensitydT(Real pressure, Real temperature, Real rho0) const = 0;
  virtual Real computedDensitydp(Real pressure, Real temperature) const = 0;

protected:
  bool _has_scaled_properties;
  const GamusinoScaling * _scaling_uo;
};

#endif // GAMUSINOFLUIDDENSITY_H
