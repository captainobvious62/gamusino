#include "GamusinoH.h"
#include "MooseError.h"
#include "MooseEnum.h"

RankTwoTensor
computeKernel(std::vector<Real> k0, MooseEnum dist, Real den, int dim)
{
  RealVectorValue kx;
  RealVectorValue ky;
  RealVectorValue kz;
  RankTwoTensor k;
  if (dim == 1)
  {
    switch (dist)
    {
      case 1:
        if (k0.size() != 1)
          mooseError(
              "One input value is needed for isotropic distribution of permeability! You provided ",
              k0.size(),
              " values.\n");
        kx = RealVectorValue(k0[0] * den, 0.0, 0.0);
        ky = RealVectorValue(0.0, 0.0, 0.0);
        kz = RealVectorValue(0.0, 0.0, 0.0);
        break;
      case 2:
      case 3:
        mooseError("One dimensional elements cannot have non-isotropic permeability values.\n");
        break;
    }
  }
  else if (dim == 2)
  {
    switch (dist)
    {
      case 1:
        if (k0.size() != 1)
          mooseError(
              "One input value is needed for isotropic distribution of permeability! You provided ",
              k0.size(),
              " values.\n");
        kx = RealVectorValue(k0[0] * den, 0.0, 0.0);
        ky = RealVectorValue(0.0, k0[0] * den, 0.0);
        kz = RealVectorValue(0.0, 0.0, 0.0);
        break;
      case 2:
        if (k0.size() != 2)
          mooseError("Two input values are needed for orthotropic distribution of permeability! "
                     "You provided ",
                     k0.size(),
                     " values.\n");
        kx = RealVectorValue(k0[0] * den, 0.0, 0.0);
        ky = RealVectorValue(0.0, k0[1] * den, 0.0);
        kz = RealVectorValue(0.0, 0.0, 0.0);
        break;
      case 3:
        mooseError("Two dimensional elements cannot have non-isotropic permeability values.\n");
        break;
    }
  }
  else if (dim == 3)
  {
    switch (dist)
    {
      case 1:
        if (k0.size() != 1)
          mooseError(
              "One input value is needed for isotropic distribution of permeability! You provided ",
              k0.size(),
              " values.\n");
        kx = RealVectorValue(k0[0] * den, 0.0, 0.0);
        ky = RealVectorValue(0.0, k0[0] * den, 0.0);
        kz = RealVectorValue(0.0, 0.0, k0[0] * den);
        break;
      case 2:
        if (k0.size() != 3)
          mooseError("Three input values are needed for orthotropic distribution of permeability! "
                     "You provided ",
                     k0.size(),
                     " values.\n");
        kx = RealVectorValue(k0[0] * den, 0.0, 0.0);
        ky = RealVectorValue(0.0, k0[1] * den, 0.0);
        kz = RealVectorValue(0.0, 0.0, k0[2] * den);
        break;
      case 3:
        if (k0.size() != 9)
          mooseError("Nine input values are needed for anisotropic distribution of permeability! "
                     "You provided ",
                     k0.size(),
                     " values.\n");
        kx = RealVectorValue(k0[0] * den, k0[1] * den, k0[2] * den);
        ky = RealVectorValue(k0[3] * den, k0[4] * den, k0[5] * den);
        kz = RealVectorValue(k0[6] * den, k0[7] * den, k0[8] * den);
        break;
    }
  }
  k = RankTwoTensor(kx, ky, kz);
  return k;
}
