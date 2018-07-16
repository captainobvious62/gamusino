#ifndef GAMUSINODRUCKERPRAGER_H
#define GAMUSINODRUCKERPRAGER_H

#include "GamusinoPQPlasticity.h"
#include "GamusinoHardeningModel.h"

class GamusinoDruckerPrager;

template <>
InputParameters validParams<GamusinoDruckerPrager>();

class GamusinoDruckerPrager : public GamusinoPQPlasticity
{
public:
  GamusinoDruckerPrager(const InputParameters & parameters);
  static MooseEnum MC_interpolation_scheme();

protected:
  virtual void computePQStress(const RankTwoTensor & stress, Real & p, Real & q) const override;
  virtual void
  setEffectiveElasticity(const RankFourTensor & Eijkl, Real & Epp, Real & Eqq) const override;
  virtual RankTwoTensor dpdstress(const RankTwoTensor & stress) const override;
  virtual RankFourTensor d2pdstress2(const RankTwoTensor & stress) const override;
  virtual RankTwoTensor dqdstress(const RankTwoTensor & stress) const override;
  virtual RankFourTensor d2qdstress2(const RankTwoTensor & stress) const override;
  virtual Real yieldFunctionValue(Real p, Real q, const Real & intnl) const override;
  virtual Real dyieldFunction_dp(Real p, Real q, const Real & intnl) const override;
  virtual Real dyieldFunction_dq(Real p, Real q, const Real & intnl) const override;
  virtual Real dyieldFunction_dintnl(Real p, Real q, const Real & intnl) const override;
  virtual Real dflowPotential_dp(Real p, Real q, const Real & intnl) const override;
  virtual Real dflowPotential_dq(Real p, Real q, const Real & intnl) const override;
  virtual Real d2flowPotential_dp2(Real p, Real q, const Real & intnl) const override;
  virtual Real d2flowPotential_dp_dq(Real p, Real q, const Real & intnl) const override;
  virtual Real d2flowPotential_dq2(Real p, Real q, const Real & intnl) const override;
  virtual Real d2flowPotential_dp_dintnl(Real p, Real q, const Real & intnl) const override;
  virtual Real d2flowPotential_dq_dintnl(Real p, Real q, const Real & intnl) const override;
  virtual void setIntnlValues(Real p_trial,
                              Real q_trial,
                              Real p,
                              Real q,
                              const Real & intnl_old,
                              Real & intnl) const override;
  virtual void setIntnlDerivatives(Real p_trial,
                                   Real q_trial,
                                   Real p,
                                   Real q,
                                   const Real & intnl,
                                   std::vector<Real> & dintnl) const override;

  const GamusinoHardeningModel & _MC_cohesion;
  const GamusinoHardeningModel & _MC_friction;
  const GamusinoHardeningModel & _MC_dilation;
  const MooseEnum _MC_interpolation_scheme;
  const bool _no_hardening_cohesion;
  const bool _no_hardening_friction;
  const bool _no_hardening_dilation;
  enum FrictionOrDilation
  {
    friction = 0,
    dilation = 1
  };

private:
  void bothAB(Real intnl, Real & k, Real & alpha) const;
  void onlyB(Real intnl, int f_or_d, Real & alpha_beta) const;
  void dbothAB(Real intnl, Real & dk, Real & dalpha) const;
  void donlyB(Real intnl, int f_or_d, Real & dalpha_beta) const;
  void initializeAB(Real intnl, Real & k, Real & alpha) const;
  void initializeB(Real intnl, int f_or_d, Real & alpha_beta) const;

  Real _smoother2;
  Real _alpha; // for friction
  Real _beta;  // for dilation
  Real _k;
};

#endif // GAMUSINODRUCKERPRAGER_H
