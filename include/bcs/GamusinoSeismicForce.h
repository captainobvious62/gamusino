#ifndef GAMUSINOSEISMICFORCE_H
#define GAMUSINOSEISMICFORCE_H

#include "IntegratedBC.h"

class Function;
class GamusinoSeismicForce;

template <>
InputParameters validParams<GamusinoSeismicForce>();

/**
 * SeismicForce applies a pressure on a given boundary in the direction defined
 * by component
 */
class GamusinoSeismicForce : public IntegratedBC
{
public:
  GamusinoSeismicForce(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual() override;

  /// The direction associated with the variable is given in _component.
  const unsigned int _component;

  /// The direction in which the ground velocity is applied.
  const unsigned int _vel_component;

  /// Scaling factor that needs to be applied to the force
  const Real _factor;

  /// alpha Parameter for HHT time integration scheme
  const Real _alpha;

  /// density of the soil
  const MaterialProperty<Real> & _density;

  /// shear wave speed of the soil
  const MaterialProperty<Real> & _shear_wave_speed;

  /// P wave speed of the soil
  const MaterialProperty<Real> & _P_wave_speed;
};

#endif // GAMUSINOSEISMICFORCE_H
