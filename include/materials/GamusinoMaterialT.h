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
  Real _lambda_f;   // Initial fluid thermal conductivity, W/m/K
  Real _lambda_s;   // Initial solid thermal conductivity, W/m/K
  Real _c_f;    // Initial fluid heat capacity, J/m**3/K
  Real _c_s;    // Initial solid heat capacity, J/m**3/K
  Real _T_source_sink;  // Heat source/sink, W/m**3
  MaterialProperty<Real> & _T_kernel_diff;
  MaterialProperty<Real> * _T_kernel_source;
  MaterialProperty<Real> * _T_kernel_time;
};

#endif // GAMUSINOMATERIALT_H
