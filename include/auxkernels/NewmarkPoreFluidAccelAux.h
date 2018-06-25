/*
/*


#ifndef NEWMARKPOREFLUIDACCELAUX_H
#define NEWMARKPOREFLUIDACCELAUX_H

#include "AuxKernel.h"

//Forward Declarations
class NewmarkPoreFluidAccelAux;

template<>
InputParameters validParams<NewmarkPoreFluidAccelAux>();

/**
* Accumulate values from one auxiliary variable into another
*/
class NewmarkPoreFluidAccelAux : public AuxKernel
{
public:

  NewmarkPoreFluidAccelAux(const InputParameters & parameters);

  virtual ~NewmarkPoreFluidAccelAux() {}

protected:
  virtual Real computeValue();

  VariableValue & _w_old; // W is Darcy Velocity
  VariableValue & _w;
  Real _gamma;

};

#endif //NewmarkPoreFluidAccelAux_H
