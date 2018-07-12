
#include "GamusinoPorosityTHM.h"

template <>
InputParameters
validParams<GamusinoPorosityTHM>()
{
  InputParameters params = validParams<GamusinoPorosity>();
  params.addClassDescription("Porosity formulation for thermo-hydro-mechanical coupling.");
  return params;
}

GamusinoPorosityTHM::GamusinoPorosityTHM(const InputParameters & parameters) : GamusinoPorosity(parameters)
{
}

Real
GamusinoPorosityTHM::computePorosity(
    Real phi_old, Real dphi_dev, Real dphi_dpf, Real dphi_dT, Real dev, Real dpf, Real dT) const
{
  return phi_old + dphi_dev * dev + dphi_dpf * dpf + dphi_dT * dT;
}

Real
GamusinoPorosityTHM::computedPorositydev(Real phi_old, Real biot) const
{
  return (biot - phi_old);
}

Real
GamusinoPorosityTHM::computedPorositydpf(Real phi_old, Real biot, Real Ks) const
{
  return (biot - phi_old) / Ks;
}

Real
GamusinoPorosityTHM::computedPorositydT(Real phi_old, Real biot, Real beta_f, Real beta_s) const
{
  return phi_old * (1.0 - biot) * beta_f - biot * (1.0 - phi_old) * beta_s;
}
