#ifndef GAMUSINOFLUIDVELOCITY_H
#define GAMUSINOFLUIDVELOCITY_H

#include "GamusinoDarcyVelocity.h"

class GamusinoFluidVelocity;

template <>
InputParameters validParams<GamusinoFluidVelocity>();

class GamusinoFluidVelocity : public GamusinoDarcyVelocity
{
public:
  GamusinoFluidVelocity(const InputParameters & parameters);

protected:
  virtual Real computeValue();
  const MaterialProperty<Real> & _porosity;
};

#endif // GAMUSINODARCYVELOCITY_H
