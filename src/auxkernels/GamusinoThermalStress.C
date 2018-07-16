#include "GamusinoThermalStress.h"

template <>
InputParameters
validParams<GamusinoThermalStress>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("temperature", "The temperature");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index", "index >= 0 & index <= 2", "The index i of ij for the tensor to output (0, 1, 2).");
  return params;
}

GamusinoThermalStress::GamusinoThermalStress(const InputParameters & parameters)
  : AuxKernel(parameters),
    _temp(coupledValue("temperature")),
    _i(getParam<unsigned int>("index")),
    _TM_jacobian(getMaterialProperty<RankTwoTensor>("TM_jacobian"))
{
  if (!_c_fe_problem.isTransient())
    mooseError("You cannot use GamusinoThermalStress in Steady simulations!");
  else
    _temp_old = &coupledValueOld("temperature");
}

Real
GamusinoThermalStress::computeValue()
{
  RankTwoTensor dstressT = _TM_jacobian[_qp] * (_temp[_qp] - (*_temp_old)[_qp]);
  return _u_old[_qp] + dstressT(_i, _i);
}
