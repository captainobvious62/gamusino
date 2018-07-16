#ifndef GAMUSINOM_H
#define GAMUSINOM_H

class RankFourTensor;

namespace GamusinoM
{

/**
 * This is used for the standard kernel stress_ij*d(test)/dx_j, when varied wrt u_k
 * Jacobian entry: d(stress_ij*d(test)/dx_j)/du_k = d(C_ijmn*du_m/dx_n*dtest/dx_j)/du_k
 */
Real elasticJacobian(const RankFourTensor & r4t,
                     unsigned int i,
                     unsigned int k,
                     const RealGradient & grad_test,
                     const RealGradient & grad_phi);

/**
 * Get the shear modulus for an isotropic elasticity tensor
 * param elasticity_tensor the tensor (must be isotropic, but not checked for efficiency)
 */
Real getIsotropicShearModulus(const RankFourTensor & elasticity_tensor);

/**
 * Get the bulk modulus for an isotropic elasticity tensor
 * param elasticity_tensor the tensor (must be isotropic, but not checked for efficiency)
 */
Real getIsotropicBulkModulus(const RankFourTensor & elasticity_tensor);

/**
 * Get the Young's modulus for an isotropic elasticity tensor
 * param elasticity_tensor the tensor (must be isotropic, but not checked for efficiency)
 */
Real getIsotropicYoungsModulus(const RankFourTensor & elasticity_tensor);
}

#endif // GAMUSINOM_H
