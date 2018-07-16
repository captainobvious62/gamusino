#ifndef GAMUSINOHARDENINGCUBIC_H
#define GAMUSINOHARDENINGCUBIC_H

#include "GamusinoHardeningModel.h"

class GamusinoHardeningCubic;

template <>
InputParameters validParams<GamusinoHardeningCubic>();

class GamusinoHardeningCubic : public GamusinoHardeningModel
{
public:
  GamusinoHardeningCubic(const InputParameters & parameters);
  Real value(Real intnl) const;
  Real dvalue(Real intnl) const;
  virtual std::string modelName() const { return "Cubic"; }

private:
  Real _val_ini;
  Real _val_res;
  Real _intnl_0;
  Real _intnl_lim;
  Real _alpha;
  Real _beta;
};

#endif // GAMUSINOHARDENINGCUBIC_H
