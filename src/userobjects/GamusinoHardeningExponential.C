
#include "GamusinoHardeningExponential.h"

template <>
InputParameters
validParams<GamusinoHardeningExponential>()
{
  InputParameters params = validParams<GamusinoHardeningModel>();
  params.addRequiredParam<Real>("value_initial",
                                "The value of the parameter at internal_parameter = 0.");
  params.addRequiredParam<Real>("value_residual",
                                "The value of the parameter at internal_parameter = infinity.");
  params.addParam<Real>("rate", 0, "The rate parameter for the exponential function.");
  params.addClassDescription("Exponential hardening model.");
  return params;
}

GamusinoHardeningExponential::GamusinoHardeningExponential(const InputParameters & parameters)
  : GamusinoHardeningModel(parameters),
    _val_ini(_is_radians ? getParam<Real>("value_initial") * libMesh::pi / 180.
                         : getParam<Real>("value_initial")),
    _val_res(_is_radians ? getParam<Real>("value_residual") * libMesh::pi / 180.
                         : getParam<Real>("value_residual")),
    _rate(getParam<Real>("rate"))
{
}

Real
GamusinoHardeningExponential::value(Real intnl) const
{
  return _val_res + (_val_ini - _val_res) * std::exp(-_rate * intnl);
}

Real
GamusinoHardeningExponential::dvalue(Real intnl) const
{
  return -_rate * (_val_ini - _val_res) * std::exp(-_rate * intnl);
}
