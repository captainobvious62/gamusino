
#include "GamusinoHardeningCubic.h"
#include "libmesh/utility.h"

template <>
InputParameters
validParams<GamusinoHardeningCubic>()
{
  InputParameters params = validParams<GamusinoHardeningModel>();
  params.addClassDescription("Cubic hardening class.");
  params.addRequiredParam<Real>(
      "value_initial", "The value of the parameter for all internal_parameter <= internal_0.");
  params.addRequiredParam<Real>(
      "value_residual", "The value of the parameter for internal_parameter >= internal_limit.");
  params.addParam<Real>(
      "internal_0", 0.0, "The value of the internal_parameter when hardening begins.");
  params.addParam<Real>(
      "internal_limit", 1.0, "The value of the internal_parameter when hardening ends.");
  return params;
}

GamusinoHardeningCubic::GamusinoHardeningCubic(const InputParameters & parameters)
  : GamusinoHardeningModel(parameters),
    _val_ini(_is_radians ? getParam<Real>("value_initial") * libMesh::pi / 180.
                         : getParam<Real>("value_initial")),
    _val_res(_is_radians ? getParam<Real>("value_residual") * libMesh::pi / 180.
                         : getParam<Real>("value_residual")),
    _intnl_0(getParam<Real>("internal_0")),
    _intnl_lim(getParam<Real>("internal_limit")),
    _alpha(2 * (_val_ini - _val_res) / Utility::pow<3>(_intnl_lim - _intnl_0)),
    _beta(-3. / 2. * (_val_ini - _val_res) / (_intnl_lim - _intnl_0))
{
  if (_intnl_lim <= _intnl_0)
    mooseError("internal_limit must be greater than internal_0 in GamusinoHardeningCubic model!");
}

Real
GamusinoHardeningCubic::value(Real intnl) const
{
  Real x = intnl - _intnl_0 - 0.5 * (_intnl_lim - _intnl_0);
  if (intnl <= _intnl_0)
    return _val_ini;
  else if (intnl >= _intnl_lim)
    return _val_res;
  else
    return _alpha * Utility::pow<3>(x) + _beta * x + 0.5 * (_val_ini + _val_res);
}

Real
GamusinoHardeningCubic::dvalue(Real intnl) const
{
  Real x = intnl - _intnl_0 - 0.5 * (_intnl_lim - _intnl_0);
  if (intnl <= _intnl_0)
    return 0.0;
  else if (intnl >= _intnl_lim)
    return 0.0;
  else
    return 3 * _alpha * Utility::pow<2>(x) + _beta;
}
