#ifndef GMSENERGYTIMEDERIVATIVE_H
#define GMSENERGYTIMEDERIVATIVE_H

#include "TimeDerivative.h"

class GMSEnergyTimeDerivative;

template <>
InputParameters validParams<GMSEnergyTimeDerivative>();

class GMSEnergyTimeDerivative : public TimeDerivative
{
public:
  GMSEnergyTimeDerivative(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
};

#endif // GMSENERGYTIMEDERIVATIVE_H
