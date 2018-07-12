
#include "GamusinoHardeningPlasticSaturation.h"
#include "libmesh/utility.h"

template <>
InputParameters
validParams<GamusinoHardeningPlasticSaturation>()
{
  InputParameters params = validParams<GamusinoHardeningModel>();
  params.addClassDescription("Plastic saturation hardening class.");
  params.addRequiredParam<Real>(
      "value_initial", "The value of the parameter for all internal_parameter <= internal_0.");
  params.addRequiredParam<Real>(
      "value_residual", "The value of the parameter for internal_parameter >= internal_limit.");
  params.addParam<Real>(
      "internal_limit", 1.0, "The value of the internal_parameter when hardening saturates.");
  return params;
}

GamusinoHardeningPlasticSaturation::GamusinoHardeningPlasticSaturation(const InputParameters & parameters)
  : GamusinoHardeningModel(parameters),
    _val_ini(_is_radians ? getParam<Real>("value_initial") * libMesh::pi / 180.
                         : getParam<Real>("value_initial")),
    _val_res(_is_radians ? getParam<Real>("value_residual") * libMesh::pi / 180.
                         : getParam<Real>("value_residual")),
    _intnl_lim(getParam<Real>("internal_limit"))
{
  if (_val_ini < 0.0)
    mooseError("GamusinoHardeningPlasticSaturation: _val_ini must be greater than 0.0!");
  if (_intnl_lim <= 0.0)
    mooseError("GamusinoHardeningPlasticSaturation: internal_limit must be greater than 0.0!");
}

Real
GamusinoHardeningPlasticSaturation::value(Real intnl) const
{
  if (intnl <= _intnl_lim)
    return _val_ini +
           (_val_res - _val_ini) * intnl / _intnl_lim *
               (Utility::pow<2>(intnl / _intnl_lim) - 3.0 * intnl / _intnl_lim + 3);
  else
    return _val_res;
}

Real
GamusinoHardeningPlasticSaturation::dvalue(Real intnl) const
{
  if (intnl <= _intnl_lim)
    return 3.0 * (_val_res - _val_ini) / _intnl_lim *
           (Utility::pow<2>(intnl / _intnl_lim) - 2.0 * intnl / _intnl_lim + 1);
  else
    return 0.0;
}
