#include "GamusinoEqvInelasticStrain.h"

template <>
InputParameters
validParams<GamusinoEqvInelasticStrain>()
{
  InputParameters params = validParams<AuxKernel>();
  return params;
}

GamusinoEqvInelasticStrain::GamusinoEqvInelasticStrain(const InputParameters & parameters)
  : AuxKernel(parameters),
    _inelastic_strain(getMaterialProperty<RankTwoTensor>("inelastic_strain")),
    _inelastic_strain_old(getMaterialPropertyOld<RankTwoTensor>("inelastic_strain"))
{
}

Real
GamusinoEqvInelasticStrain::computeValue()
{
  RankTwoTensor inelastic_strain_increment = _inelastic_strain[_qp] - _inelastic_strain_old[_qp];
  return _u_old[_qp] + std::sqrt(2.0 / 3.0) * inelastic_strain_increment.L2norm();
}
