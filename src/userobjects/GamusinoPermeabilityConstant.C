
#include "GamusinoPermeabilityConstant.h"

template <>
InputParameters
validParams<GamusinoPermeabilityConstant>()
{
  InputParameters params = validParams<GamusinoPermeability>();
  params.addClassDescription("Constant Permeability formulation.");
  return params;
}

GamusinoPermeabilityConstant::GamusinoPermeabilityConstant(const InputParameters & parameters)
  : GamusinoPermeability(parameters)
{
}

std::vector<Real>
GamusinoPermeabilityConstant::computePermeability(std::vector<Real> k0, Real, Real, Real) const
{
  return k0;
}

std::vector<Real>
GamusinoPermeabilityConstant::computedPermeabilitydev(std::vector<Real> k0, Real, Real, Real) const
{
  std::vector<Real> dk_dev(k0.size(), 0.0);
  return dk_dev;
}

std::vector<Real>
GamusinoPermeabilityConstant::computedPermeabilitydpf(std::vector<Real> k0, Real, Real, Real) const
{
  std::vector<Real> dk_dpf(k0.size(), 0.0);
  return dk_dpf;
}

std::vector<Real>
GamusinoPermeabilityConstant::computedPermeabilitydT(std::vector<Real> k0, Real, Real, Real) const
{
  std::vector<Real> dk_dT(k0.size(), 0.0);
  return dk_dT;
}
