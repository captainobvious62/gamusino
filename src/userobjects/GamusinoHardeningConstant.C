
#include "GamusinoHardeningConstant.h"
#include "libmesh/utility.h"
#include <math.h>

template <>
InputParameters
validParams<GamusinoHardeningConstant>()
{
  InputParameters params = validParams<GamusinoHardeningModel>();
  params.addParam<Real>(
      "value", 1.0, "The value of the parameter (it is valid for all internal parameters).");
  params.addClassDescription("No hardening model.");
  return params;
}

GamusinoHardeningConstant::GamusinoHardeningConstant(const InputParameters & parameters)
  : GamusinoHardeningModel(parameters),
    _value(_is_radians ? getParam<Real>("value") * libMesh::pi / 180.0 : getParam<Real>("value"))
{
}

Real GamusinoHardeningConstant::value(Real) const { return _value; }

Real GamusinoHardeningConstant::dvalue(Real) const { return 0.0; }
