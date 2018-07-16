#include "GamusinoKernelHPoroElastic.h"
#include "MooseMesh.h"

template <>
InputParameters
validParams<GamusinoKernelHPoroElastic>()
{
  InputParameters params = validParams<Kernel>();
  params.addRequiredCoupledVar("displacements", "The displacement variables vector.");
  return params;
}

GamusinoKernelHPoroElastic::GamusinoKernelHPoroElastic(const InputParameters & parameters)
  : Kernel(parameters),
    _ndisp(coupledComponents("displacements")),
    _disp_var(_ndisp),
    _biot(getMaterialProperty<Real>("biot_coefficient")),
    _vol_strain_rate(getMaterialProperty<Real>("volumetric_strain_rate"))
{
  if (_ndisp != _mesh.dimension())
    mooseError("The number of displacement variables supplied must match the mesh dimension.");
  for (unsigned int i = 0; i < _ndisp; ++i)
    _disp_var[i] = coupled("displacements", i);
}

/******************************************************************************/
/*                                RESIDUAL                                    */
/******************************************************************************/
Real
GamusinoKernelHPoroElastic::computeQpResidual()
{
  return _biot[_qp] * _vol_strain_rate[_qp] * _test[_i][_qp];
}

/******************************************************************************/
/*                                  JACOBIAN                                  */
/******************************************************************************/
Real
GamusinoKernelHPoroElastic::computeQpJacobian()
{
  return 0.0;
}

/******************************************************************************/
/*                            OFF DIAGONAL JACOBIAN                           */
/******************************************************************************/
Real
GamusinoKernelHPoroElastic::computeQpOffDiagJacobian(unsigned int jvar)
{
  for (unsigned int i = 0; i < _ndisp; ++i)
    if (jvar == _disp_var[i])
      return _biot[_qp] * _grad_phi[_j][_qp](i) * _test[_i][_qp] / _dt;
  return 0.0;
}
