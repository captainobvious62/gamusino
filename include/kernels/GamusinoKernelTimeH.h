#ifndef GAMUSINOKERNELTIMEH_H
#define GAMUSINOKERNELTIMEH_H

#include "TimeDerivative.h"
#include "DerivativeMaterialInterface.h"

class GamusinoKernelTimeH;

template <>
InputParameters validParams<GamusinoKernelTimeH>();

class GamusinoKernelTimeH : public DerivativeMaterialInterface<TimeDerivative>
{
public:
  GamusinoKernelTimeH(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  bool _has_T;
  bool _has_disp;
  // bool _has_brine;
  const VariableValue & _temp;
  const VariableValue & _temp_old;
  // const VariableValue & _brine;
  // const VariableValue & _brine_old;
  const MaterialProperty<Real> & _scaling_factor;
  const MaterialProperty<Real> & _H_kernel_time;
  const MaterialProperty<Real> & _dH_kernel_time_dpf;
  const MaterialProperty<Real> & _dH_kernel_time_dT;
  const MaterialProperty<Real> & _dH_kernel_time_dev;

private:
  unsigned int _temp_var;
  unsigned int _ndisp;
  std::vector<unsigned int> _disp_var;
  // unsigned int _brine_var;
};

#endif // GAMUSINOKERNELTIMEH_H
