#ifndef GAMUSINOHEATFLOWBC_H
#define GAMUSINOHEATFLOWBC_H

#include "NeumannBC.h"

class GamusinoHeatFlowBC;
class Function;
class GamusinoScaling;

template <>
InputParameters validParams<GamusinoHeatFlowBC>();

class GamusinoHeatFlowBC : public NeumannBC
{
public:
  GamusinoHeatFlowBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  bool _has_scaled_properties;
  Function * _function;

private:
  const GamusinoScaling * _scaling_uo;
  Real _scaled_value;
};

#endif // GAMUSINOHEATFLOWBC_H
