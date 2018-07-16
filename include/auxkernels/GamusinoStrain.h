#ifndef GAMUSINOSTRAIN_H
#define GAMUSINOSTRAIN_H

#include "AuxKernel.h"
#include "RankTwoTensor.h"

class GamusinoStrain;

template <>
InputParameters validParams<GamusinoStrain>();

class GamusinoStrain : public AuxKernel
{
public:
  GamusinoStrain(const InputParameters & parameters);
  static MooseEnum strainType();

protected:
  virtual Real computeValue();

  MooseEnum _strain_type;

private:
  const unsigned int _i;
  const unsigned int _j;
  const MaterialProperty<RankTwoTensor> * _strain;
};

#endif // GAMUSINOSTRAIN_H
