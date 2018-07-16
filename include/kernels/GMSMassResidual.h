#ifndef GMSMASSRESIDUAL_H
#define GMSMASSRESIDUAL_H

#include "Kernel.h"

class GMSMassResidual;

template <>
InputParameters validParams<GMSMassResidual>();

class GMSMassResidual : public Kernel
{
public:
  GMSMassResidual(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  const MaterialProperty<Real> & _bulk_density;
  const MaterialProperty<RealVectorValue> & _gravity;
};

#endif // GMSMASSRESIDUAL_H
