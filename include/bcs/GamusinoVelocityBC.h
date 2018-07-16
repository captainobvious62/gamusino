#ifndef GAMUSINOVELOCITYBC_H
#define GAMUSINOVELOCITYBC_H

#include "PresetNodalBC.h"

class GamusinoVelocityBC;

template <>
InputParameters validParams<GamusinoVelocityBC>();

class GamusinoVelocityBC : public PresetNodalBC
{
public:
  GamusinoVelocityBC(const InputParameters & parameters);

protected:
  virtual Real computeQpValue();

  const VariableValue & _u_old;
  const Real & _velocity;
};

#endif // GAMUSINOVELOCITYBC_H
