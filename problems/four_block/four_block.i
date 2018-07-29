[Mesh]
  type = FileMesh
  file = mesh.exo
  dim = 2
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
    boundary = 'bottom'
    value = 0.0 # m
  []
  [ymax_drained]
    type = DirichletBC
    variable = pore_pressure
    boundary = 'top'
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
  [concrust]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 0.002
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.25
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1.0e-13'
    young_modulus = 10.0e+09
    porosity_initial = 0.09
    fluid_density_uo = fluid_density
    solid_density_initial = 2300
    block = 'concrust'
  []
  [oceancrust]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 0.002
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.25
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1.0e-12'
    young_modulus = 10.0e+09
    porosity_initial = 0.12
    fluid_density_uo = fluid_density
    solid_density_initial = 2600
    block = 'oceancrust'
  []
  [conmantle]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 0.002
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.25
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1.0e-15'
    young_modulus = 10.0e+09
    porosity_initial = 0.08
    fluid_density_uo = fluid_density
    solid_density_initial = 4000
    block = 'conmantle'
  []
  [oceanmantle]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.80
    fluid_viscosity_initial = 0.002
    has_gravity = true
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1019.368
    poisson_ratio = 0.25
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1.0e-15'
    young_modulus = 10.0e+09
    porosity_initial = 0.08
    fluid_density_uo = fluid_density
    solid_density_initial = 5000
    block = 'oceanmantle'
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
    characteristic_length = 1.0
    characteristic_stress = 1.0e+06
    characteristic_time = 1.0
    characteristic_temperature = 1.0
  []
[]

[Preconditioning]
  inactive = 'precond hypre'
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
  end_time = 50000
  dt = 5000
  petsc_options = '-dm_moose_print_embedding'
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
      refine = 0.75
    []
  []
[]
