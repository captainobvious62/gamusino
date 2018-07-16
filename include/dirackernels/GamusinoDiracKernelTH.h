#ifndef GAMUSINODIRACKERNELTH_H
#define GAMUSINODIRACKERNELTH_H

#include "DiracKernel.h"

class GamusinoDiracKernelTH;
class Function;
class GamusinoScaling;

template <>
InputParameters validParams<GamusinoDiracKernelTH>();

class GamusinoDiracKernelTH : public DiracKernel
{
public:
  GamusinoDiracKernelTH(const InputParameters & parameters);
  static MooseEnum Type();
  virtual void addPoints();

protected:
  virtual Real computeQpResidual();
  virtual Real computeQpJacobian();
  bool _has_scaled_properties;
  Point _source_point;
  MooseEnum _source_type;
  Real _in_out_rate;
  Function * _function;
  Real _start_time;
  Real _end_time;
  const MaterialProperty<Real> & _scaling_factor;
  const MaterialProperty<Real> & _fluid_density;

private:
  const GamusinoScaling * _scaling_uo;
  Real _scale;
};

#endif // GAMUSINODIRACKERNELTH_H
