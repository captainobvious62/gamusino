
#include "GamusinoPorosityConstant.h"

template <>
InputParameters
validParams<GamusinoPorosityConstant>()
{
  InputParameters params = validParams<GamusinoPorosity>();
  params.addClassDescription("Constant Porosity formulation.");
  return params;
}

GamusinoPorosityConstant::GamusinoPorosityConstant(const InputParameters & parameters)
  : GamusinoPorosity(parameters)
{
}

Real
GamusinoPorosityConstant::computePorosity(Real phi_old, Real, Real, Real, Real, Real, Real) const
{
  return phi_old;
}

Real GamusinoPorosityConstant::computedPorositydev(Real, Real) const { return 0.0; }

Real GamusinoPorosityConstant::computedPorositydpf(Real, Real, Real) const { return 0.0; }

Real GamusinoPorosityConstant::computedPorositydT(Real, Real, Real, Real) const { return 0.0; }
