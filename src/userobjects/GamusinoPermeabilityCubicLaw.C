
#include "GamusinoPermeabilityCubicLaw.h"
#include "libmesh/utility.h"

template <>
InputParameters
validParams<GamusinoPermeabilityCubicLaw>()
{
  InputParameters params = validParams<GamusinoPermeability>();
  params.addClassDescription("Cubic law permeability formulation.");
  return params;
}

GamusinoPermeabilityCubicLaw::GamusinoPermeabilityCubicLaw(const InputParameters & parameters)
  : GamusinoPermeability(parameters)
{
}

std::vector<Real>
GamusinoPermeabilityCubicLaw::computePermeability(std::vector<Real> k0,
                                               Real,
                                               Real,
                                               Real aperture) const
{
  Real cl = Utility::pow<2>(aperture) / 8.0;
  for (unsigned int i = 0; i < k0.size(); ++i)
    k0[i] = cl;
  return k0;
}

std::vector<Real>
GamusinoPermeabilityCubicLaw::computedPermeabilitydev(std::vector<Real> k0, Real, Real, Real) const
{
  std::vector<Real> dk_dev(k0.size(), 0.0);
  return dk_dev;
}

std::vector<Real>
GamusinoPermeabilityCubicLaw::computedPermeabilitydpf(std::vector<Real> k0, Real, Real, Real) const
{
  std::vector<Real> dk_dpf(k0.size(), 0.0);
  return dk_dpf;
}

std::vector<Real>
GamusinoPermeabilityCubicLaw::computedPermeabilitydT(std::vector<Real> k0, Real, Real, Real) const
{
  std::vector<Real> dk_dT(k0.size(), 0.0);
  return dk_dT;
}
