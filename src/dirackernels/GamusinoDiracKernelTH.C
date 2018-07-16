#include "GamusinoDiracKernelTH.h"
#include "Function.h"
#include "GamusinoScaling.h"

template <>
InputParameters
validParams<GamusinoDiracKernelTH>()
{
  InputParameters params = validParams<DiracKernel>();
  params.addParam<Point>("source_point", "The source point location (x, y, z).");
  params.addParam<MooseEnum>(
      "source_type", GamusinoDiracKernelTH::Type() = "injection", "The source type.");
  params.addParam<Real>("in_out_rate", 0.0, "The injection/extraction rate.");
  params.addParam<FunctionName>("function", "The function describing the in_out_rate.");
  params.addParam<Real>("start_time", 0.0, "The starting time.");
  params.addParam<Real>("end_time", 0.0, "The ending time.");
  params.addParam<UserObjectName>("scaling_uo", "The name of the scaling user object.");
  return params;
}

GamusinoDiracKernelTH::GamusinoDiracKernelTH(const InputParameters & parameters)
  : DiracKernel(parameters),
    _has_scaled_properties(isParamValid("scaling_uo") ? true : false),
    _source_point(parameters.get<Point>("source_point")),
    _source_type(getParam<MooseEnum>("source_type")),
    _in_out_rate(getParam<Real>("in_out_rate")),
    _function(isParamValid("function") ? &getFunction("function") : NULL),
    _start_time(getParam<Real>("start_time")),
    _end_time(getParam<Real>("end_time")),
    _scaling_factor(getMaterialProperty<Real>("scaling_factor")),
    _fluid_density(getMaterialProperty<Real>("fluid_density")),
    _scaling_uo(_has_scaled_properties ? &getUserObject<GamusinoScaling>("scaling_uo") : NULL)
{
  if (_has_scaled_properties)
    _scale = _scaling_uo->_s_time / _scaling_uo->_s_mass;
  else
    _scale = 1.0;
  if (_start_time > _end_time)
    mooseError("GamusinoDiracKernelTH: start_time could not be bigger than end_time!");
  if (_start_time == 0.0 && _end_time == 0.0)
    mooseWarning("Trying to set a Dirac kernel object on start_time == end_time == 0!");
}

void
GamusinoDiracKernelTH::addPoints()
{
  addPoint(_source_point);
}

MooseEnum
GamusinoDiracKernelTH::Type()
{
  return MooseEnum("injection=1 extraction=2");
}

Real
GamusinoDiracKernelTH::computeQpResidual()
{
  Real pre_factor = 1.0 / _fluid_density[_qp];
  if (_source_type == 1)
    pre_factor *= -1;
  if (isParamValid("function"))
    return _scale * pre_factor * _scaling_factor[_qp] * _function->value(_t, Point()) *
           _test[_i][_qp];
  else
  {
    if (_t < _start_time || _t - _dt >= _end_time)
      pre_factor = 0.0;
    else if (_t - _dt < _start_time)
    {
      if (_t <= _end_time)
        pre_factor *= (_t - _start_time) / _dt;
      else
        pre_factor *= (_end_time - _start_time) / _dt;
    }
    else if (_t > _end_time)
      pre_factor *= (_end_time - (_t - _dt)) / _dt;
    return _scale * pre_factor * _scaling_factor[_qp] * _in_out_rate * _test[_i][_qp];
  }
}

Real
GamusinoDiracKernelTH::computeQpJacobian()
{
  return 0.0;
}
