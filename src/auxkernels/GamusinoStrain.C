#include "GamusinoStrain.h"

template <>
InputParameters
validParams<GamusinoStrain>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addClassDescription(
      "Access a component of the strain (total, inelastic or plastic) tensor.");
  params.addParam<MooseEnum>("strain_type",
                             GamusinoStrain::strainType() = "total",
                             "The component of the strain tensor to output.");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_i",
      "index_i >= 0 & index_i <= 2",
      "The index i of ij for the stress tensor (0, 1, 2)");
  params.addRequiredRangeCheckedParam<unsigned int>(
      "index_j",
      "index_j >= 0 & index_j <= 2",
      "The index j of ij for the stress tensor (0, 1, 2)");
  return params;
}

GamusinoStrain::GamusinoStrain(const InputParameters & parameters)
  : AuxKernel(parameters),
    _strain_type(getParam<MooseEnum>("strain_type")),
    _i(getParam<unsigned int>("index_i")),
    _j(getParam<unsigned int>("index_j"))
{
  switch (_strain_type)
  {
    case 1:
      _strain = &getMaterialProperty<RankTwoTensor>("mechanical_strain");
      break;
    case 2:
      _strain = &getMaterialProperty<RankTwoTensor>("inelastic_strain");
      break;
    case 3:
      _strain = &getMaterialProperty<RankTwoTensor>("plastic_strain");
      break;
  }
}

MooseEnum
GamusinoStrain::strainType()
{
  return MooseEnum("total=1 inelastic=2 plastic=3");
}

Real
GamusinoStrain::computeValue()
{
  return (*_strain)[_qp](_i, _j);
}
