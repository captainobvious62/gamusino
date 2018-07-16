#ifndef GAMUSINOMATERIALT_H
#define GAMUSINOMATERIALT_H

#include "GamusinoMaterialBase.h"

class GamusinoMaterialT;

template <>
InputParameters validParams<GamusinoMaterialT>();

class GamusinoMaterialT : public GamusinoMaterialBase
{
public:
  GamusinoMaterialT(const InputParameters & parameters);

protected:
  virtual void computeQpProperties();

  bool _has_T_source_sink;
  Real _lambda_f;
  Real _lambda_s;
  Real _c_f;
  Real _c_s;
  Real _T_source_sink;
  MaterialProperty<Real> & _T_kernel_diff;
  MaterialProperty<Real> * _T_kernel_source;
  MaterialProperty<Real> * _T_kernel_time;
};

#endif // GAMUSINOMATERIALT_H
