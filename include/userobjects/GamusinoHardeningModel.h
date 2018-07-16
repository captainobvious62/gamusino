#ifndef GAMUSINOHARDENINGMODEL_H
#define GAMUSINOHARDENINGMODEL_H

#include "GeneralUserObject.h"

class GamusinoHardeningModel;

template <>
InputParameters validParams<GamusinoHardeningModel>();

class GamusinoHardeningModel : public GeneralUserObject
{
public:
  GamusinoHardeningModel(const InputParameters & parameters);
  void initialize() {}
  void execute() {}
  void finalize() {}
  virtual Real value(Real intnl) const = 0;
  virtual Real dvalue(Real intnl) const = 0;
  virtual std::string modelName() const = 0;

protected:
  bool _is_radians;
};

#endif // GAMUSINOHARDENINGMODEL_H
