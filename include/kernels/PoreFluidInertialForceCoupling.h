#ifndef POREFLUIDINERTIALFORCECOUPLING_H
#define POREFLUIDINERTIALFORCECOUPLING_H

#include "Kernel.h"
#include "Material.h"

//Forward Declarations
class PoreFluidInertialForceCoupling;

template<>
InputParameters validParams<PoreFluidInertialForceCoupling>();

class PoreFluidInertialForceCoupling : public Kernel
{
public:

  PoreFluidInertialForceCoupling(const InputParameters & parameters);

protected:
  virtual Real computeQpResidual();

  virtual Real computeQpJacobian();
  virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
  const MaterialProperty<Real> & _rhof; // fluid density
  const VariableValue & _af_old; // previous value of fluid acceleration
  const VariableValue & _w; // darcy velocity
  const VariableValue & _w_old;
  unsigned int _w_var_num; // id of the Darcy vel variable
  const Real _gamma;

};
#endif //POREFLUIDINERTIALFORCECOUPLING_H
