
#include "GamusinoPermeabilityKC.h"
#include "libmesh/utility.h"

template <>
InputParameters
validParams<GamusinoPermeabilityKC>()
{
  InputParameters params = validParams<GamusinoPermeability>();
  params.addClassDescription("Kozeny-Carman Permeability formulation");
  return params;
}

GamusinoPermeabilityKC::GamusinoPermeabilityKC(const InputParameters & parameters)
  : GamusinoPermeability(parameters)
{
}

std::vector<Real>
GamusinoPermeabilityKC::computePermeability(std::vector<Real> k0, Real phi0, Real porosity, Real) const
{
  std::vector<Real> k;
  if (phi0 != 1.0)
  {
    std::vector<Real> A = k0;
    for (unsigned int i = 0; i < A.size(); ++i)
      A[i] *= Utility::pow<2>(1.0 - phi0) / Utility::pow<3>(phi0);

    k = A;
    for (unsigned int i = 0; i < k.size(); ++i)
      k[i] *= Utility::pow<3>(porosity) / Utility::pow<2>(1.0 - porosity);
  }
  else
  {
    k = k0;
  }

  return k;
}

std::vector<Real>
GamusinoPermeabilityKC::computedPermeabilitydev(std::vector<Real> k0,
                                             Real phi0,
                                             Real porosity,
                                             Real dphi_dev) const
{
  std::vector<Real> A = k0;
  for (unsigned int i = 0; i < A.size(); ++i)
    A[i] *= Utility::pow<2>(1.0 - phi0) / Utility::pow<3>(phi0);

  std::vector<Real> dk_dev = A;
  for (unsigned int i = 0; i < dk_dev.size(); ++i)
    dk_dev[i] *=
        Utility::pow<2>(porosity) * (3.0 - porosity) / Utility::pow<3>(1.0 - porosity) * dphi_dev;
  return dk_dev;
}

std::vector<Real>
GamusinoPermeabilityKC::computedPermeabilitydpf(std::vector<Real> k0,
                                             Real phi0,
                                             Real porosity,
                                             Real dphi_dpf) const
{
  std::vector<Real> A = k0;
  for (unsigned int i = 0; i < A.size(); ++i)
  {
    A[i] *= Utility::pow<2>(1.0 - phi0) / Utility::pow<3>(phi0);
  }

  std::vector<Real> dk_dpf = A;
  for (unsigned int i = 0; i < dk_dpf.size(); ++i)
  {
    dk_dpf[i] *=
        Utility::pow<2>(porosity) * (3.0 - porosity) / Utility::pow<3>(1.0 - porosity) * dphi_dpf;
  }

  return dk_dpf;
}

std::vector<Real>
GamusinoPermeabilityKC::computedPermeabilitydT(std::vector<Real> k0,
                                            Real phi0,
                                            Real porosity,
                                            Real dphi_dT) const
{
  std::vector<Real> A = k0;
  for (unsigned int i = 0; i < A.size(); ++i)
  {
    A[i] *= Utility::pow<2>(1.0 - phi0) / Utility::pow<3>(phi0);
  }

  std::vector<Real> dk_dT = A;
  for (unsigned int i = 0; i < dk_dT.size(); ++i)
  {
    dk_dT[i] *=
        Utility::pow<2>(porosity) * (3.0 - porosity) / Utility::pow<3>(1.0 - porosity) * dphi_dT;
  }

  return dk_dT;
}
