#ifndef GAMUSINOFUNCTIONPOINTFORCE_H
#define GAMUSINOFUNCTIONPOINTFORCE_H

// Moose Includes
#include "DiracKernel.h"

// Forward Declarations
class Function;
class GamusinoFunctionPointForce;

template <>
InputParameters validParams<GamusinoFunctionPointForce>();

/**
 * This class applies a force at the given point/points in a given direction.
 * The force can be given as a function of space and/or time.
 **/
class GamusinoFunctionPointForce : public DiracKernel
{
public:
  GamusinoFunctionPointForce(const InputParameters & parameters);

  virtual void addPoints() override;

  virtual Real computeQpResidual() override;

protected:
  /// location of the point force
  Point _p;
};

#endif // GAMUSINOFUNCTIONPOINTFORCE_H
