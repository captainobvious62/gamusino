#ifndef GAMUSINOMATERIALMELASTIC_H
#define GAMUSINOMATERIALMELASTIC_H

#include "GamusinoMaterialBase.h"
#include "RankTwoTensor.h"
#include "RankFourTensor.h"
#include "GamusinoPorosity.h"
#include "GamusinoSUPG.h"

class GamusinoMaterialMElastic;

template <>
InputParameters validParams<GamusinoMaterialMElastic>();

class GamusinoMaterialMElastic : public GamusinoMaterialBase
{
public:
  GamusinoMaterialMElastic(const InputParameters & parameters);
  static MooseEnum strainModel();
  static MooseEnum permeabilityType();
  void setPropertiesM();
  void setStrainModel();
  void setElasticModuli();
  void setBackgroundStress();
  void setPropertiesHM();
  void setPropertiesTM();
  void setPropertiesTHM();

protected:
  virtual void initQpStatefulProperties();
  virtual void computeProperties();
  virtual void computeStrain();
  virtual void computeQpFiniteStrain();
  virtual void computeQpProperties();
  virtual void GamusinoCrackClosure();
  virtual void GamusinoMatPropertiesHM();
  virtual void GamusinoKernelPropertiesHM();
  virtual void GamusinoKernelPropertiesDerivativesHM();
  virtual void GamusinoMatPropertiesTM();
  virtual void GamusinoKernelPropertiesTM();
  virtual void GamusinoKernelPropertiesDerivativesTM();
  virtual void GamusinoMatPropertiesTHM();
  virtual void GamusinoKernelPropertiesTHM();
  virtual void GamusinoKernelPropertiesDerivativesTHM();
  virtual unsigned nearest();
  virtual void GamusinoMatPropertiesM();
  virtual void GamusinoKernelPropertiesM();
  virtual void GamusinoSubstractEigenStrain();
  virtual void substractThermalEigenStrain(RankTwoTensor & strain_incr);
  virtual void GamusinoStress();

