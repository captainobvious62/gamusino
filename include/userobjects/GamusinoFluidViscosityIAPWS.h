#ifndef GAMUSINOFLUIDVISCOSITYIAPWS_H
#define GAMUSINOFLUIDVISCOSITYIAPWS_H

#include "GamusinoFluidViscosity.h"

class GamusinoFluidViscosityIAPWS;

template <>
InputParameters validParams<GamusinoFluidViscosityIAPWS>();

class GamusinoFluidViscosityIAPWS : public GamusinoFluidViscosity
{
public:
  GamusinoFluidViscosityIAPWS(const InputParameters & parameters);
  Real computeViscosity(Real temperature, Real rho, Real) const;
  Real computedViscositydT(Real temperature, Real rho, Real drho_dT, Real) const;
  Real computedViscositydp(Real temperature, Real rho, Real drho_dT) const;

private:
  Real mu0Region1(Real temp) const;
  Real mu1Region1(Real temp, Real rho) const;
  Real critical_enhancement() const;
  Real dmu0dTRegion1(Real temp) const;
  Real dmu1dTRegion1(Real temp, Real rho, Real drho_dT) const;
  Real dmu1dpRegion1(Real temp, Real rho, Real drho_dp) const;

  bool _has_kelvin;
};

#endif // GAMUSINOFLUIDVISCOSITYIAPWS_H
