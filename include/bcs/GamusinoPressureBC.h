#ifndef GAMUSINOPRESSUREBC_H
#define GAMUSINOPRESSUREBC_H

#include "NeumannBC.h"

class GamusinoPressureBC;
class Function;
class GamusinoScaling;

template <>
InputParameters validParams<GamusinoPressureBC>();

class GamusinoPressureBC : public NeumannBC
{
public:
  GamusinoPressureBC(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  bool _has_scaled_properties;
  const int _component;
  Function * _function;

private:
  const GamusinoScaling * _scaling_uo;
  Real _scaled_value;
};

#endif // GAMUSINOPRESSUREBC_H
