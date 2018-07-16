#ifndef GMSMATERIAL_H
#define GMSMATERIAL_H

#include "Material.h"
#include "GamusinoPropertyReadFile.h"

class GMSMaterial;

template <>
InputParameters validParams<GMSMaterial>();

class GMSMaterial : public Material
{
public:
  GMSMaterial(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();
  Real computeEOSlambda(Real, Real);

  // Coupled vars
  bool _is_temp_coupled;
  bool _is_load_coupled;
  const VariableValue & _temp;
  const VariableValue & _load;
  // Parameters
  bool _has_lambda_pT;
  bool _has_read_prop_uo;
  Real _rho_b;
  Real _lambda_b;
  Real _c_b;
  Real _h_prod;
  Real _scale_factor;
  // user object variable
  const GamusinoPropertyReadFile * _read_prop_user_object;
  // Properties
  MaterialProperty<Real> & _bulk_density;
  MaterialProperty<Real> & _bulk_thermal_conductivity;
  MaterialProperty<Real> & _bulk_specific_heat;
  MaterialProperty<Real> & _heat_production;
  MaterialProperty<Real> & _scale;
  MaterialProperty<RealVectorValue> & _gravity;
};

#endif // GMSMATERIAL_H
