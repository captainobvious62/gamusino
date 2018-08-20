#include "GamusinoTimeControl.h"

template <>
InputParameters
validParams<GamusinoTimeControl>()
{
  InputParameters params = validParams<Control>();
  params.addRequiredParam<FunctionName>("function", "The function to use.");
  params.addParam<std::vector<std::string>>(
      "enable_objects", std::vector<std::string>(), "Objects to enable.");
  params.addParam<std::vector<std::string>>(
      "disable_objects", std::vector<std::string>(), "Objects to disable.");
  return params;
}
/*******************************************************************************
Routine: GamusinoTimeControl --- constructor
*******************************************************************************/
GamusinoTimeControl::GamusinoTimeControl(const InputParameters & parameters)
  : Control(parameters),
    _function(getFunction("function")),
    _enable(getParam<std::vector<std::string>>("enable_objects")),
    _disable(getParam<std::vector<std::string>>("disable_objects"))
{
  if (!_fe_problem.isTransient())
    mooseError("GamusinoTimeControl: objects operate only on transient problems!");
  if (_enable.empty() && _disable.empty())
    mooseError("GamusinoTimeControl: both object lists are empty!");
  if (_function.value(_t, Point()) != -1 && _function.value(_t, Point()) != 1)
    mooseError("GamusinoTimeControl: wrong value in the input file found. Only +1 (enable) or -1 "
               "(disable) are possible!");
}

/*******************************************************************************
Routine: initialSetup
*******************************************************************************/
void
GamusinoTimeControl::initialSetup()
{
}

/*******************************************************************************
Routine: execute
*******************************************************************************/
void
GamusinoTimeControl::execute()
{
  for (auto i = beginIndex(_enable); i < _enable.size(); ++i)
  {
    if (_function.value(_t, Point()) == 1)
      setControllableValueByName<bool>(_enable[i], std::string("enable"), true);
    else
      setControllableValueByName<bool>(_enable[i], std::string("enable"), false);
  }
  for (auto i = beginIndex(_disable); i < _disable.size(); ++i)
  {
    if (_function.value(_t, Point()) == -1)
      setControllableValueByName<bool>(_disable[i], std::string("enable"), false);
    else
      setControllableValueByName<bool>(_disable[i], std::string("enable"), true);
  }
}
