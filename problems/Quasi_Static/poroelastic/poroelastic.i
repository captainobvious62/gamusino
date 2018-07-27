[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
#  nz = 50
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 100
#  zmin = 0
#  zmax = 100
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  pore_pressure = pore_pressure
[]

[Variables]
  [./pore_pressure]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
#  [./disp_z]
#    order = FIRST
#    family = LAGRANGE
#  [../]
[]

[Kernels]
  [./HKernel]
    type = GamusinoKernelH
    variable = pore_pressure
  [../]
  [./MKernel_x]
    type = GamusinoKernelM
    variable = disp_x
    component = 0
  [../]
  [./MKernel_y]
    type = GamusinoKernelM
    variable = disp_y
    component = 1
  [../]
#  [./MKernel_z]
#    type = GamusinoKernelM
#    variable = disp_z
#    component = 2
#  [../]
[]

[AuxVariables]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yx]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./strain_xx]
    type = GamusinoStrain
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./strain_xy]
    type = GamusinoStrain
    variable = strain_xy
    index_i = 0
    index_j = 1
  [../]
  [./strain_yy]
    type = GamusinoStrain
    variable = strain_yy
    index_i = 1
    index_j = 1
  [../]
  [./strain_yx]
    type = GamusinoStrain
    variable = strain_yx
    index_i = 1
    index_j = 0
  [../]
  [./stress_xx]
    type = GamusinoStress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = GamusinoStress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_yy]
    type = GamusinoStress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yx]
    type = GamusinoStress
    variable = stress_yx
    index_i = 1
    index_j = 0
  [../]
[]

[BCs]
#  [./p0_bottom]
#    type = DirichletBC
#    variable = pore_pressure
#    boundary = bottom
#    value = 0.8e+06
#  [../]
  [./no_x_left]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  [./no_x_right]
    type = PresetBC
    variable = disp_x
    boundary = right
    value = 0.0
  [../]
  [./no_y_bottom]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]
#  [./no_z]
#    type = PresetBC
#    variable = disp_z
#    boundary = 'front back'
#    value = 0.0
#  [../]
[]

[Materials]
  [./HMMaterial]
    type = GamusinoMaterialMElastic
    block = 0
    strain_model = incr_small_strain
    young_modulus = 10.0e+09
    poisson_ratio = 0.25
    has_gravity = true
    solid_density_initial = 3058.104
    fluid_density_initial = 1019.368
    gravity_acceleration = 9.81
    permeability_initial = 1.0e-11
    fluid_viscosity_initial = 1.0e-03
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    permeability_uo = permeability
  [../]
[]

[UserObjects]
  [./porosity]
    type = GamusinoPorosityConstant
  [../]
  [./fluid_density]
    type = GamusinoFluidDensityConstant
  [../]
  [./fluid_viscosity]
    type = GamusinoFluidViscosityConstant
  [../]
  [./permeability]
    type = GamusinoPermeabilityConstant
  [../]
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1E-10 1E-10 200 500 lu NONZERO'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0.0
  end_time = 1.0
  dt = 1.0
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  print_perf_log = true
  exodus = true
[]
