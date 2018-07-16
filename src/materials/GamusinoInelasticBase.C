#include "GamusinoInelasticBase.h"
#include "MooseMesh.h"

template <>
InputParameters
validParams<GamusinoInelasticBase>()
{
  InputParameters params = validParams<Material>();
  params.addClassDescription("Base class for radial return mapping. It should be inherited by the "
                             "differnet constitutive models.");
  params.addParam<std::string>(
      "base_name",
      "Optional parameter that enables to define multiple mechanics material on the same block.");
  params.set<bool>("compute") = false;
  params.suppressParameter<bool>("compute");
  return params;
}

GamusinoInelasticBase::GamusinoInelasticBase(const InputParameters & parameters)
  : Material(parameters),
    _base_name(isParamValid("base_name") ? getParam<std::string>("base_name") + "_" : "")
{
}

void
GamusinoInelasticBase::setQp(unsigned int qp)
{
  _qp = qp;
}
