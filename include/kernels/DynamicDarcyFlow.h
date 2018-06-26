#ifndef DYNAMICDARCYFLOW_H
#define DYNAMICDARCYFLOW_H

#include "Kernel.h"
#include "Material.h"

//Forward Declarations
class DynamicDarcyFlow;

template<>
InputParameters validParams<DynamicDarcyFlow>();

class DynamicDarcyFlow : public Kernel
{
public:

    DynamicDarcyFlow(const InputParameters & parameters);

protected:
    virtual Real computeQpResidual();

    virtual Real computeQpJacobian();
    virtual Real computeQpOffDiagJacobian(unsigned int jvar);

private:
    const MaterialProperty<Real> & _rhof; // fluid density
    const MaterialProperty<Real> & _nf; // porosity
    const MaterialProperty<Real> & _K; // hydraulic conductivity
    const VariableValue & _us; // skeleton displacement
    const VariableValue & _us_old;
    const VariableValue & _vs_old; // skeleton velocity
    const VariableValue & _as_old; // skeleton acceleration
    const VariableValue & _u_old; // Darcy velocity,
                                  // actually termed w, however referred to as
                                  // u in this kernel as it is the primary
                                  // variable
    const VariableValue & _af_old; // fluid relative acceleration
    unsigned int _us_var_num; // ID of skeleton displacement variable
    const Real _gravity; // acceleration due to gravity
    const Real _beta;
    const Real _gamma;

};
#endif //DYNAMICDARCYFLOW_H
