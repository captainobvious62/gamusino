#include "GamusinoInterpolateBCFromFile.h"

GamusinoInterpolateBCFromFile::GamusinoInterpolateBCFromFile(const int n_points,
                                                       const std::vector<Real> & time_frames,
                                                       const std::vector<std::string> & file_names,
                                                       const ColumnMajorMatrix & px,
                                                       const ColumnMajorMatrix & py,
                                                       const ColumnMajorMatrix & pv)
  : _n_points(n_points),
    _time_frames(time_frames),
    _file_names(file_names),
    _px(px),
    _py(py),
    _pv(pv)
{
  errorCheck();
}

void
GamusinoInterpolateBCFromFile::errorCheck()
{
  if (_time_frames.size() != _file_names.size())
    mooseError("In GamusinoInterpolateBCFromFile: Vectors _time_frames & _file_names are not of the "
               "same length!");
  bool error = false;
  for (unsigned i = 0; !error && i + 1 < _time_frames.size(); ++i)
  {
    if (_time_frames[i] >= _time_frames[i + 1])
      error = true;
  }
  if (error)
    mooseError("In GamusinoInterpolateBCFromFile: time values are not strictly increasing!");
}

Real
GamusinoInterpolateBCFromFile::sample(Real t, Real xcoord, Real ycoord)
{
  mooseAssert(_time_frames.size() > 0, "Sampling an empty GamusinoInterpolateBCFromFile.");
  int position;
  if (_file_names.size() > 1)
  {
    for (unsigned int i(0); i < _file_names.size() - 1; ++i)
    {
      if (t <= _time_frames[0])
        return interpolate_values(0, xcoord, ycoord);
      else if (t >= _time_frames.back())
        return interpolate_values(_time_frames.size() - 1, xcoord, ycoord);
      else if (t >= _time_frames[i] && t < _time_frames[i + 1])
        return interpolate_values(i, xcoord, ycoord);
    }
  }
  // else
  // if (t != _time_frames[0])
  //   mooseError("In GamusinoInterpolateBCFromFile::sample : t= "<< t <<" but _time_frames= "<<
  //   _time_frames[0]);
  return interpolate_values(0, xcoord, ycoord);
}

Real
GamusinoInterpolateBCFromFile::sampleTime(Real t, Real xcoord, Real ycoord)
{
  mooseAssert(_time_frames.size() > 0, "Sampling an empty GamusinoInterpolateBCFromFile.");
  int posi;
  int posj;
  bool found = false;
  if (t <= _time_frames[0])
    return interpolate_values(0, xcoord, ycoord);
  else if (t >= _time_frames.back())
    return interpolate_values(_time_frames.size() - 1, xcoord, ycoord);
  else
  {
    found = false;
    for (unsigned int i(0); i + 1 < _time_frames.size(); ++i)
    {
      if (t >= _time_frames[i] && t < _time_frames[i + 1])
      {
        posi = i;
        found = true;
        break;
      }
    }
    if (!found)
      mooseError("GamusinoInterpolateBCFromFile : sampleTime Unreachable? @ x=",
                 xcoord,
                 " , y=",
                 ycoord,
                 " , posi=",
                 posi,
                 " !!");
    Real val_i = interpolate_values(posi, xcoord, ycoord);
    Real val_ii = interpolate_values(posi + 1, xcoord, ycoord);
    return val_i +
           (val_ii - val_i) * (t - _time_frames[posi]) /
               (_time_frames[posi + 1] - _time_frames[posi]);
  }
  return 0;
}

Real
GamusinoInterpolateBCFromFile::interpolate_values(int pos, Real xcoord, Real ycoord)
{
  Real sum = 0.0;
  Real z = 0.0;
  Real distance = 0.0;
  std::vector<Real> lambda;
  for (unsigned int i = 0; i < _n_points; ++i)
  {
    if (std::fabs(_px(pos, i) - xcoord) < 0.1 && std::fabs(_py(pos, i) - ycoord) < 0.1)
      return _pv(pos, i);
    distance = (_px(pos, i) - xcoord) * (_px(pos, i) - xcoord) +
               (_py(pos, i) - ycoord) * (_py(pos, i) - ycoord);
    lambda.push_back(1.0 / (distance * distance));
  }
  for (unsigned int i = 0; i < lambda.size(); ++i)
  {
    sum += lambda[i];
    z += lambda[i] * _pv(pos, i);
  }
  return z / sum;
}
