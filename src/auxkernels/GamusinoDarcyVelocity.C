#include "GamusinoDarcyVelocity.h"
#include "RankTwoTensor.h"

template <>
InputParameters
validParams<GamusinoDarcyVelocity>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addRequiredCoupledVar("pore_pressure", "The pore pressure variable.");
  params.addRequiredParam<int>("component", "The darcy velocity component.");
  return params;
}

/*******************************************************************************
Routine: GamusinoDarcyVelocity -- constructor
*******************************************************************************/
GamusinoDarcyVelocity::GamusinoDarcyVelocity(const InputParameters & parameters)
  : AuxKernel(parameters),
    _grad_pf(coupledGradient("pore_pressure")),
    _H_kernel(getMaterialProperty<RankTwoTensor>("H_kernel")),
    _H_kernel_grav(getMaterialProperty<RealVectorValue>("H_kernel_grav")),
    _component(getParam<int>("component"))
{
}

/*******************************************************************************
Routine: computeValue
*******************************************************************************/
Real
GamusinoDarcyVelocity::computeValue()
{
  RealVectorValue dv = -_H_kernel[_qp] * (_grad_pf[_qp] + _H_kernel_grav[_qp]);
  return dv(_component);
}
