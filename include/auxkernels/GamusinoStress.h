#ifndef GAMUSINOSTRESS_H
#define GAMUSINOSTRESS_H

#include "AuxKernel.h"
#include "RankTwoTensor.h"

class GamusinoStress;

template <>
InputParameters validParams<GamusinoStress>();

class GamusinoStress : public AuxKernel
{
public:
  GamusinoStress(const InputParameters & parameters);

protected:
  virtual Real computeValue();

private:
  const MaterialProperty<RankTwoTensor> & _stress;
  const unsigned int _i;
  const unsigned int _j;
};

#endif // GAMUSINOSTRESS_H
