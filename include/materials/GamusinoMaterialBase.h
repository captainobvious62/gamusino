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

// ===============
// local functions
// ===============

  void computeGravity();
  void computeRotationMatrix();
  Real computeQpScaling();

// ================
// MOOSE enumerator
// ================
  MooseEnum _material_type;     // material type option
// ========================================================
// flags to indicate the involvement of terms and equations
// ========================================================
  bool _has_scaled_properties;  // flag to indicate use of scaling factors
  bool _has_gravity;            // flag indicating use of grav body force

// =====================
// user-input parameters
// =====================
  Real _rho0_f; // Initial fluid density, kg/m**3
  Real _rho0_s; // Initial solid density, kg/m**3
  Real _phi0;   // Initial porosity, frac
  Real _g;      // Gravitational acceleration, m/s**2
  Real _scaling_factor0;    // Initial scaling factor for lower dimensional element, m
  Function * _function_scaling; // Function updating scaling factor
  Real _alpha_T_f; // Fluid volumetric thermal expansion coefficient, 1/K
  Real _alpha_T_s; // Solid volumetric thermal expansion coefficient, 1/K

// =====================
// Function Defined Variables
// =====================
  const GamusinoFluidDensity * _fluid_density_uo;
  const GamusinoFluidViscosity * _fluid_viscosity_uo;
  const GamusinoPermeability * _permeability_uo;
  const GamusinoPorosity * _porosity_uo;
  const GamusinoScaling * _scaling_uo;

// =====================
// Material Properties
// =====================
  MaterialProperty<Real> & _scaling_factor;
  MaterialProperty<Real> & _porosity;
  MaterialProperty<Real> & _fluid_density;
  MaterialProperty<Real> & _bulk_density;
  MaterialProperty<Real> & _fluid_viscosity;
  RealVectorValue _gravity;
  RankTwoTensor _rotation_matrix;
};

#endif // GAMUSINOMATERIALBASE_H
