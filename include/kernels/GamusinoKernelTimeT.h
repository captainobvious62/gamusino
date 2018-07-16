#ifndef GAMUSINOKERNELTIMET_H
#define GAMUSINOKERNELTIMET_H

#include "TimeDerivative.h"
#include "DerivativeMaterialInterface.h"

class GamusinoKernelTimeT;

template <>
InputParameters validParams<GamusinoKernelTimeT>();

class GamusinoKernelTimeT : public DerivativeMaterialInterface<TimeDerivative>
{
public:
  GamusinoKernelTimeT(const InputParameters & parameters);

protected:
  virtual void computeResidual();
  virtual Real computeQpResidual();
  virtual void computeJacobian();
  virtual Real computeQpJacobian();
  virtual void computeOffDiagJacobian(MooseVariableFEBase & jvar);
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

  bool _has_lumped_mass_matrix;
  bool _has_boussinesq;
  const VariableValue & _u_old;
  bool _has_pf;
  bool _has_disp;
  const MaterialProperty<Real> & _scaling_factor;
  const MaterialProperty<Real> & _T_kernel_time;
  const MaterialProperty<Real> & _dT_kernel_time_dT;
  const MaterialProperty<Real> & _dT_kernel_time_dpf;
  const MaterialProperty<Real> & _dT_kernel_time_dev;
  // nodal value related material properties --> for lumping the mass matrix at nodes
  std::vector<int> _qp_map;
  const MaterialProperty<unsigned int> * _node_number;
  const MaterialProperty<Real> * _nodal_temp;
  const MaterialProperty<Real> * _nodal_temp_old;
  // boussinesq related material properties --> lumped
  const MaterialProperty<Real> * _nodal_pf;
  const MaterialProperty<Real> * _nodal_pf_old;
  // boussinesq related material properties --> not lumped
  const VariableValue * _pf;
  const VariableValue * _pf_old;

private:
  unsigned int _pf_var;
  unsigned int _ndisp;
  std::vector<unsigned int> _disp_var;
};

#endif // GAMUSINOKERNELTIMET_H
