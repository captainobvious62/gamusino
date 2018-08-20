#include "GamusinoStress.h"

template <>
InputParameters
validParams<GamusinoStress>()
{
  InputParameters params = validParams<AuxKernel>();
  params.addClassDescription("Access a component of the stress tensor.");
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

/*******************************************************************************
Routine: GamusinoStress -- constructor
*******************************************************************************/
GamusinoStress::GamusinoStress(const InputParameters & parameters)
  : AuxKernel(parameters),
    _stress(getMaterialProperty<RankTwoTensor>("stress")),
    _i(getParam<unsigned int>("index_i")),
    _j(getParam<unsigned int>("index_j"))
{
}

/*******************************************************************************
Routine: computeValue
*******************************************************************************/
Real
GamusinoStress::computeValue()
{
  return _stress[_qp](_i, _j);
}
