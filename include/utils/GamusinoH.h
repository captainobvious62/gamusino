#ifndef GAMUSINOH_H
#define GAMUSINOH_H

#include "MooseTypes.h"
#include "RankTwoTensor.h"

RankTwoTensor computeKernel(std::vector<Real>, MooseEnum, Real, int dim);

#endif // GAMUSINOH_H
