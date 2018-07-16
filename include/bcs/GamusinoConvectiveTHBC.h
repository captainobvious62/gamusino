#ifndef GAMUSINOCONVECTIVETHBC_H
#define GAMUSINOCONVECTIVETHBC_H

#include "IntegratedBC.h"
#include "DerivativeMaterialInterface.h"
#include "RankTwoTensor.h"

class GamusinoConvectiveTHBC;

template <>
InputParameters validParams<GamusinoConvectiveTHBC>();

class GamusinoConvectiveTHBC : public DerivativeMaterialInterface<IntegratedBC>
{
public:
  GamusinoConvectiveTHBC(const InputParameters & params);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int);

  bool _has_disp;
  const VariableGradient & _grad_pf;
  const MaterialProperty<Real> & _scaling_factor;
  const MaterialProperty<RealVectorValue> & _H_kernel_grav;
  const MaterialProperty<RankTwoTensor> & _TH_kernel;
  const MaterialProperty<Real> & _T_kernel_diff;
  // Properties derivatives
  const MaterialProperty<RankTwoTensor> & _dTH_kernel_dT;
  const MaterialProperty<RankTwoTensor> & _dTH_kernel_dpf;
  const MaterialProperty<RealVectorValue> & _dH_kernel_grav_dT;
  const MaterialProperty<RealVectorValue> & _dH_kernel_grav_dpf;
  const MaterialProperty<Real> & _dT_kernel_diff_dT;
  const MaterialProperty<Real> & _dT_kernel_diff_dpf;
  const MaterialProperty<Real> & _dT_kernel_diff_dev;

private:
  unsigned int _p_var;
  unsigned int _ndisp;
  std::vector<unsigned int> _disp_var;
};

#endif // GAMUSINOCONVECTIVETHBC_H
