# Isotropic Poroelasticity with Gravity - Inelastic Material
[Mesh]
  # nz = 0
  # zmax = 0
  type = FileMesh
  displacements = 'disp_x disp_y'
  file = ../Segall/Segall2D.exo
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  pore_pressure = 'pore_pressure'
[]

[Variables]
  [pore_pressure]
    order = FIRST
    family = LAGRANGE
  []
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
  [HKernel]
    type = GamusinoKernelH
    variable = pore_pressure
  []
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
  [HKernel_PoroElastic]
    type = GamusinoKernelHPoroElastic
    variable = pore_pressure
  []
[]

[AuxVariables]
  [strain_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [plastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [plastic_strain_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [plastic_strain_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [porosity]
    order = CONSTANT
    family = MONOMIAL
  []
  [yield]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [strain_xx]
    type = GamusinoStrain
    variable = strain_xx
    index_i = 0
    index_j = 0
  []
  [plastic_strain_xx]
    type = GamusinoStrain
    strain_type = plastic
    variable = plastic_strain_xx
    index_i = 0
    index_j = 0
  []
  [strain_xy]
    type = GamusinoStrain
    variable = strain_xy
    index_i = 0
    index_j = 1
  []
  [plastic_strain_xy]
    type = GamusinoStrain
    strain_type = plastic
    variable = plastic_strain_xy
    index_i = 0
    index_j = 1
  []
  [strain_yy]
    type = GamusinoStrain
    variable = strain_yy
    index_i = 1
    index_j = 1
  []
  [plastic_strain_yy]
    type = GamusinoStrain
    strain_type = plastic
    variable = plastic_strain_yy
    index_i = 1
    index_j = 1
  []
  [stress_xx]
    type = GamusinoStress
    variable = stress_xx
    index_i = 0
    index_j = 0
  []
  [stress_xy]
    type = GamusinoStress
    variable = stress_xy
    index_i = 0
    index_j = 1
  []
  [stress_yy]
    type = GamusinoStress
    variable = stress_yy
    index_i = 1
    index_j = 1
  []
  [yield]
    type = MaterialRealAux
    variable = yield
    property = plastic_yield_function
  []
[]

[BCs]
  inactive = 'roller_xmin roller_xmax noflow_xmin noflow_xmax noflow_ymin'
  [roller_xmin]
    type = DirichletBC
    variable = disp_x
    boundary = 'left'
    value = 0.0 # m
  []
  [roller_xmax]
    type = DirichletBC
    variable = disp_x
    boundary = 'right'
    value = 0.0 # m
  []
  [roller_ymin]
    type = DirichletBC
    variable = disp_y
    boundary = 'Floor'
    value = 0.0 # m
  []
  [ymax_drained]
    type = DirichletBC
    variable = pore_pressure
    boundary = 'Surface'
    value = 0.0 # Pa
  []
  [noflow_xmin]
    type = NeumannBC
    variable = pore_pressure
    boundary = 'left'
    value = 0.0
  []
  [noflow_xmax]
    type = NeumannBC
    variable = pore_pressure
    boundary = 'right'
    value = 0.0
  []
  [noflow_ymin]
    type = NeumannBC
    variable = pore_pressure
    boundary = 'bottom'
    value = 0
  []
[]

[Materials]
  [DP]
    type = GamusinoDruckerPrager
    MC_cohesion = DP_cohesion
    MC_friction = DP_friction
    MC_dilation = DP_dilation
    yield_function_tol = 1.0e-08
    min_step_size = 0.01
  []
  [HMMaterial]
    type = GamusinoMaterialMInelastic
    gravity_acceleration = 9.81
    fluid_viscosity_initial = 1.0e-03
    has_gravity = true
    compute = true
    fluid_viscosity_uo = fluid_viscosity
    inelastic_models = 'DP'
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    solid_density_initial = 2600
    poisson_ratio = 0.2
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '9.8e-14'
    young_modulus = 10.0e+09
    fluid_density_uo = fluid_density
    scaling_uo = scaling
    solid_bulk_modulus = 0.7e9
    shear_modulus = 0.4e9
    fluid_modulus = 2.2e9
    porosity_initial = 0.15
  []
[]

[UserObjects]
  [scaling]
    type = GamusinoScaling
    characteristic_length = 1.0
    characteristic_stress = 1.0e+06
    characteristic_time = 1.0
    characteristic_temperature = 1.0
  []
  [porosity]
    type = GamusinoPorosityTHM
  []
  [fluid_density]
    type = GamusinoFluidDensityConstant
  []
  [fluid_viscosity]
    type = GamusinoFluidViscosityConstant
  []
  [permeability]
    type = GamusinoPermeabilityConstant
  []
  [DP_cohesion]
    type = GamusinoHardeningConstant
    value = 1.0
  []
  [DP_friction]
    type = GamusinoHardeningConstant
    value = 10.0
    convert_to_radians = true
  []
  [DP_dilation]
    type = GamusinoHardeningConstant
    value = 10.0
    convert_to_radians = true
  []
[]

[Preconditioning]
  inactive = 'precond mine'
  [precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres lu 1E-10 1E-10 200 500 lu NONZERO'
  []
  [hypre]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew -snes_view -ksp_converged_reason'
    petsc_options_iname = '-pc_type -pc_hypre_type -snes_linesearch_type -ksp_gmres_restart -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'hypre boomeramg cp 501 1E1 1E-06 1000'
  []
  [mine]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew -snes_monitor -snes_linesearch_monitor -snes_converged_reason -ksp_converged_reason -ksp_monitor_short'
    petsc_options_iname = '-ksp_type
                           -pc_type -sub_pc_type -sub_pc_factor_levels
                           -ksp_rtol -ksp_max_it
                           -snes_type -snes_linesearch_type
                           -snes_atol -snes_max_it' # -snes_atol -snes_stol -snes_max_it'
    petsc_options_value = 'fgmres asm ilu 1 1.0e-12 500 newtonls cp 1.0e-02 1000'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0.0
  end_time = 20000.0
  dt = 60.0
  verbose = true
  petsc_options = '-dm_moose_print_embedding'
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  perf_graph = true
  exodus = true
  csv = true
[]
