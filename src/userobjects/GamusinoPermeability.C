
#include "GamusinoPermeability.h"

template <>
InputParameters
validParams<GamusinoPermeability>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription(
      "Gamusino Permeability base class. Override the virtual functions in your class.");
  return params;
}

GamusinoPermeability::GamusinoPermeability(const InputParameters & parameters)
  : GeneralUserObject(parameters)
{
}
