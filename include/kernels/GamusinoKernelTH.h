#ifndef GAMUSINOKERNELTH_H
#define GAMUSINOKERNELTH_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"
#include "RankTwoTensor.h"

class GamusinoKernelTH;
class RankTwoTensor;

template <>
InputParameters validParams<GamusinoKernelTH>();

class GamusinoKernelTH : public DerivativeMaterialInterface<Kernel>
{
public:
  GamusinoKernelTH(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  bool _is_conservative;
  bool _has_lumped_mass_matrix;
  bool _has_SUPG_upwind;
  bool _has_disp;
  const VariableValue & _u_old;
  const VariableGradient & _grad_pf;
  const MaterialProperty<Real> & _scaling_factor;
  // Advection material properties
  const MaterialProperty<RealVectorValue> & _H_kernel_grav;
  const MaterialProperty<RankTwoTensor> & _TH_kernel;
  // Conduction material properties
  const MaterialProperty<Real> & _T_kernel_diff;
  const MaterialProperty<Real> & _T_kernel_source;
  const MaterialProperty<Real> & _T_kernel_time;
  // Properties derivatives
  const MaterialProperty<RankTwoTensor> & _dTH_kernel_dev;
  const MaterialProperty<RankTwoTensor> & _dTH_kernel_dT;
  const MaterialProperty<RankTwoTensor> & _dTH_kernel_dpf;
  const MaterialProperty<RealVectorValue> & _dH_kernel_grav_dT;
  const MaterialProperty<RealVectorValue> & _dH_kernel_grav_dpf;
  const MaterialProperty<Real> & _dT_kernel_diff_dT;
  const MaterialProperty<Real> & _dT_kernel_diff_dpf;
  const MaterialProperty<Real> & _dT_kernel_diff_dev;
  const MaterialProperty<Real> & _dT_kernel_time_dT;
  const MaterialProperty<Real> & _dT_kernel_time_dpf;
  const MaterialProperty<Real> & _dT_kernel_time_dev;
  // SUPG related material properties
  const MaterialProperty<RealVectorValue> & _SUPG_N;
  const MaterialProperty<RankTwoTensor> & _SUPG_dtau_dgradpf;
  const MaterialProperty<RealVectorValue> & _SUPG_dtau_dpf;
  const MaterialProperty<RealVectorValue> & _SUPG_dtau_dT;
  const MaterialProperty<RealVectorValue> & _SUPG_dtau_dev;

private:
  unsigned int _pf_var;
  unsigned int _ndisp;
  std::vector<unsigned int> _disp_var;
};

#endif // GAMUSINOKERNELTH_H
