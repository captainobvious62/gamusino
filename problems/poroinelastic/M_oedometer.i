[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 10
  nz = 10
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  zmin = 0
  zmax = 1
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
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
  [./MKernel_z]
    type = GamusinoKernelM
    variable = disp_z
    component = 2
  [../]
[]

[AuxVariables]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./yield]
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
  [./plastic_strain_xx]
    type = GamusinoStrain
    strain_type = plastic
    variable = plastic_strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xx]
    type = GamusinoStress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./yield]
    type = MaterialRealAux
    variable = yield
    property = plastic_yield_function
  [../]
[]

[BCs]
  [./no_x_left]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  [./load_x_right]
    type = GamusinoVelocityBC
    variable = disp_x
    boundary = right
    velocity = -1.0e-05
  [../]
  [./no_y]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom top'
    value = 0.0
  [../]
  [./no_z_back]
    type = PresetBC
    variable = disp_z
    boundary = 'back front'
    value = 0.0
  [../]
[]

[Materials]
  [./DP]
    type = GamusinoDruckerPrager
    MC_cohesion = DP_cohesion
    MC_friction = DP_friction
    MC_dilation = DP_dilation
    yield_function_tol = 1.0e-08
  [../]
  [./MMaterial]
    type = GamusinoMaterialMInelastic
    block = 0
    strain_model = incr_small_strain
    bulk_modulus = 2.0e+03
    shear_modulus = 2.0e+03
    inelastic_models = 'DP'
    porosity_uo = porosity
    fluid_density_uo = fluid_density
  [../]
[]

[UserObjects]
  [./porosity]
    type = GamusinoPorosityConstant
  [../]
  [./fluid_density]
    type = GamusinoFluidDensityConstant
  [../]
  [./DP_cohesion]
    type = GamusinoHardeningConstant
    value = 1.0
  [../]
  [./DP_friction]
    type = GamusinoHardeningConstant
    value = 10.0
    convert_to_radians = true
  [../]
  [./DP_dilation]
    type = GamusinoHardeningConstant
    value = 10.0
    convert_to_radians = true
  [../]
[]

[Postprocessors]
  [./u_x]
    type = SideAverageValue
    variable = disp_x
    boundary = right
    outputs = csv
  [../]
  [./S_xx]
    type = ElementAverageValue
    variable = stress_xx
    outputs = csv
  [../]
  [./E_xx]
    type = ElementAverageValue
    variable = strain_xx
    outputs = csv
  [../]
  [./Ep_xx]
    type = ElementAverageValue
    variable = plastic_strain_xx
    outputs = csv
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
  end_time = 200.0
  dt = 4.0
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  perf_graph = true
  exodus = true
  csv = true
[]
