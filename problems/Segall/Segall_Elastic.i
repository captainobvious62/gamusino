[Mesh]
  type = FileMesh
  construct_side_list_from_node_list = true
  file = Segall2D.exo
  dim = 2
  construct_node_list_from_side_list = false
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
  inactive = 'permeability'
  [strain_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [strain_yy]
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
  [fluid_viscosity]
    family = MONOMIAL
    order = CONSTANT
  []
  [fluid_density]
    family = MONOMIAL
    order = CONSTANT
  []
  [permeability]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  inactive = 'permeability'
  [strain_xx]
    type = GamusinoStrain
    variable = strain_xx
    index_i = 0
    index_j = 0
  []
  [strain_xy]
    type = GamusinoStrain
    variable = strain_xy
    index_i = 0
    index_j = 1
  []
  [strain_yy]
    type = GamusinoStrain
    variable = strain_yy
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
  [porosity]
    type = MaterialRealAux
    variable = porosity
    property = porosity
  []
  [fluid_viscosity]
    type = MaterialRealAux
    variable = fluid_viscosity
    property = fluid_viscosity
  []
  [fluid_density]
    type = MaterialRealAux
    variable = fluid_density
    property = fluid_density
  []
  [permeability]
    type = MaterialRealAux
    variable = permeability
    property = permeability
  []
[]

[BCs]
  [roller_xmin]
    type = DirichletBC
    variable = disp_x
    boundary = 'BasementWest FormationWest MudrockWest'
    value = 0.0 # m
  []
  [roller_xmax]
    type = DirichletBC
    variable = disp_x
    boundary = 'BasementEast FormationEast MudrockEast'
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
    boundary = 'BasementWest FormationWest MudrockWest'
    value = 0.0
  []
  [noflow_xmax]
    type = NeumannBC
    variable = pore_pressure
    boundary = 'BasementEast FormationEast MudrockEast'
    value = 0.0
  []
  [noflow_ymin]
    type = NeumannBC
    variable = pore_pressure
    boundary = 'Floor'
    value = 0
  []
[]

[Materials]
  [Mudrock]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 1e-3
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.3
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1e-19'
    porosity_initial = 0.10
    fluid_density_uo = fluid_density
    solid_density_initial = 2600
    block = 'mudrock'
    shear_modulus = 11.5e9
    scaling_uo = scaling
    young_modulus = 27.6e9
  []
  [Formation]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 1e-3
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.15
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '6.4e-14'
    porosity_initial = 0.25
    fluid_density_uo = fluid_density
    solid_density_initial = 2500
    block = 'formation'
    shear_modulus = 7.6e9
    scaling_uo = scaling
    young_modulus = 18.24e9
  []
  [Fault_Zone]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 1e-3
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.2
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1e-21'
    porosity_initial = 0.02
    fluid_density_uo = fluid_density
    solid_density_initial = 2500
    block = 'FZ1 FZ2 FZ3'
    shear_modulus = 6e9
    scaling_uo = scaling
    young_modulus = 14.4e9
  []
  [Basement]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 1e-3
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.2
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '2e-17'
    porosity_initial = 0.05
    fluid_density_uo = fluid_density
    solid_density_initial = 2740
    block = 'WestBasement EastBasement'
    shear_modulus = 25e9
    scaling_uo = scaling
    young_modulus = 6e10
  []
[]

[UserObjects]
  [porosity]
    type = GamusinoPorosityTHM
  []
  [fluid_density]
    type = GamusinoFluidDensityIAPWS
  []
  [fluid_viscosity]
    type = GamusinoFluidViscosityIAPWS
  []
  [permeability]
    type = GamusinoPermeabilityKC
  []
  [scaling]
    type = GamusinoScaling
    characteristic_length = 1000
    characteristic_stress = 1.0e+06
    characteristic_time = 1.0
    characteristic_temperature = 1.0
  []
[]

[Preconditioning]
  inactive = 'hypre mine'
  [precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1E-10 1E-10 200 500 lu NONZERO'
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
  solve_type = NEWTON
  start_time = 0.0
  end_time = 10
  dt = 1
  petsc_options = '-dm_moose_print_embedding'
  verbose = true
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  print_perf_log = true
  exodus = true
[]

[Adaptivity]
  initial_steps = 1
  recompute_markers_during_cycles = true
  marker = porepressure_marker
  initial_marker = porepressure_marker
  start_time = 0
  [Indicators]
    [porepressure_gradient]
      type = GradientJumpIndicator
      variable = pore_pressure
    []
  []
  [Markers]
    [porepressure_marker]
      type = ErrorFractionMarker
      indicator = porepressure_gradient
      coarsen = 0.25
      refine = 0.25
    []
  []
[]
