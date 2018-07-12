
#include "GamusinoPropertyReadFile.h"

template <>
InputParameters
validParams<GamusinoPropertyReadFile>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addClassDescription(
      "User Object to read property data from an external file and assign to elements.");
  params.addParam<std::string>("prop_file_name", "", "Name of the property file name.");
  params.addParam<unsigned int>("nprop", 0, "number of property to read.");
  params.addParam<unsigned int>("nele", 0, "number of elements to read.");
  return params;
}

GamusinoPropertyReadFile::GamusinoPropertyReadFile(const InputParameters & parameters)
  : GeneralUserObject(parameters),
    _prop_file_name(getParam<std::string>("prop_file_name")),
    _nprop(getParam<unsigned int>("nprop")),
    _nelem(getParam<unsigned int>("nele"))
{
  readData();
}

void
GamusinoPropertyReadFile::readData()
{
  _Eledata.resize(_nelem * _nprop);
  MooseUtils::checkFileReadable(_prop_file_name);
  std::ifstream file_prop;
  file_prop.open(_prop_file_name.c_str());
  for (unsigned int i = 0; i < _nelem; ++i)
  {
    for (unsigned int j = 0; j < _nprop; ++j)
    {
      if (!(file_prop >> _Eledata[i * _nprop + j]))
        mooseError("Error GamusinoPropertyReadFile : Premature end of file!");
    }
  }
  file_prop.close();
}

Real
GamusinoPropertyReadFile::getData(const Elem * elem, unsigned int prop_num) const
{
  unsigned int jelem = elem->id();
  mooseAssert(jelem < _nelem,
              "Error GamusinoPropertyReadFile: Element "
                  << jelem
                  << " greater than total number of block elements\n");
  mooseAssert(prop_num < _nprop,
              "Error GamusinoPropertyReadFile: Property number "
                  << prop_num
                  << " greater than total number of properties "
                  << 4);
  return _Eledata[jelem * _nprop + prop_num];
}
