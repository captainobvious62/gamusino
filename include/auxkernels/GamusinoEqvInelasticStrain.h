#ifndef GOLEMEQVINELASTICSTRAIN_H
#define GOLEMEQVINELASTICSTRAIN_H

#include "AuxKernel.h"
#include "RankTwoTensor.h"

class GamusinoEqvInelasticStrain;

template <>
InputParameters validParams<GamusinoEqvInelasticStrain>();

class GamusinoEqvInelasticStrain : public AuxKernel
{
public:
  GamusinoEqvInelasticStrain(const InputParameters & parameters);

protected:
  virtual Real computeValue();
  const MaterialProperty<RankTwoTensor> & _inelastic_strain;
  const MaterialProperty<RankTwoTensor> & _inelastic_strain_old;
};

#endif // GOLEMEQVINELASTICSTRAIN_H
