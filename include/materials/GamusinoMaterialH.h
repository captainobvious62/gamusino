#ifndef GAMUSINOMATERIALH_H
#define GAMUSINOMATERIALH_H

#include "GamusinoMaterialBase.h"
#include "RankTwoTensor.h"

class GamusinoMaterialH;

template <>
InputParameters validParams<GamusinoMaterialH>();

class GamusinoMaterialH : public GamusinoMaterialBase
{
public:
  GamusinoMaterialH(const InputParameters & parameters);
  static MooseEnum permeabilityType();

protected:
  virtual void computeProperties();
  virtual void computeQpProperties();
  virtual void GamusinoPropertiesH();

  bool _has_disp;
  MooseEnum _permeability_type;
  std::vector<Real> _k0;
  Real _mu0;
  Real _Kf;
  MaterialProperty<std::vector<Real>> & _permeability;
  MaterialProperty<RealVectorValue> & _H_kernel_grav;
  MaterialProperty<RankTwoTensor> & _H_kernel;
  MaterialProperty<Real> * _H_kernel_time;
  // Additional properties when using this material for frac and fault in THM simulations
  MaterialProperty<RankTwoTensor> * _dH_kernel_dev;
  MaterialProperty<RankTwoTensor> * _dH_kernel_dpf;
  MaterialProperty<Real> * _dH_kernel_time_dev;
  MaterialProperty<Real> * _dH_kernel_time_dpf;
};

#endif // GAMUSINOMATERIALH_H
