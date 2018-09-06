# Wave propogation in 1D using HHT time integration
#
# The test is for an 1D bar element of length 4m  fixed on one end
# with a sinusoidal pulse dirichlet boundary condition applied to the other end.
# alpha, beta and gamma are Newmark  time integration parameters
# The equation of motion in terms of matrices is:
#
# M*accel + K*((1+alpha)*disp-alpha*disp_old) = 0
#
# Here M is the mass matrix, K is the stiffness matrix
#
# The displacement at the second, third and fourth node at t = 0.1 are
# -8.097405701570538350e-02, 2.113131879547342634e-02 and -5.182787688751439893e-03, respectively.
inactive = 'Functions DiracKernels'
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 60
  ny = 60
  nz = 1
  xmin = 0.0
  xmax = 5.0
  ymin = 0.0
  ymax = 5.0
  zmin = 0.0
  zmax = 0.1
  elem_type = TRI3
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
[]

[AuxVariables]
  [vel_x]
  []
  [accel_x]
  []
  [vel_y]
  []
  [accel_y]
  []
[]

[Kernels]
  inactive = 'RigidBodyMultiKernel'
  [DynamicTensorMechanics]
    displacements = 'disp_x disp_y'
    alpha = -0.3
    decomposition_method = EigenSolution
    use_displaced_mesh = true
  []
  [inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = 'vel_x'
    acceleration = 'accel_x'
    beta = 0.3025
    gamma = 0.5
    alpha = -0.3
    eta = 0.1
  []
  [inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = 'vel_y'
    acceleration = 'accel_y'
    beta = 0.3025
    gamma = 0.5
    alpha = -0.3
    eta = 0.1
  []
  [RigidBodyMultiKernel]
  []
[]

[AuxKernels]
  [accel_x]
    type = NewmarkAccelAux
    variable = accel_x
    displacement = 'disp_x'
    velocity = 'vel_x'
    beta = 0.3025
    execute_on = 'timestep_end'
  []
  [vel_x]
    type = NewmarkVelAux
    variable = vel_x
    acceleration = 'accel_x'
    gamma = 0.6
    execute_on = 'timestep_end'
  []
  [accel_y]
    type = NewmarkAccelAux
    variable = accel_y
    displacement = 'disp_y'
    velocity = 'vel_y'
    beta = 0.3025
    execute_on = 'timestep_end'
  []
  [vel_y]
    type = NewmarkVelAux
    variable = vel_y
    acceleration = 'accel_y'
    gamma = 0.6
    execute_on = 'timestep_end'
  []
[]

[BCs]
  [top_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'top'
    value = 0.0
  []
  [top_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'top'
    value = 0.0
  []
  [right_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'right'
    value = 0.0
  []
  [left_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'left'
    value = 0.0
  []
  [bottom_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'bottom'
    value = 0.0
  []
  [bottom_y]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 'bottom'
    function = displacement_bc
  []
[]

[Materials]
  [Elasticity_tensor]
    type = ComputeElasticityTensor
    block = '0'
    fill_method = symmetric_isotropic
    C_ijkl = '1 0'
  []
  [strain]
    type = ComputeSmallStrain
    block = '0'
    displacements = 'disp_x disp_y'
  []
  [stress]
    type = ComputeLinearElasticStress
    store_stress_old = true
    block = '0'
  []
  [density]
    type = GenericConstantMaterial
    block = '0'
    prop_names = 'density'
    prop_values = '1'
  []
[]

[Executioner]
  type = Transient
  start_time = 0
  end_time = 6.0
  l_tol = 1e-12
  nl_rel_tol = 1e-12
  dt = 0.05
  scheme = explicit-euler
  solve_type = PJFNK
[]

[Functions]
[]

[Postprocessors]
  [_dt]
    type = TimestepSize
  []
[]

[Outputs]
  exodus = true
  perf_graph = true
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[DiracKernels]
[]
