#ifndef GAMUSINOFUNCTIONREADFILE_H
#define GAMUSINOFUNCTIONREADFILE_H

#include "Function.h"

class GamusinoFunctionReadFile;

template <>
InputParameters validParams<GamusinoFunctionReadFile>();

class GamusinoFunctionReadFile : public Function
{
public:
  GamusinoFunctionReadFile(const InputParameters & parameters);
  virtual Real value(Real t, const Point & pt) override;

protected:
  const std::string _file;
  std::vector<Real> _time;
  std::vector<Real> _value;

private:
  void readFile();
};

#endif // GAMUSINOFUNCTIONREADFILE_H
