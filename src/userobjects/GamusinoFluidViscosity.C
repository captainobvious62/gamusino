
#include "GamusinoFluidViscosity.h"

template <>
InputParameters
validParams<GamusinoFluidViscosity>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription(
      "Gamusino Fluid Viscosity base class. Override the virtual functions in your class.");
  params.addParam<UserObjectName>("scaling_uo", "The name of the scaling user object.");
  return params;
}

GamusinoFluidViscosity::GamusinoFluidViscosity(const InputParameters & parameters)
  : GeneralUserObject(parameters),
    _has_scaled_properties(isParamValid("scaling_uo")),
    _scaling_uo(_has_scaled_properties ? &getUserObject<GamusinoScaling>("scaling_uo") : NULL)
{
}
