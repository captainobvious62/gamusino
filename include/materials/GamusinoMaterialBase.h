#ifndef GAMUSINOMATERIALBASE_H
#define GAMUSINOMATERIALBASE_H

#include "Material.h"
#include "RankTwoTensor.h"
#include "UserObjectInterface.h"
#include "Function.h"
#include "GamusinoFluidDensity.h"
#include "GamusinoFluidViscosity.h"
#include "GamusinoPermeability.h"
#include "GamusinoPorosity.h"
#include "GamusinoScaling.h"

class GamusinoMaterialBase;
class Function;

template <>
InputParameters validParams<GamusinoMaterialBase>();

class GamusinoMaterialBase : public Material
{
public:
  GamusinoMaterialBase(const InputParameters & parameters);
  static MooseEnum materialType();

protected:
  virtual void initQpStatefulProperties();
  void computeGravity();
  void computeRotationMatrix();
  Real computeQpScaling();
  bool _has_scaled_properties;
  Real _rho0_f;
  Real _rho0_s;
  Real _phi0;
  bool _has_gravity;
  Real _g;
  Real _scaling_factor0;
  Function * _function_scaling;
  Real _alpha_T_f;
  Real _alpha_T_s;
  const GamusinoFluidDensity * _fluid_density_uo;
  const GamusinoFluidViscosity * _fluid_viscosity_uo;
  const GamusinoPermeability * _permeability_uo;
  const GamusinoPorosity * _porosity_uo;
  const GamusinoScaling * _scaling_uo;
  MooseEnum _material_type;
  MaterialProperty<Real> & _scaling_factor;
  MaterialProperty<Real> & _porosity;
  MaterialProperty<Real> & _fluid_density;
  MaterialProperty<Real> & _fluid_viscosity;
  RealVectorValue _gravity;
  RankTwoTensor _rotation_matrix;
};

#endif // GAMUSINOMATERIALBASE_H
