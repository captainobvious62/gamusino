#include "GamusinoPressureBC.h"
#include "Function.h"
#include "GamusinoScaling.h"

template <>
InputParameters
validParams<GamusinoPressureBC>()
{
  InputParameters params = validParams<NeumannBC>();
  params.addClassDescription("Applies a pressure on a given boundary in a given direction.");
  params.addRequiredParam<unsigned int>("component", "The component for the pressure.");
  params.addParam<FunctionName>("function", "The function that describes the pressure.");
  params.addParam<UserObjectName>("scaling_uo", "The name of the scaling user object.");
  params.set<bool>("use_displaced_mesh") = true;
  return params;
}

GamusinoPressureBC::GamusinoPressureBC(const InputParameters & parameters)
  : NeumannBC(parameters),
    _has_scaled_properties(isParamValid("scaling_uo") ? true : false),
    _component(getParam<unsigned int>("component")),
    _function(isParamValid("function") ? &getFunction("function") : NULL),
    _scaling_uo(_has_scaled_properties ? &getUserObject<GamusinoScaling>("scaling_uo") : NULL)
{
  if (_component > 2)
    mooseError("Invalid component given GamusinoPressureBC: ", _component, ".\n");
}

Real
GamusinoPressureBC::computeQpResidual()
{
  if (_has_scaled_properties)
  {
    if (isParamValid("function"))
      _scaled_value = _function->value(_t, Point()) / _scaling_uo->_s_stress;
    else
      _scaled_value = _value / _scaling_uo->_s_stress;
  }
  else
  {
    if (isParamValid("function"))
      _scaled_value = _function->value(_t, Point());
    else
      _scaled_value = _value;
  }
  return _scaled_value * (_normals[_qp](_component) * _test[_i][_qp]);
}

Real
GamusinoPressureBC::computeQpJacobian()
{
  return 0.0;
}
