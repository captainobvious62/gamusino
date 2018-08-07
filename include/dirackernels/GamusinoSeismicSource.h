#ifndef GAMUSINOSEISMICSOURCE_H
#define GAMUSINOSEISMICSOURCE_H

// Moose Includes
#include "DiracKernel.h"

/**
 *  This class applies a force at the given point. The direction of the force is
 *  determined by the strike and dip angle of the fault and the slip direction
 *(rake).
 *  The magnitude of the force is dependent on the seismic moment
 *(shear_modulus*area*slip).
 *  Strike = 0 implies x axis is aligned with geographic North. If a 3-D model
 *is not being used,
 *  please adjust the strike, rake and dip angles accordingly.
 *  Reference: Quantitative Seismology by Keiiti Aki and Paul G. Richards,
 *Chapter 4.
 **/

// Forward Declarations
class Function;
class GamusinoSeismicSource;

template <>
InputParameters validParams<GamusinoSeismicSource>();

class GamusinoSeismicSource : public DiracKernel
{
public:
  GamusinoSeismicSource(const InputParameters & parameters);

  virtual void addPoints() override;
  virtual Real computeQpResidual() override;

protected:
  /// direction in which force is applied
  unsigned int _component;

  /// Moment tensor
  std::vector<std::vector<Real>> _moment;

  /// location of the point source
  Point _source_location;

  /// HHT time integration parameter alpha
  const Real _alpha;

  /// Shear modulus of the soil around the fault
  const Real _shear_modulus;

  /// Area of fault rupture
  const Real _area;

  /// Function describing slip time history
  Function * const _slip_function;

  /// Magnitude of moment = _shear_modulus * _area * slip. Used in residual
  /// calculation
  Real _moment_magnitude;

  /// force in each coordinate direction. Used in residual calculation
  Real _force;
};

#endif // GAMUSINOSEISMICSOURCE_H
