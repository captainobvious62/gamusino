#ifndef GAMUSINOKERNELHPOROELASTIC_H
#define GAMUSINOKERNELHPOROELASTIC_H

#include "Kernel.h"

class GamusinoKernelHPoroElastic;

template <>
InputParameters validParams<GamusinoKernelHPoroElastic>();

class GamusinoKernelHPoroElastic : public Kernel
{
public:
  GamusinoKernelHPoroElastic(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  unsigned int _ndisp;
  std::vector<unsigned int> _disp_var;
  const MaterialProperty<Real> & _biot;
  const MaterialProperty<Real> & _vol_strain_rate;
};

#endif // GAMUSINOKERNELHPOROELASTIC_H
