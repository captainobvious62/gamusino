#ifndef GAMUSINOPERMEABILITYCUBICLAW_H
#define GAMUSINOPERMEABILITYCUBICLAW_H

#include "GamusinoPermeability.h"

class GamusinoPermeabilityCubicLaw;

template <>
InputParameters validParams<GamusinoPermeabilityCubicLaw>();

class GamusinoPermeabilityCubicLaw : public GamusinoPermeability
{
public:
  GamusinoPermeabilityCubicLaw(const InputParameters & parameters);
  std::vector<Real>
  computePermeability(std::vector<Real> k0, Real phi0, Real porosity, Real aperture) const;
  std::vector<Real>
  computedPermeabilitydev(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dev) const;
  std::vector<Real>
  computedPermeabilitydpf(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dpf) const;
  std::vector<Real>
  computedPermeabilitydT(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dT) const;
};

#endif // GAMUSINOPERMEABILITYCUBICLAW_H
