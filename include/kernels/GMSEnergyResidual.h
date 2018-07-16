#ifndef GMSENERGYRESIDUAL_H
#define GMSENERGYRESIDUAL_H

#include "Kernel.h"

class GMSEnergyResidual;

template <>
InputParameters validParams<GMSEnergyResidual>();

class GMSEnergyResidual : public Kernel
{
public:
  GMSEnergyResidual(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();

  const MaterialProperty<Real> & _bulk_thermal_conductivity;
  const MaterialProperty<Real> & _heat_production;
  const MaterialProperty<Real> & _bulk_specific_heat;
  const MaterialProperty<Real> & _bulk_density;
  const MaterialProperty<Real> & _scale_factor;
};

#endif // GMSENERGYRESIDUAL_H
