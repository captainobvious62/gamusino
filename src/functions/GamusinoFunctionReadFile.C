#include "GamusinoFunctionReadFile.h"

template <>
InputParameters
validParams<GamusinoFunctionReadFile>()
{
  InputParameters params = validParams<Function>();
  params.addRequiredParam<std::string>(
      "file", "File holding csv/tab/space-separated data. It does not consider ; as a delimiter");
  return params;
}

GamusinoFunctionReadFile::GamusinoFunctionReadFile(const InputParameters & parameters)
  : Function(parameters), _file(getParam<std::string>("file"))
{
  _time.clear();
  _value.clear();
  readFile();
}

Real
GamusinoFunctionReadFile::value(Real t, const Point & /*pt*/)
{
  Real value = 0.0;   // default value to return
  bool found = false; // flag for console outprinting
  Real time_step;
  Real value_step;
  for (unsigned int i = 0; i < _time.size(); i++)
  {
    /*check time bounds - if trepassed break the loop*/
    /*smaller than firt time entry --> set default value*/
    if (t < _time[0])
      break;
    /*bigger than last entry --> set last value*/
    if (t > _time[_time.size() - 1])
    {
      value = _value[_time.size() - 1];
      break;
    }
    /*internal entries --> either hit or inside*/
    if ((t >= _time[i] && t < _time[i + 1]))
    {
      time_step = _time[i + 1] - _time[i];
      if (time_step == 0.0)
        break;
      value_step = _value[i + 1] - _value[i];
      value = _value[i + 1] - value_step * (_time[i + 1] - t) / time_step;
      found = true;
      break;
    }
  }
  /*value not found -- should one print an error or disregard (return 0)? I am not sure here*/
  if (!found)
    Moose::out << "GamusinoFunctionReadFile::value() - function value @ time = " << t
               << " not found. Set to default value = " << value << "\n";
  return value;
}

void
GamusinoFunctionReadFile::readFile()
{
  std::string line;
  MooseUtils::checkFileReadable(_file);
  std::ifstream stream;
  stream.open(_file.c_str());
  if (!stream.good())
    mooseError("Error opening file '", _file, "' from GamusinoFunctionReadFile function.");
  while (std::getline(stream, line))
  {
    if (line.empty())
      continue;
    if (line[0] != '#')
    {
      std::istringstream iss(line);
      std::vector<Real> vec_tmp;
      Real f;
      while (iss >> f)
        vec_tmp.push_back(f);
      if (vec_tmp.size() > 0)
      {
        if (vec_tmp.size() > 2)
          mooseError("Wrong number of columns [",
                     vec_tmp.size(),
                     "] from file '",
                     _file,
                     "' in GamusinoFunctionReadFile function.");
        _time.push_back(vec_tmp[0]);
        _value.push_back(vec_tmp[1]);
      }
      vec_tmp.clear();
    }
  }
  stream.close();
}
