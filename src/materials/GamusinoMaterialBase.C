 #include "GamusinoMaterialBase.h"
#include "MooseMesh.h"
#include <cfloat>

#define PI 3.141592653589793238462643383279502884197169399375105820974944592308

template <>
InputParameters
validParams<GamusinoMaterialBase>()
{
  InputParameters params = validParams<Material>();
  params.addParam<MooseEnum>("material_type",
                             GamusinoMaterialBase::materialType() = "unit",
                             "The type of the geological material [unit, frac, well].");

  params.addParam<bool>("has_gravity",
                        false,
                        "Is gravity on?");

  params.addParam<Real>("fluid_density_initial",
                        0.0,
                        "The initial density of the fluid [kg/m^3].");

  params.addParam<Real>("solid_density_initial",
                        0.0,
                        "The initial density of the solid matrix [kg/m^3].");

  params.addParam<Real>("porosity_initial",
                        0.0,
                        "The initial porosity [frac].");

  params.addParam<Real>("gravity_acceleration",
                        9.81,
                        "The magnitude of the gravity acceleration [m/s^2].");

  params.addParam<Real>("scaling_factor_initial",
                        1.0,
                        "The scaling factor for lower dimensional element [m].");

  params.addParam<FunctionName>("function_scaling",
                                "The name of the function for updating the scaling_factor.");

  params.addParam<Real>("fluid_thermal_expansion",
                        0.0,
                        "The volumetric thermal expansion coefficient of the fluid [1/K].");

  params.addParam<Real>("solid_thermal_expansion",
                        0.0,
                        "The volumetric thermal expansion coefficient of the solid [1/K].");


  params.addParam<UserObjectName>("scaling_uo",
                                  "The name of the scaling user object.");

  params.addRequiredParam<UserObjectName>("porosity_uo",
                                          "The name of the porosity user object.");

  params.addClassDescription("This is the base class for all Gamusino material properties. It needs "
                             "to be inherited by all other classes.");
  return params;
}

/*******************************************************************************
Routine: GamusinoMaterialBase -- constructor
*******************************************************************************/

GamusinoMaterialBase::GamusinoMaterialBase(const InputParameters & parameters)
  : Material(parameters),
  _material_type(getParam<MooseEnum>("material_type")),

  // ========================================================
  // flags to indicate the involvement of terms and equations
  // ========================================================
    _has_scaled_properties(isParamValid("scaling_uo")),
    _has_gravity(getParam<bool>("has_gravity")),

  // =====================
  // user-input parameters
  // =====================
    _rho0_f(getParam<Real>("fluid_density_initial")),
    _rho0_s(getParam<Real>("solid_density_initial")),
    _phi0(getParam<Real>("porosity_initial")),
    _g(getParam<Real>("gravity_acceleration")),
    _scaling_factor0(getParam<Real>("scaling_factor_initial")),
    _function_scaling(isParamValid("function_scaling") ? &getFunction("function_scaling") : NULL),
    _alpha_T_f(getParam<Real>("fluid_thermal_expansion")),
    _alpha_T_s(getParam<Real>("solid_thermal_expansion")),

  // =====================
  // user objects
  // =====================

    _fluid_density_uo(NULL),
    _fluid_viscosity_uo(NULL),
    _permeability_uo(NULL),
    _porosity_uo(&getUserObject<GamusinoPorosity>("porosity_uo")),
    _scaling_uo(_has_scaled_properties ? &getUserObject<GamusinoScaling>("scaling_uo") : NULL),

  // ===================
  // material properties
  // ===================
    _scaling_factor(declareProperty<Real>("scaling_factor")),
    _porosity(declareProperty<Real>("porosity")),
    _fluid_density(declareProperty<Real>("fluid_density")),
    _fluid_viscosity(declareProperty<Real>("fluid_viscosity"))
    _bulk_density(declareProperty<real>("bulk_density"))
{
  if (_has_scaled_properties)
  {
    _g /= _scaling_uo->_s_acceleration;
    _rho0_s /= _scaling_uo->_s_density;
    _rho0_f /= _scaling_uo->_s_density;
    _alpha_T_s /= _scaling_uo->_s_expansivity;
    _alpha_T_f /= _scaling_uo->_s_expansivity;
    _scaling_factor0 /= _scaling_uo->_s_length;
  }

// ===================
// body forces
// ===================
  computeGravity();
}

