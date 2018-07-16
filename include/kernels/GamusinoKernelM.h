#ifndef GAMUSINOKERNELM_H
#define GAMUSINOKERNELM_H

#include "Kernel.h"
#include "DerivativeMaterialInterface.h"
#include "RankTwoTensor.h"
#include "RankFourTensor.h"

class GamusinoKernelM;
class RankTwoTensor;
class RankFourTensor;

template <>
InputParameters validParams<GamusinoKernelM>();

class GamusinoKernelM : public DerivativeMaterialInterface<Kernel>
{
public:
  GamusinoKernelM(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual void computeJacobian();
  virtual Real computeQpJacobian();
  virtual void computeOffDiagJacobian(MooseVariableFEBase & jvar);
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);
  virtual void computeFiniteDeformJacobian();

  const bool _has_pf;
  const bool _has_T;
  bool _use_finite_deform_jacobian;
  const MaterialProperty<RankTwoTensor> & _stress;
  const MaterialProperty<RealVectorValue> & _M_kernel_grav;
  const MaterialProperty<RankFourTensor> & _M_jacobian;
  Assembly * _assembly_undisplaced;
  const VariablePhiGradient * _grad_phi_undisplaced;
  std::vector<RankFourTensor> _finite_deform_jacobian;
  const MaterialProperty<RankTwoTensor> * _deformation_gradient;
  const MaterialProperty<RankTwoTensor> * _deformation_gradient_old;
  const MaterialProperty<RankTwoTensor> * _rotation_increment;
  const unsigned int _component;
  unsigned int _ndisp;
  std::vector<unsigned int> _disp_var;
  const VariableValue & _pf;
  const unsigned int _pf_var;
  const MaterialProperty<Real> & _biot;
  const unsigned int _T_var;
  const MaterialProperty<RankTwoTensor> & _TM_jacobian;
  const MaterialProperty<RealVectorValue> & _dM_kernel_grav_dev;
  const MaterialProperty<RealVectorValue> & _dM_kernel_grav_dpf;
  const MaterialProperty<RealVectorValue> & _dM_kernel_grav_dT;
};

#endif // GAMUSINOKERNELM_H
