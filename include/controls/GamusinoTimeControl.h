#ifndef GAMUSINOTIMECONTROL_H
#define GAMUSINOTIMECONTROL_H

#include "Control.h"
#include "Function.h"

class GamusinoTimeControl;
class Function;

template <>
InputParameters validParams<GamusinoTimeControl>();

class GamusinoTimeControl : public Control
{
public:
  GamusinoTimeControl(const InputParameters & parameters);
  virtual void execute() override;

protected:
  void initialSetup() override;
  Function & _function;

private:
  const std::vector<std::string> & _enable;
  const std::vector<std::string> & _disable;
};

#endif // GAMUSINOTIMECONTROL_H
