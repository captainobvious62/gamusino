#ifndef MASSCONSERVATIONNEWMARK_H
#define MASSCONSERVATIONNEWMARK_H

#include "Kernel.h"

//Forward Declarations
class MassConservationNewmark;

template<>
InputParameters validParams<MassConservationNewmark>();

class MassConservationNewmark : public Kernel
{
public:

    MassConservationNewmark(const InputParameters & parameters);

protected:
    virtual Real computeQpResidual();

    virtual Real computeQpJacobian();
    virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
    unsigned int _ndisp; // number of displacement components (1D, 2D, or 3D)
    unsigned int _ux_var; // ID of displacement components
    unsigned int _uy_var;
    unsigned int _uz_var;
    VariableGradient &_grad_ux; // gradient of displacement
    VariableGradient &_grad_uy;
    VariableGradient &_grad_uz;
    VariableGradient &_grad_ux_old; // gradient of previous displacement
    VariableGradient &_grad_uy_old;
    VariableGradient &_grad_uz_old;
    VariableGradient &_grad_vx_old; // gradient of previous velocity
    VariableGradient &_grad_vy_old;
    VariableGradient &_grad_vz_old;
    VariableGradient &_grad_ax_old; // gradient of previous acceleration
    VariableGradient &_grad_ay_old;
    VariableGradient &_grad_az_old;
    const Real _beta;
    const Real _gamma;

};
#endif //MASSCONSERVATIONNEWMARK_H