  // ======================== Mechanical properties ============================
  unsigned int _ndisp;
  std::vector<const VariableValue *> _disp;
  std::vector<const VariableGradient *> _grad_disp;
  MooseEnum _strain_model;
  bool _volumetric_locking_correction;
  MaterialProperty<RankTwoTensor> & _mechanical_strain;
  std::vector<RankTwoTensor> _total_strain;
  std::vector<RankFourTensor> _Cijkl;
  bool _bulk_modulus_set, _lame_modulus_set, _poisson_ratio_set, _shear_modulus_set,
      _young_modulus_set;
  MaterialProperty<RankTwoTensor> & _stress;
  MaterialProperty<RankFourTensor> & _M_jacobian;
  MaterialProperty<RealVectorValue> & _M_kernel_grav;
  const MaterialProperty<Real> & _porosity_old;
  // SetPropertiesM
  // SetStrainModel
  std::vector<const VariableGradient *> * _grad_disp_old;
  const MaterialProperty<RankTwoTensor> * _mechanical_strain_old;
  std::vector<RankTwoTensor> * _strain_increment;
  std::vector<RankTwoTensor> * _total_strain_increment;
  const MaterialProperty<RankTwoTensor> * _stress_old;
  const Real * _current_elem_volume;
  std::vector<RankTwoTensor> * _Fhat;
  MaterialProperty<RankTwoTensor> * _deformation_gradient;
  const MaterialProperty<RankTwoTensor> * _deformation_gradient_old;
  MaterialProperty<RankTwoTensor> * _rotation_increment;
  // setElasticModuli
  bool _crack_closure_set;
  Real * _K_i;
  Real * _K_end;
  Real * _G;
  Real * _p_hat;
  // SetBackgroundStress
  std::vector<Function *> _background_stress;
  // ============================ HM properties ================================
  bool _has_pf;
  MooseEnum _permeability_type;
  std::vector<Real> _k0;
  Real _mu0;
  Real _Kf;
  Real _Ks;
  MaterialProperty<std::vector<Real>> * _permeability;
  MaterialProperty<Real> * _H_kernel_time;
  MaterialProperty<RealVectorValue> * _H_kernel_grav;
  MaterialProperty<RankTwoTensor> * _H_kernel;
  MaterialProperty<Real> * _biot;
  MaterialProperty<Real> * _vol_strain_rate;
  const VariableValue * _pf;
  const VariableValue * _pf_old;
  MaterialProperty<Real> * _dphi_dev;
  MaterialProperty<Real> * _dphi_dpf;
  MaterialProperty<std::vector<Real>> * _dk_dev;
  MaterialProperty<std::vector<Real>> * _dk_dpf;
  MaterialProperty<Real> * _dH_kernel_time_dev;
  MaterialProperty<Real> * _dH_kernel_time_dpf;
  MaterialProperty<RealVectorValue> * _dM_kernel_grav_dev;
  MaterialProperty<RealVectorValue> * _dM_kernel_grav_dpf;
  // ============================ TM properties ================================
  bool _has_T;
  bool _has_T_source_sink;
  Real _lambda_f;
  Real _lambda_s;
  Real _c_f;
  Real _c_s;
  Real _T_source_sink;
  MaterialProperty<Real> * _T_kernel_time;
  MaterialProperty<Real> * _T_kernel_diff;
  MaterialProperty<Real> * _T_kernel_source;
  const VariableValue * _temp;
  const VariableValue * _temp_old;
  MaterialProperty<RankTwoTensor> * _TM_jacobian;
  // ============================ THM properties ===============================
  bool _has_SUPG_upwind;
  bool _has_lumped_mass_matrix;
  const GamusinoSUPG * _supg_uo;
  MaterialProperty<RankTwoTensor> * _TH_kernel;
  MaterialProperty<Real> * _dphi_dT;
  MaterialProperty<std::vector<Real>> * _dk_dT;
  MaterialProperty<Real> * _drho_dpf;
  MaterialProperty<Real> * _drho_dT;
  MaterialProperty<Real> * _dmu_dpf;
  MaterialProperty<Real> * _dmu_dT;
  MaterialProperty<Real> * _dT_kernel_diff_dev;
  MaterialProperty<Real> * _dT_kernel_diff_dpf;
  MaterialProperty<Real> * _dT_kernel_diff_dT;
  MaterialProperty<RankTwoTensor> * _dH_kernel_dev;
  MaterialProperty<RankTwoTensor> * _dH_kernel_dpf;
  MaterialProperty<RankTwoTensor> * _dH_kernel_dT;
  MaterialProperty<RankTwoTensor> * _dTH_kernel_dev;
  MaterialProperty<RankTwoTensor> * _dTH_kernel_dpf;
  MaterialProperty<RankTwoTensor> * _dTH_kernel_dT;
  MaterialProperty<Real> * _dT_kernel_time_dev;
  MaterialProperty<Real> * _dT_kernel_time_dpf;
  MaterialProperty<Real> * _dT_kernel_time_dT;
  MaterialProperty<Real> * _dH_kernel_time_dT;
  MaterialProperty<RealVectorValue> * _dH_kernel_grav_dpf;
  MaterialProperty<RealVectorValue> * _dH_kernel_grav_dT;
  MaterialProperty<RealVectorValue> * _dM_kernel_grav_dT;
  const VariableGradient * _grad_pf;
  MaterialProperty<RealVectorValue> * _SUPG_N;
  MaterialProperty<RankTwoTensor> * _SUPG_dtau_dgradpf;
  MaterialProperty<RealVectorValue> * _SUPG_dtau_dpf;
  MaterialProperty<RealVectorValue> * _SUPG_dtau_dT;
  MaterialProperty<RealVectorValue> * _SUPG_dtau_dev;
  MaterialProperty<unsigned int> * _node_number;
  MaterialProperty<Real> * _nodal_pf;
  MaterialProperty<Real> * _nodal_pf_old;
  MaterialProperty<Real> * _nodal_temp;
  MaterialProperty<Real> * _nodal_temp_old;
  const VariableValue * _nodal_pf_var;
  const VariableValue * _nodal_pf_var_old;
  const VariableValue * _nodal_temp_var;
  const VariableValue * _nodal_temp_var_old;
};

#endif // GAMUSINOMATERIALMELASTIC_H
