#ifndef GAMUSINOFUNCTIONBCFROMFILE_H
#define GAMUSINOFUNCTIONBCFROMFILE_H

#include "Function.h"
#include "GamusinoSetBCFromFile.h"
#include "GamusinoInterpolateBCFromFile.h"

class GamusinoFunctionBCFromFile;

template <>
InputParameters validParams<GamusinoFunctionBCFromFile>();

class GamusinoFunctionBCFromFile : public Function
{
public:
  GamusinoFunctionBCFromFile(const InputParameters & parameters);
  virtual ~GamusinoFunctionBCFromFile();
  virtual Real value(Real t, const Point & pt) override;

protected:
  GamusinoSetBCFromFile * _set_bc;
  GamusinoInterpolateBCFromFile * _interpolate_bc;
  int _n_points;
  bool _has_interpol_in_time;
  bool _has_interpol_in_space;
  const std::string _data_file_name;
  std::vector<Real> _time_frames;
  std::vector<std::string> _file_names;

private:
  void parseFile();
  bool parseNextLineReals(std::ifstream & ifs, std::vector<Real> & myvec);
  bool parseNextLineStrings(std::ifstream & ifs, std::vector<std::string> & myvec);
  void fillMatrixBC(ColumnMajorMatrix & px, ColumnMajorMatrix & py, ColumnMajorMatrix & pz);
  Real constant_value(Real t, const Point & pt);
  Real interpolated_value(Real t, const Point & pt);
};

#endif // GAMUSINOFUNCTIONBCFROMFILE_H