/*******************************************************************************
Routine: initQpStatefulProperties -- called only when stateful props are used
*******************************************************************************/
void
GamusinoMaterialBase::initQpStatefulProperties()
{
  _porosity[_qp] = _phi0;
}

/*******************************************************************************
Routine: computeQpScaling -- self-explanatory
*******************************************************************************/
Real
GamusinoMaterialBase::computeQpScaling()
{
  Real scaling_factor = 0.0;
  switch (_material_type)
  {
    case 1:
      scaling_factor += PI * _scaling_factor0 * _scaling_factor0;
      break;
    case 2:
    case 3:
      scaling_factor += _scaling_factor0;
      break;
  }
  if (isParamValid("function_scaling"))
  {
    scaling_factor = _function_scaling->value(_t, Point());
    if (_has_scaled_properties)
      scaling_factor /= _scaling_uo->_s_length;
  }
  return scaling_factor;
}

/*******************************************************************************
Routine: computeGravity -- self-explanatory
*******************************************************************************/
void
GamusinoMaterialBase::computeGravity()
{
  if (_has_gravity)
  {
    if (_mesh.dimension() == 3)
      _gravity = RealVectorValue(0., 0., -_g);
    else if (_mesh.dimension() == 2)
      _gravity = RealVectorValue(0., -_g, 0.);
    else if (_mesh.dimension() == 1)
      _gravity = RealVectorValue(-_g, 0., 0.);
  }
  else
    _gravity = RealVectorValue(0., 0., 0.);
}

/*******************************************************************************
Routine: computeRotationMatrix -- self-explanatory
*******************************************************************************/
void
GamusinoMaterialBase::computeRotationMatrix()
{
  RealVectorValue xp, yp, zp;
  xp = _current_elem->point(1) - _current_elem->point(0);
  switch (_material_type)
  {
    case 1:
      for (unsigned int i = 0; i < 3; ++i)
        yp(i) = 0.0;
      if (std::fabs(xp(0)) > 0.0 && std::fabs(xp(1)) + std::fabs(xp(2)) < DBL_MIN)
        yp(2) = 1.0;
      else if (std::fabs(xp(1)) > 0.0 && std::fabs(xp(0)) + std::fabs(xp(2)) < DBL_MIN)
        yp(0) = 1.0;
      else if (std::fabs(xp(2)) > 0.0 && std::fabs(xp(0)) + std::fabs(xp(1)) < DBL_MIN)
        yp(1) = 1.0;
      else
      {
        for (unsigned int i = 0; i < 3; ++i)
          if (std::fabs(xp(i)) > 0.0)
          {
            yp(i) = -xp(i);
            break;
          }
      }
      break;
    case 2:
      yp = _current_elem->point(2) - _current_elem->point(1);
      break;
    case 3:
      break;
  }
  zp = xp.cross(yp);
  yp = zp.cross(xp);
  for (unsigned int i = 0; i < 3; ++i)
  {
    (_rotation_matrix)(i, 0) = xp(i) / xp.norm();
    (_rotation_matrix)(i, 1) = yp(i) / yp.norm();
    (_rotation_matrix)(i, 2) = zp(i) / zp.norm();
  }
}

/*******************************************************************************
Routine: materialType -- designate material type
*******************************************************************************/
MooseEnum
GamusinoMaterialBase::materialType()
{
  return MooseEnum("well=1 frac=2 unit=3");
}
