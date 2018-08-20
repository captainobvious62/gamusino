#ifndef GAMUSINOMSENERGYTIMEDERIVATIVE_H
#define GAMUSINOMSENERGYTIMEDERIVATIVE_H

#include "TimeDerivative.h"

class GamusinoMSEnergyTimeDerivative;

template <>
InputParameters validParams<GamusinoMSEnergyTimeDerivative>();

class GamusinoMSEnergyTimeDerivative : public TimeDerivative
{
public:
  GamusinoMSEnergyTimeDerivative(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
};

#endif // GAMUSINOMSENERGYTIMEDERIVATIVE_H
