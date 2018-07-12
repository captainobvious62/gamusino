
#include "GamusinoSUPG.h"

template <>
InputParameters
validParams<GamusinoSUPG>()
{
  InputParameters params = validParams<GeneralUserObject>();
  params.addParam<MooseEnum>("effective_length",
                             GamusinoSUPG::eleType() = "min",
                             "The characteristic element length for SUPG upwinding.");
  params.addParam<MooseEnum>("method", GamusinoSUPG::methodType() = "full", "The SUPG method.");
  params.addClassDescription(
      "User Object class to implement Streamline Petrov-Galerking Upwind technique.");
  return params;
}

GamusinoSUPG::GamusinoSUPG(const InputParameters & parameters)
  : GeneralUserObject(parameters),
    _effective_length(getParam<MooseEnum>("effective_length")),
    _method(getParam<MooseEnum>("method"))
{
}

MooseEnum
GamusinoSUPG::eleType()
{
  return MooseEnum("min=1 max=2 average=3 streamline=4");
}

MooseEnum
GamusinoSUPG::methodType()
{
  return MooseEnum("full=1 temporal=2 doubly_asymptotic=3 critical=4");
}

Real
GamusinoSUPG::tau(RealVectorValue vel, Real diff, Real dt, const Elem * ele) const
{
  Real norm_v = vel.norm();
  Real h_ele = EEL(vel, ele);
  Real tau = 0.0;
  switch (_method)
  {
    case 1: // full
      tau += Full(norm_v, h_ele, diff);
      break;
    case 2: // temporal
      tau += Temporal(norm_v, h_ele, diff, dt);
      break;
    case 3:
      tau += DoublyAsymptotic(norm_v, h_ele, diff);
      break;
    case 4:
      tau += Critical(norm_v, h_ele, diff);
      break;
  }
  return tau;
}

Real
GamusinoSUPG::Full(Real norm_v, Real h_ele, Real diff) const
{
  Real alpha = 0.5 * norm_v * h_ele / diff;
  Real tau = (norm_v > 0.0) ? cosh_relation(alpha) / norm_v : 0.0;
  return tau;
}

Real
GamusinoSUPG::Temporal(Real norm_v, Real h_ele, Real diff, Real dt) const
{
  return (1.0 / sqrt((2.0 / dt) * (2.0 / dt) + (2.0 * norm_v / h_ele) * (2.0 * norm_v / h_ele) +
                     (4.0 * diff / (h_ele * h_ele)) * (4.0 * diff / (h_ele * h_ele))));
}

Real
GamusinoSUPG::DoublyAsymptotic(Real norm_v, Real h_ele, Real diff) const
{
  Real alpha = 0.5 * norm_v * h_ele / diff;
  Real s = 0.0;
  if (-3.0 <= alpha && alpha <= 3.0)
    s = alpha / 3.0;
  else
    s = alpha * std::sqrt(alpha * alpha);
  return s;
}

Real
GamusinoSUPG::Critical(Real norm_v, Real h_ele, Real diff) const
{
  Real alpha = 0.5 * norm_v * h_ele / diff;
  Real s = 0.0;
  if (alpha < 1.0)
    s = -1.0 - 1.0 / alpha;
  else if (-1.0 <= alpha && alpha <= 1.0)
    s = 0.0;
  else if (1.0 < alpha)
    s = 1.0 - 1.0 / alpha;
  return s;
}

Real
GamusinoSUPG::cosh_relation(Real alpha) const
{
  Real s = 0.0;
  if (alpha < 0.01)
    s = alpha * (1.0 / 3.0 + alpha * alpha * (-1.0 / 45.0 + 18.0 / 8505.0 * alpha * alpha));
  else if (0.01 <= alpha && alpha < 20)
    s = (exp(alpha) + exp(-alpha)) / (exp(alpha) - exp(-alpha)) - 1 / alpha;
  else if (20 <= alpha)
    s = 1.0;
  return s;
}

Real
GamusinoSUPG::EEL(RealVectorValue vel, const Elem * ele) const
{
  Real L = 0.0;
  RealVectorValue my_vel = vel;
  if (ele->dim() == 1)
    L += ele->volume();
  else
  {
    switch (_effective_length)
    {
      case 1: // min
        L += ele->hmin();
        break;
      case 2: // max
        L += ele->hmax();
        break;
      case 3: // average
        L += 0.5 * (ele->hmin() + ele->hmax());
        break;
      case 4: // stream line length
        mooseError("GamusinoSUPG::EEL() --> stream line length needs some revision");
        break;
    }
  }
  return L;
}
