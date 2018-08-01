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
inactive = 'Distributions'
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  xmin = 0.0
  xmax = 1.0
  ymin = 0.0
  ymax = 1.0
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
  [DynamicTensorMechanics]
    displacements = 'disp_x disp_y'
    alpha = 0.3
  []
  [inertia_x]
    type = InertialForce
    variable = disp_x
    velocity = 'vel_x'
    acceleration = 'accel_x'
    beta = 0.3025
    gamma = 0.6
    alpha = 0.3
  []
  [inertia_y]
    type = InertialForce
    variable = disp_y
    velocity = 'vel_y'
    acceleration = 'accel_y'
    beta = 0.3025
    gamma = 0.6
    alpha = 0.3
  []
[]

[DiracKernels]
  [SeismicSource]
    type = GamusinoSeismicSource
    displacements = 'disp_x disp_y'
    point = '0.25 0.25'
    slip = y_force
    strike = 0.0 # strike angle =0, x aligned with North
    dip = 45.0 # dip angle = pi/4, angle fault makes with horizontal
    rake = 90.0 # rake angle = pi/2, gives slip direction
    shear_modulus = 1.0
    area = 0.01
    component = 1
    variable = disp_y
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
  inactive = 'right_x left_x bottom_x bottom_y'
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
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    block = '0'
    youngs_modulus = 1.0
    poissons_ratio = 0.3
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
  end_time = 4.0
  l_tol = 1e-12
  nl_rel_tol = 1e-12
  dt = 0.01
[]

[Functions]
  inactive = 'displacement_bc'
  [displacement_bc]
    type = PiecewiseLinear
    data_file = sine_wave.csv
    format = columns
    scale_factor = 0.001
  []
  [y_force]
    type = PiecewiseLinear
    x = '0.0 1.0 2.0 3.0 4.0 5.0'
    y = '0.0 1.0 2.0 3.0 4.0 5.0'
  []
[]

[Postprocessors]
  [_dt]
    type = TimestepSize
  []
  [disp_1]
    type = NodalVariableValue
    nodeid = 1
    variable = vel_y
  []
  [disp_2]
    type = NodalVariableValue
    nodeid = 3
    variable = vel_y
  []
  [disp_3]
    type = NodalVariableValue
    nodeid = 10
    variable = vel_y
  []
  [disp_4]
    type = NodalVariableValue
    nodeid = 14
    variable = vel_y
  []
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]

[Distributions]
[]
