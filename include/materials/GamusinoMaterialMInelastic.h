#ifndef GAMUSINOMATERIALMINELASTIC_H
#define GAMUSINOMATERIALMINELASTIC_H

#include "GamusinoMaterialMElastic.h"

class GamusinoInelasticBase;
class GamusinoMaterialMInelastic;

template <>
InputParameters validParams<GamusinoMaterialMInelastic>();

class GamusinoMaterialMInelastic : public GamusinoMaterialMElastic
{
public:
  GamusinoMaterialMInelastic(const InputParameters & parameters);

protected:
  virtual void initQpStatefulProperties();
  virtual void GamusinoStress();
  virtual void updateQpStress(RankTwoTensor & combined_inelastic_strain_increment);
  virtual void updateQpStressSingleModel(RankTwoTensor & combined_inelastic_strain_increment);
  virtual void computeAdmissibleState(unsigned model_number,
                                      RankTwoTensor & elastic_strain_increment,
                                      RankTwoTensor & inelastic_strain_increment,
                                      RankFourTensor & consistent_tangent_operator);
  virtual void computeQpJacobian(const std::vector<RankFourTensor> & consistent_tangent_operator);

  const unsigned int _max_its;
  const Real _relative_tolerance;
  const Real _absolute_tolerance;
  std::vector<GamusinoInelasticBase *> _models;
  MaterialProperty<RankTwoTensor> & _inelastic_strain;
  const MaterialProperty<RankTwoTensor> & _inelastic_strain_old;
  const enum class TangentOperatorEnum { elastic, nonlinear } _tangent_operator_type;
  const unsigned _num_models;
};

#endif // GAMUSINOMATERIALMINELASTIC_H
