
#ifndef GAMUSINOINERTIALFORCE_H
#define GAMUSINOINERTIALFORCE_H

#include "Kernel.h"
#include "Material.h"

// Forward Declarations
class GamusinoInertialForce;

template <>
InputParameters validParams<GamusinoInertialForce>();

class GamusinoInertialForce : public Kernel
{
public:
  GamusinoInertialForce(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();

  virtual Real computeQpJacobian();

private:
  const MaterialProperty<Real> & _bulk_density;
  const VariableValue & _u_old;
  const VariableValue & _vel_old;
  const VariableValue & _accel_old;
  const Real _beta;
  const Real _gamma;
  const MaterialProperty<Real> & _eta;
  const Real _alpha;
};

#endif // GAMUSINOINERTIALFORCE_H
