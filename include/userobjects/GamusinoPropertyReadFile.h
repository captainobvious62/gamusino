#ifndef GAMUSINOPROPERTYREADFILE_H
#define GAMUSINOPROPERTYREADFILE_H

#include "GeneralUserObject.h"

class GamusinoPropertyReadFile;

template <>
InputParameters validParams<GamusinoPropertyReadFile>();

class GamusinoPropertyReadFile : public GeneralUserObject
{
public:
  GamusinoPropertyReadFile(const InputParameters & parameters);
  virtual ~GamusinoPropertyReadFile() {}
  virtual void initialize() {}
  virtual void execute() {}
  virtual void finalize() {}
  void readData();
  Real getData(const Elem *, unsigned int) const;

protected:
  std::string _prop_file_name;
  std::vector<Real> _Eledata;
  unsigned int _nprop;
  unsigned int _nelem;

private:
};

#endif // GAMUSINOPROPERTYREADFILE_H
