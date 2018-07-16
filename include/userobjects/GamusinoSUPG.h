#ifndef GAMUSINOSUPG_H
#define GAMUSINOSUPG_H

#include "GeneralUserObject.h"

class GamusinoSUPG;

template <>
InputParameters validParams<GamusinoSUPG>();

class GamusinoSUPG : public GeneralUserObject
{
public:
  GamusinoSUPG(const InputParameters & parameters);
  virtual void initialize() {}
  virtual void execute() {}
  virtual void finalize() {}
  static MooseEnum eleType();
  static MooseEnum methodType();
  virtual Real tau(RealVectorValue vel, Real diff, Real dt, const Elem * ele) const;

protected:
  MooseEnum _effective_length;
  MooseEnum _method;

private:
  Real EEL(RealVectorValue vel, const Elem * ele) const;
  Real cosh_relation(Real) const;
  Real Full(Real, Real, Real) const;
  Real Temporal(Real, Real, Real, Real) const;
  Real DoublyAsymptotic(Real, Real, Real) const;
  Real Critical(Real, Real, Real) const;
};

#endif // GAMUSINOSUPG_H
