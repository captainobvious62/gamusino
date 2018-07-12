
#include "GamusinoHardeningModel.h"

template <>
InputParameters
validParams<GamusinoHardeningModel>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription(
      "Hardening based virtual class. Override the virtual functions in your class.");
  params.addParam<bool>("convert_to_radians",
                        false,
                        "If true, the value you entered will be "
                        "multiplied by Pi/180 before passing to the "
                        "Plasticity algorithms.");
  return params;
}

GamusinoHardeningModel::GamusinoHardeningModel(const InputParameters & parameters)
  : GeneralUserObject(parameters), _is_radians(getParam<bool>("convert_to_radians"))
{
}
