#ifndef GAMUSINOMSENERGYRESIDUAL_H
#define GAMUSINOMSENERGYRESIDUAL_H

#include "Kernel.h"

class GamusinoMSEnergyResidual;

template <>
InputParameters validParams<GamusinoMSEnergyResidual>();

class GamusinoMSEnergyResidual : public Kernel
{
public:
  GamusinoMSEnergyResidual(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  const MaterialProperty<Real> & _bulk_thermal_conductivity;
  const MaterialProperty<Real> & _heat_production;
  const MaterialProperty<Real> & _bulk_specific_heat;
  const MaterialProperty<Real> & _bulk_density;
  const MaterialProperty<Real> & _scale_factor;
};

#endif // GAMUSINOMSENERGYRESIDUAL_H
