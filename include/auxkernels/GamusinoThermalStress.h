#ifndef GAMUSINOTHERMALSTRESS_H
#define GAMUSINOTHERMALSTRESS_H

#include "AuxKernel.h"
#include "RankTwoTensor.h"

class GamusinoThermalStress;

template <>
InputParameters validParams<GamusinoThermalStress>();

class GamusinoThermalStress : public AuxKernel
{
public:
  GamusinoThermalStress(const InputParameters & parameters);

protected:
  virtual Real computeValue();
  const VariableValue & _temp;
  const VariableValue * _temp_old;
  const unsigned int _i;
  const MaterialProperty<RankTwoTensor> & _TM_jacobian;
};

#endif // GAMUSINOTHERMALSTRESS_H
