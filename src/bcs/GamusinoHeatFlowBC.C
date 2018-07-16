#include "GamusinoHeatFlowBC.h"
#include "Function.h"
#include "GamusinoScaling.h"

template <>
InputParameters
validParams<GamusinoHeatFlowBC>()
{
  InputParameters params = validParams<NeumannBC>();
  params.addParam<FunctionName>("function", "The function of the heat flow value.");
  params.addParam<UserObjectName>("scaling_uo", "The name of the scaling user object.");
  return params;
}

GamusinoHeatFlowBC::GamusinoHeatFlowBC(const InputParameters & parameters)
  : NeumannBC(parameters),
    _has_scaled_properties(isParamValid("scaling_uo") ? true : false),
    _function(isParamValid("function") ? &getFunction("function") : NULL),
    _scaling_uo(_has_scaled_properties ? &getUserObject<GamusinoScaling>("scaling_uo") : NULL)
{
}

Real
GamusinoHeatFlowBC::computeQpResidual()
{
  if (_has_scaled_properties)
  {
    if (isParamValid("function"))
      _scaled_value = _function->value(_t, Point()) / _scaling_uo->_s_heat_flow;
    else
      _scaled_value = _value / _scaling_uo->_s_heat_flow;
  }
  else
  {
    if (isParamValid("function"))
      _scaled_value = _function->value(_t, Point());
    else
      _scaled_value = _value;
  }

  return -_test[_i][_qp] * _scaled_value;
}
