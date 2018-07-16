#ifndef GAMUSINOPRESSUREACTION_H
#define GAMUSINOPRESSUREACTION_H

#include "Action.h"

class GamusinoPressureAction;

template <>
InputParameters validParams<GamusinoPressureAction>();

class GamusinoPressureAction : public Action
{
public:
  GamusinoPressureAction(const InputParameters & params);

  virtual void act() override;

protected:
  std::vector<std::vector<AuxVariableName>> _save_in_vars;
  std::vector<bool> _has_save_in_vars;
};

#endif // GAMUSINOPRESSUREACTION_H
