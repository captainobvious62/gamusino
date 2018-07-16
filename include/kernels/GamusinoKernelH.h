#ifndef GAMUSINOKERNELH_H
#define GAMUSINOKERNELH_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"
#include "RankTwoTensor.h"

class GamusinoKernelH;
class RankTwoTensor;

template <>
InputParameters validParams<GamusinoKernelH>();

class GamusinoKernelH : public DerivativeMaterialInterface<Kernel>
{
public:
  GamusinoKernelH(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  bool _has_T;
  bool _has_disp;
  bool _has_boussinesq;
  const MaterialProperty<Real> & _scaling_factor;
  const MaterialProperty<RealVectorValue> & _H_kernel_grav;
  const MaterialProperty<RankTwoTensor> & _H_kernel;
  // Properties derivatives
  const MaterialProperty<RealVectorValue> & _dH_kernel_grav_dpf;
  const MaterialProperty<RealVectorValue> & _dH_kernel_grav_dT;
  const MaterialProperty<RankTwoTensor> & _dH_kernel_dev;
  const MaterialProperty<RankTwoTensor> & _dH_kernel_dpf;
  const MaterialProperty<RankTwoTensor> & _dH_kernel_dT;
  const VariableGradient * _grad_temp;
  const MaterialProperty<Real> * _fluid_density;
  const MaterialProperty<Real> * _drho_dpf;
  const MaterialProperty<Real> * _drho_dT;

private:
  unsigned int _T_var;
  // unsigned int _brine_var;
  unsigned int _ndisp;
  std::vector<unsigned int> _disp_var;
};
#endif // GAMUSINOKERNELH_H
