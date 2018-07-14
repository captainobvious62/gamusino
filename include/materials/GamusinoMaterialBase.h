
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

//Forward Declarations
class GamusinoMaterialBase;
class Function;

template <>
InputParameters validParams<GamusinoMaterialBase>();

class GamusinoMaterialBase : public Material
{
public:
  GamusinoMaterialBase(const InputParameters & parameters);
  // Static method for use in validParams for getting the material type
  static MooseEnum materialType();

/* -------------------------------------------------------------------------- */
protected:

  virtual void initQpStatefulProperties();

  // ===============
  // local functions
  // ===============

  void computeGravity();
  void computeRotationMatrix();

  Real computeQpScaling();

  Function * _function_scaling;

  // Initial (inputted) Values
  Real _rho0_f;           // Initial fluid density, kg / m**3
  Real _rho0_s;           // Initial solid density, kg / m**3
  Real _phi0;             // Initial porosity, frac
  Real _g;                // Gravitational acceleration, m / s**2
  Real _scaling_factor0;  // Initial scaling factor for lower dimensional element, m
  Real _alpha_T_f;        // Fluid thermal expansion, 1 / K
  Real _alpha_T_s;        // Solid thermal expansion, 1 / K

  // Flags
  bool _has_gravity;      // Include gravity force flag
  bool _has_scaled_properties; // Scale function flag

  // User Objects
  const GamusinoFluidDensity * _fluid_density_uo;
  const GamusinoFluidViscosity * _fluid_viscosity_uo;
  const GamusinoPermeability * _permeability_uo;
  const GamusinoPorosity * _porosity_uo;
  const GamusinoScaling * _scaling_uo;

  // Choice from selection
  MooseEnum _material_type;

  // ===================
  // material properties
  // ===================
  MaterialProperty<Real> & _scaling_factor;
  MaterialProperty<Real> & _porosity;
  MaterialProperty<Real> & _fluid_density;
  MaterialProperty<Real> & _fluid_viscosity;
  RealVectorValue _gravity;
  RankTwoTensor _rotation_matrix;
};

#endif // GAMUSINOMATERIALBASE_H
