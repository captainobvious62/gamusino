#ifndef GAMUSINOPOROSITYTHM_H
#define GAMUSINOPOROSITYTHM_H

#include "GamusinoPorosity.h"

class GamusinoPorosityTHM;

template <>
InputParameters validParams<GamusinoPorosityTHM>();

class GamusinoPorosityTHM : public GamusinoPorosity
{
public:
  GamusinoPorosityTHM(const InputParameters & parameters);
  Real computePorosity(
      Real phi_old, Real dphi_dev, Real dphi_dpf, Real dphi_dT, Real dev, Real dpf, Real dT) const;
  Real computedPorositydev(Real phi_old, Real biot) const;
  Real computedPorositydpf(Real phi_old, Real biot, Real Ks) const;
  Real computedPorositydT(Real phi_old, Real biot, Real beta_f, Real beta_s) const;
};

#endif // GAMUSINOPOROSITYTHM_H
