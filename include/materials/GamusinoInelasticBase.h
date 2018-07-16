#ifndef GAMUSINOINELASTICBASE_H
#define GAMUSINOINELASTICBASE_H

#include "Conversion.h"
#include "GamusinoMaterialMElastic.h"

class GamusinoInelasticBase;

template <>
InputParameters validParams<GamusinoInelasticBase>();

class GamusinoInelasticBase : public Material
{
public:
  GamusinoInelasticBase(const InputParameters & parameters);
  virtual void updateStress(RankTwoTensor & strain_increment,
                            RankTwoTensor & inelastic_strain_increment,
                            RankTwoTensor & stress_new,
                            const RankTwoTensor & stress_old,
                            const RankFourTensor & elasticity_tensor,
                            bool compute_full_tangent_operator,
                            RankFourTensor & tangent_operator) = 0;
  void setQp(unsigned int qp);
  void resetQpProperties() final {}
  void resetProperties() final {}
protected:
  const std::string _base_name;
};

#endif // GAMUSINOINELASTICBASE_H
