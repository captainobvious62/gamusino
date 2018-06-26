#ifndef POREPRESSUREBC_H
#define POREPRESSUREBC_H

#include "IntegratedBC.h"

// Forward Declarations
class PorePressureBC;

template<>
InputParameters validParams<PorePressureBC>();

class PorePressureBC : public IntegratedBC
{

public:
    PorePressureBC(const InputParameters &parameters);

    virtual ~PorePressureBC(){};

protected:

    virtual Real computeQpResidual();
    virtual Real computeQpJacobian();

private:

    const unsigned int _component;
    const Real _specified_pore_pressure;
};

#endif // POREPRESSUREBC_H
