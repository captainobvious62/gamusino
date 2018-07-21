[Mesh]
  type = FileMesh
  file = 2blockmesh.e
[]


[GlobalParams]
  displacements = 'disp_x disp_y'
#  pore_pressure = pore_pressure
[]

[Variables]
#  [./pore_pressure]
#    order = FIRST
#    family = LAGRANGE
#  [../]
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
#  [./HKernel]
#    type = GamusinoKernelH
#    variable = pore_pressure
#  [../]
  [./MKernel_x]
    type = GamusinoKernelM
    variable = disp_x
    use_displaced_mesh = true    
    component = 0
  [../]
  [./MKernel_y]
    type = GamusinoKernelM
    variable = disp_y
    use_displaced_mesh = true
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
  [./penetration]
  [../]
  [./inc_slip_x]
  [../]
  [./inc_slip_y]
  [../]
  [./accum_slip_x]
  [../]
  [./accum_slip_y]
  [../]
  [./tang_force_x]
  [../]
  [./tang_force_y]
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
  [./inc_slip_x]
    type = PenetrationAux
    variable = inc_slip_x
    execute_on = timestep_end
    boundary = 'fault_HW'
    paired_boundary = 'fault_FW'
  [../]
  [./inc_slip_y]
    type = PenetrationAux
    variable = inc_slip_y
    execute_on = timestep_end
    boundary = 'fault_HW'
    paired_boundary = 'fault_FW'
  [../]
  [./accum_slip_x]
    type = PenetrationAux
    variable = accum_slip_x
    execute_on = timestep_end
    boundary = 'fault_HW'
    paired_boundary = 'fault_FW'
  [../]
  [./accum_slip_y]
    type = PenetrationAux
    variable = accum_slip_y
    execute_on = timestep_end
    boundary = 'fault_HW'
    paired_boundary = 'fault_FW'
  [../]
  [./penetration]
    type = PenetrationAux
    variable = penetration
    boundary = 'fault_HW'
    paired_boundary = 'fault_FW'
  [../]
  [./tang_force_x]
    type = PenetrationAux
    variable = tang_force_x
    quantity = tangential_force_x
    boundary = 'fault_HW'
    paired_boundary = 'fault_FW'
  [../]
  [./tang_force_y]
    type = PenetrationAux
    variable = tang_force_y
    quantity = tangential_force_y
    boundary = 'fault_HW'
    paired_boundary = 'fault_FW'
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
  [./HMMaterial_crust]
    type = GamusinoMaterialMElastic
    block = 'crust'
    strain_model = incr_small_strain
    young_modulus = 10.0e+09
    poisson_ratio = 0.25
    has_gravity = true
    solid_density_initial = 3058.104
    fluid_density_initial = 1019.368
    gravity_acceleration = 0.0 # 9.81
    permeability_initial = 1.0e-11
    fluid_viscosity_initial = 1.0e-03
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    permeability_uo = permeability
  [../]
  [./HMMaterial_mantle]
    type = GamusinoMaterialMElastic
    block = 'mantle'
    strain_model = incr_small_strain
    young_modulus = 10.0e+09
    poisson_ratio = 0.25
    has_gravity = true
    solid_density_initial = 3058.104
    fluid_density_initial = 1019.368
    gravity_acceleration = 0.0 #9.81
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
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu     superlu_dist'

  line_search = 'none'

  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-6
  l_max_its = 100
  nl_max_its = 1000
  dt = 1.0
  end_time = 1.0
  num_steps = 10
  dtmin = 1.0
  l_tol = 1e-4
[]


[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  print_perf_log = true
  exodus = true
[]

[Contact]
  [./fault]
    slave = 6
    master = 7
    model = coulomb
    system = constraint
    friction_coefficient = '0.25'
    penalty = 1e6
  [../]
[]

[Dampers]
  [./contact_slip]
    type = ContactSlipDamper
    slave = 6
    master = 7
  [../]
[]
