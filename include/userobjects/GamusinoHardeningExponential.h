#ifndef GAMUSINOHARDENINGEXPONENTIAL_H
#define GAMUSINOHARDENINGEXPONENTIAL_H

#include "GamusinoHardeningModel.h"

class GamusinoHardeningExponential;

template <>
InputParameters validParams<GamusinoHardeningExponential>();

class GamusinoHardeningExponential : public GamusinoHardeningModel
{
public:
  GamusinoHardeningExponential(const InputParameters & parameters);
  Real value(Real intnl) const;
  Real dvalue(Real intnl) const;
  virtual std::string modelName() const { return "Exponential"; }

private:
  Real _val_ini;
  Real _val_res;
  Real _rate;
};

#endif // GAMUSINOHARDENINGEXPONENTIAL_H
