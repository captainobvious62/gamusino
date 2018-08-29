
#include "GamusinoInertialForce.h"
#include "SubProblem.h"

//registerMooseObject("TensorMechanicsApp", InertialForce);

template <>
InputParameters
validParams<GamusinoInertialForce>()
{
  InputParameters params = validParams<Kernel>();
  params.addClassDescription("Calculates the residual for the inertial force "
                             "($M \\cdot acceleration$) and the contribution of mass"
                             " dependent Rayleigh damping and HHT time "
                             " integration scheme ($\\eta \\cdot M \\cdot"
                             " ((1+\\alpha)velq2-\\alpha \\cdot vel-old) )");
  params.set<bool>("use_displaced_mesh") = true;
  params.addRequiredCoupledVar("velocity", "velocity variable");
  params.addRequiredCoupledVar("acceleration", "acceleration variable");
  params.addRequiredParam<Real>("beta", "beta parameter for Newmark Time integration");
  params.addRequiredParam<Real>("gamma", "gamma parameter for Newmark Time integration");
  params.addParam<MaterialPropertyName>("eta",
                                        0.0,
                                        "Name of material property or a constant real "
                                        "number defining the eta parameter for the "
                                        "Rayleigh damping.");
  params.addParam<Real>("alpha",
                        0,
                        "alpha parameter for mass dependent numerical damping induced "
                        "by HHT time integration scheme");
  params.addParam<MaterialPropertyName>(
      "bulk_density", "bulk_density", "Name of Material Property that provides the bulk_density");
  return params;
}

/*******************************************************************************
Routine: GamusinoInertialForce -- Constructor
*******************************************************************************/
GamusinoInertialForce::GamusinoInertialForce(const InputParameters & parameters)
  : Kernel(parameters),
    _bulk_density(getMaterialProperty<Real>("bulk_density")),
    _u_old(valueOld()),
    _vel_old(coupledValueOld("velocity")),
    _accel_old(coupledValueOld("acceleration")),
    _beta(getParam<Real>("beta")),
    _gamma(getParam<Real>("gamma")),
    _eta(getMaterialProperty<Real>("eta")),
    _alpha(getParam<Real>("alpha"))
{
}

/*******************************************************************************
Routine: computeQpResidual
*******************************************************************************/
Real
GamusinoInertialForce::computeQpResidual()
{
  if (_dt == 0)
    return 0;
  else
  {
    Real accel = 1. / _beta * (((_u[_qp] - _u_old[_qp]) / (_dt * _dt)) - _vel_old[_qp] / _dt -
                               _accel_old[_qp] * (0.5 - _beta));
    Real vel = _vel_old[_qp] + (_dt * (1 - _gamma)) * _accel_old[_qp] + _gamma * _dt * accel;
    return _test[_i][_qp] * _bulk_density[_qp] *
           (accel + vel * _eta[_qp] * (1 + _alpha) - _alpha * _eta[_qp] * _vel_old[_qp]);
  }
}

/*******************************************************************************
Routine: computeQpJacobian
*******************************************************************************/
Real
GamusinoInertialForce::computeQpJacobian()
{
  if (_dt == 0)
    return 0;
  else
    return _test[_i][_qp] * _bulk_density[_qp] / (_beta * _dt * _dt) * _phi[_j][_qp] +
           _eta[_qp] * (1 + _alpha) * _test[_i][_qp] * _bulk_density[_qp] * _gamma / _beta / _dt *
               _phi[_j][_qp];
}
