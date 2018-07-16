
#ifndef GAMUSINOHARDENINGCONSTANT_H
#define GAMUSINOHARDENINGCONSTANT_H

#include "GamusinoHardeningModel.h"

class GamusinoHardeningConstant;

template <>
InputParameters validParams<GamusinoHardeningConstant>();

class GamusinoHardeningConstant : public GamusinoHardeningModel
{
public:
  GamusinoHardeningConstant(const InputParameters & parameters);
  Real value(Real intnl) const;
  Real dvalue(Real intnl) const;
  virtual std::string modelName() const { return "Constant"; }
private:
  Real _value;
};

#endif // GAMUSINOHARDENINGCONSTANT_H
