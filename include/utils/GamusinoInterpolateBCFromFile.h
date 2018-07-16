#ifndef GAMUSINOINTERPOLATEBCFROMFILE_H
#define GAMUSINOINTERPOLATEBCFROMFILE_H

#include "MooseTypes.h"
#include "ColumnMajorMatrix.h"

class GamusinoInterpolateBCFromFile
{
public:
  GamusinoInterpolateBCFromFile(const int n_points,
                             const std::vector<Real> & time_frames,
                             const std::vector<std::string> & file_names,
                             const ColumnMajorMatrix & px,
                             const ColumnMajorMatrix & py,
                             const ColumnMajorMatrix & pv);
  GamusinoInterpolateBCFromFile()
    : _n_points(0), _time_frames(std::vector<Real>()), _file_names(std::vector<std::string>())
  {
  }
  Real sample(Real t, Real xcoord, Real ycoord);
  Real sampleTime(Real t, Real xcoord, Real ycoord);

protected:
  const int _n_points;
  const std::vector<Real> _time_frames;
  const std::vector<std::string> _file_names;
  ColumnMajorMatrix _px;
  ColumnMajorMatrix _py;
  ColumnMajorMatrix _pv;

private:
  void errorCheck();
  Real interpolate_values(int, Real, Real);
};

#endif // GAMUSINOINTERPOLATEBCFROMFILE_H
