#include "PoreFluidInertialForceCoupling.h"
#include "SubProblem.h"

template<>
InputParameters validParams<PoreFluidInertialForceCoupling>()
{
  InputParameters params = validParams<Kernel>();
  params.set<bool>("use_displaced_mesh") = false;
  
}
