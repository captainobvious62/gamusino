#ifndef GAMUSINOPOROSITYCONSTANT_H
#define GAMUSINOPOROSITYCONSTANT_H

#include "GamusinoPorosity.h"

class GamusinoPorosityConstant;

template <>
InputParameters validParams<GamusinoPorosityConstant>();

class GamusinoPorosityConstant : public GamusinoPorosity
{
public:
  GamusinoPorosityConstant(const InputParameters & parameters);
  Real computePorosity(Real phi_old, Real, Real, Real, Real, Real, Real) const;
  Real computedPorositydev(Real, Real) const;
  Real computedPorositydpf(Real, Real, Real) const;
  Real computedPorositydT(Real, Real, Real, Real) const;
};

#endif // GAMUSINOPOROSITYCONSTANT_H
