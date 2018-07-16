#ifndef GAMUSINOPERMEABILITY_H
#define GAMUSINOPERMEABILITY_H

#include "GeneralUserObject.h"

class GamusinoPermeability;

template <>
InputParameters validParams<GamusinoPermeability>();

class GamusinoPermeability : public GeneralUserObject
{
public:
  GamusinoPermeability(const InputParameters & parameters);
  void initialize() {}
  void execute() {}
  void finalize() {}
  virtual std::vector<Real>
  computePermeability(std::vector<Real> k0, Real phi0, Real porosity, Real aperture) const = 0;
  virtual std::vector<Real>
  computedPermeabilitydev(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dev) const = 0;
  virtual std::vector<Real>
  computedPermeabilitydpf(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dpf) const = 0;
  virtual std::vector<Real>
  computedPermeabilitydT(std::vector<Real> k0, Real phi0, Real porosity, Real dphi_dTs) const = 0;
};

#endif // GAMUSINOPERMEABILITY_H
