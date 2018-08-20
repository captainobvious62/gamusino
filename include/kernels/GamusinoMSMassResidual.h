#ifndef GAMUSINOMSMASSRESIDUAL_H
#define GAMUSINOMSMASSRESIDUAL_H

#include "Kernel.h"

class GamusinoMSMassResidual;

template <>
InputParameters validParams<GamusinoMSMassResidual>();

class GamusinoMSMassResidual : public Kernel
{
public:
  GamusinoMSMassResidual(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  const MaterialProperty<Real> & _bulk_density;
  const MaterialProperty<RealVectorValue> & _gravity;
};

#endif // GAMUSINOMSMASSRESIDUAL_H
