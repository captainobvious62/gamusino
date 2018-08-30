[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 30
  nz = 0
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 100
  zmin = 0
  zmax = 0
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Variables]
  [disp_x]
    order = FIRST
    family = LAGRANGE
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [MKernel_x]
    type = GamusinoKernelM
    variable = disp_x
    component = 0
  []
  [MKernel_y]
    type = GamusinoKernelM
    variable = disp_y
    component = 1
  []
  [inertia_x]
    type = GamusinoInertialForce
    acceleration = 'accel_x'
    velocity = 'vel_x'
    beta = 0.3025
    gamma = 0.6
    variable = disp_x
  []
  [inertia_y]
    type = GamusinoInertialForce
    acceleration = 'accel_y'
    velocity = 'vel_y'
    beta = 0.3025
    gamma = 0.6
    variable = disp_y
  []
[]

[AuxVariables]
  [strain_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [vel_x]
  []
  [vel_y]
  []
  [accel_x]
  []
  [accel_y]
  []
[]

[AuxKernels]
  [strain_xy]
    type = GamusinoStrain
    variable = strain_xy
    index_i = 0
    index_j = 1
  []
  [stress_xy]
    type = GamusinoStress
    variable = stress_xy
    index_i = 0
    index_j = 1
  []
  [accel_x]
    type = NewmarkAccelAux
    displacement = 'disp_x'
    beta = 0.3025
    velocity = 'vel_x'
    variable = accel_x
  []
  [accel_y]
    type = NewmarkAccelAux
    displacement = 'disp_y'
    beta = 0.3025
    velocity = 'vel_y'
    variable = accel_y
  []
  [vel_x]
    type = NewmarkVelAux
    acceleration = 'accel_x'
    gamma = 0.6
    variable = vel_x
  []
  [vel_y]
    type = NewmarkVelAux
    acceleration = 'accel_y'
    gamma = 0.6
    variable = vel_y
  []
[]

[Functions]
  [ricker_wavelet]
    type = ParsedFunction
    vars = 'f factor shift'
    value = 'factor*((1.0 - 2.0*(pi^2)*(f^2)*( (t + 1/f * pi/shift)^2))*exp(-1.0*(pi^2)*(f^2)*((t + 1/f * pi/shift)^2)))'
    vals = '15 1 -36'
  []
  [disp_y_func]
    type = ParsedFunction
    value = 'm*t*x'
    vars = 'm'
    vals = '-0.1'
  []
[]

[BCs]
  inactive = 'no_x disp_y_plate no_y'
  [no_x]
    type = PresetBC
    variable = disp_x
    boundary = 'left right bottom top'
    value = 0.0
  []
  [disp_y_plate]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 'left right bottom top'
    function = disp_y_func
  []
  [no_y]
    type = PresetBC
    variable = disp_y
    boundary = 'left right bottom top'
    value = 0.0
  []
[]

[Materials]
  [MMaterial]
    type = GamusinoMaterialMElastic
    block = '0'
    strain_model = small_strain
    young_modulus = 10.0e+09
    poisson_ratio = 0.25
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    solid_density_initial = 3000
    has_gravity = false
    displacements = 'disp_x disp_y'
  []
[]

[UserObjects]
  [porosity]
    type = GamusinoPorosityConstant
  []
  [fluid_density]
    type = GamusinoFluidDensityConstant
  []
[]

[Preconditioning]
  [precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1E-10 1E-10 200 500 lu NONZERO'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0.0
  end_time = 10
  dt = 0.05
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  print_perf_log = true
  exodus = true
[]

[DiracKernels]
  [point_force]
    type = FunctionDiracSource
    function = ricker_wavelet
    point = '50 50 0'
    variable = disp_y
  []
[]
