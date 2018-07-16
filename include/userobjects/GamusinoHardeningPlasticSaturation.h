#ifndef GAMUSINOHARDENINGPLASTICSATURATION_H
#define GAMUSINOHARDENINGPLASTICSATURATION_H

#include "GamusinoHardeningModel.h"

class GamusinoHardeningPlasticSaturation;

template <>
InputParameters validParams<GamusinoHardeningPlasticSaturation>();

class GamusinoHardeningPlasticSaturation : public GamusinoHardeningModel
{
public:
  GamusinoHardeningPlasticSaturation(const InputParameters & parameters);
  Real value(Real intnl) const;
  Real dvalue(Real intnl) const;
  virtual std::string modelName() const { return "Plastic Saturation"; }

private:
  Real _val_ini;
  Real _val_res;
  Real _intnl_lim;
};

#endif // GAMUSINOHARDENINGPLASTICSATURATION_H
