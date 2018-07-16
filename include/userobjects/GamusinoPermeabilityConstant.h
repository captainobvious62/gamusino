#ifndef GAMUSINOPERMEABILITYCONSTANT_H
#define GAMUSINOPERMEABILITYCONSTANT_H

#include "GamusinoPermeability.h"

class GamusinoPermeabilityConstant;

template <>
InputParameters validParams<GamusinoPermeabilityConstant>();

class GamusinoPermeabilityConstant : public GamusinoPermeability
{
public:
  GamusinoPermeabilityConstant(const InputParameters & parameters);
  std::vector<Real>
  computePermeability(std::vector<Real> k0, Real phi0, Real porosity, Real aperture) const;
  std::vector<Real>
  computedPermeabilitydev(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dev) const;
  std::vector<Real>
  computedPermeabilitydpf(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dpf) const;
  std::vector<Real>
  computedPermeabilitydT(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dT) const;
};

#endif // GAMUSINOPERMEABILITYCONSTANT_H
