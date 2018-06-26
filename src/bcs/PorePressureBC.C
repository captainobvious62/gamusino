#include "PorePressureBC.h"

template<>
InputParameters validParams<PorePressureBC>()
{
  InputParameters params = validParams<IntegratedBC>();

  params.addRequiredParam<unsigned int>("component", "an integer corresponding to the direction the variable this kernel acts in, 0 for x, 1 for y, 2, for z");
  params.addRequiredParam<unsigned int>("porepressure", "specified value of pore pressure");

  return params;
}

PorePressureBC::PorePressureBC(const InputParameters &parameters)
  : IntegratedBC(parameters),
    _component(getParam<unsigned int>("component")),
    _specified_pore_pressure(getParam<Real>("porepressure"))
{
}

Real
PorePressureBC::computeQpResidual()
{
  return _test[_i][_qp]*_normals[_qp](_component)*_specified_pore_pressure;
}

Real
PorePressureBC::computeQpJacobian()
{
  return 0.0;
}
