#ifndef GAMUSINODARCYVELOCITY_H
#define GAMUSINODARCYVELOCITY_H

#include "AuxKernel.h"
#include "RankTwoTensor.h"

class GamusinoDarcyVelocity;

template <>
InputParameters validParams<GamusinoDarcyVelocity>();

class GamusinoDarcyVelocity : public AuxKernel
{
public:
  GamusinoDarcyVelocity(const InputParameters & parameters);

protected:
  virtual Real computeValue();

  const VariableGradient & _grad_pf;
  const MaterialProperty<RankTwoTensor> & _H_kernel;
  const MaterialProperty<RealVectorValue> & _H_kernel_grav;
  int _component;
};

#endif // GAMUSINODARCYVELOCITY_H
