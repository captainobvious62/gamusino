#ifndef GAMUSINOFLUIDVISCOSITY_H
#define GAMUSINOFLUIDVISCOSITY_H

#include "GeneralUserObject.h"
#include "GamusinoScaling.h"

class GamusinoFluidViscosity;

template <>
InputParameters validParams<GamusinoFluidViscosity>();

class GamusinoFluidViscosity : public GeneralUserObject
{
public:
  GamusinoFluidViscosity(const InputParameters & parameters);
  void initialize() {}
  void execute() {}
  void finalize() {}
  virtual Real computeViscosity(Real temperature, Real rho, Real mu0) const = 0;
  virtual Real computedViscositydT(Real temperature, Real rho, Real drho_dT, Real mu0) const = 0;
  virtual Real computedViscositydp(Real temperature, Real rho, Real drho_dp) const = 0;

protected:
  bool _has_scaled_properties;
  const GamusinoScaling * _scaling_uo;
};

#endif // GAMUSINOFLUIDVISCOSITY_H
