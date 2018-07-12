
#include "GamusinoPorosity.h"

template <>
InputParameters
validParams<GamusinoPorosity>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription(
      "Gamusino Porosity base class. Override the virtual functions in your class.");
  return params;
}

GamusinoPorosity::GamusinoPorosity(const InputParameters & parameters) : GeneralUserObject(parameters) {}
