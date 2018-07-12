#include "GamusinoFluidViscosityLinear.h"

template <>
InputParameters
validParams<GamusinoFluidViscosityLinear>()
{
  InputParameters params = validParams<GamusinoFluidViscosity>();
  params.addClassDescription("Linear polynomial fitting for fluid viscosity");
  params.addRequiredParam<Real>("Tc", "The first thermal coefficient");
  params.addRequiredParam<Real>("Tv", "The second thermal coefficient");
  return params;
}

GamusinoFluidViscosityLinear::GamusinoFluidViscosityLinear(const InputParameters & parameters)
  : GamusinoFluidViscosity(parameters), _Tc(getParam<Real>("Tc")), _Tv(getParam<Real>("Tv"))
{
}

Real
GamusinoFluidViscosityLinear::computeViscosity(Real temperature, Real, Real mu0) const
{
  Real Tc = _Tc;
  Real Tv = _Tv;
  if (_has_scaled_properties)
  {
    Tc /= _scaling_uo->_s_temperature;
    Tv /= _scaling_uo->_s_temperature;
  }
  return mu0 * std::exp(-(temperature - Tc) / Tv);
}

Real
GamusinoFluidViscosityLinear::computedViscositydT(Real temperature, Real, Real, Real mu0) const
{
  Real Tc = _Tc;
  Real Tv = _Tv;
  if (_has_scaled_properties)
  {
    Tc /= _scaling_uo->_s_temperature;
    Tv /= _scaling_uo->_s_temperature;
  }
  return (-1.0 / Tv) * GamusinoFluidViscosityLinear::computeViscosity(
                           temperature, 0.0, mu0); // mu0 * std::exp(-(temperature - Tc) / Tv);
}

Real GamusinoFluidViscosityLinear::computedViscositydp(Real, Real, Real) const { return 0.0; }
