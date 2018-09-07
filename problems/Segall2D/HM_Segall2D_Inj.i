[Mesh]
  type = FileMesh
  file = Segall2D.exo
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
  [HMKernel]
    type = GamusinoKernelHPoroElastic
    variable = pore_pressure
  []
  [p_time]
    type = GamusinoKernelTimeH
    variable = pore_pressure
  []
[]

[AuxVariables]
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
[]

[AuxKernels]
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
[]

[BCs]
  [roller_xmin]
    type = DirichletBC
    variable = disp_x
    boundary = 'MudrockWest FormationWest BasementWest'
    value = 0.0 # m
  []
  [roller_xmax]
    type = DirichletBC
    variable = disp_x
    boundary = 'MudrockEast FormationEast BasementEast'
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
  [FormationSourceP]
    type = FunctionPresetBC
    variable = pore_pressure
    boundary = 'FormationWest'
    function = 'if(t<=6*3600*24,101325-z*9800+30E6*t/6.0/3600.0/24.0,101325-z*9800)'
  []
[]

[Materials]
  [Basement]
    type = GamusinoMaterialMElastic
    block = 'EastBasement WestBasement'
    strain_model = incr_small_strain
    has_gravity = true
    gravity_acceleration = 9.81 # m/s**2
    solid_density_initial = 3000.0 # kg/m**3
    fluid_density_initial = 1000.0 # kg/m**3
    young_modulus = 10.0e+09 # Pa
    poisson_ratio = 0.25
    permeability_initial = '1.0e-20' # m**2
    fluid_viscosity_initial = 0.002 # Pa*s
    porosity_initial = 0.01
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    scaling_factor_initial = 1.0 # m
    scaling_uo = scaling
    permeability_uo = permeability
    solid_bulk_modulus = 0.7e8 # Pa
    fluid_modulus = 2.3e9 # Pa
  []
  [Mudstone]
    type = GamusinoMaterialMElastic
    block = 'mudrock'
    strain_model = incr_small_strain
    has_gravity = true
    gravity_acceleration = 9.81 # m/s**2
    solid_density_initial = 2650.0 # kg/m**3
    fluid_density_initial = 1000.0 # kg/m**3
    young_modulus = 10.0e+09 # Pa
    poisson_ratio = 0.25
    permeability_initial = '1.0e-20' # m**2
    fluid_viscosity_initial = 3e-4 # Pa*s
    porosity_initial = 0.01
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    scaling_factor_initial = 1.0 # m
    scaling_uo = scaling
    permeability_uo = permeability
    solid_bulk_modulus = 0.7e8 # Pa
    fluid_modulus = 1e8 # Pa
  []
  [Formation]
    type = GamusinoMaterialMElastic
    block = 'formation'
    strain_model = incr_small_strain
    has_gravity = true
    gravity_acceleration = 9.81 # m/s**2
    solid_density_initial = 2650.0 # kg/m**3
    fluid_density_initial = 1000.0 # kg/m**3
    young_modulus = 10.0e+09 # Pa
    poisson_ratio = 0.25
    permeability_initial = '1.28e-15' # m**2
    fluid_viscosity_initial = 0.002 # Pa*s
    porosity_initial = 0.15
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    scaling_factor_initial = 1.0 # m
    scaling_uo = scaling
    permeability_uo = permeability
    solid_bulk_modulus = 0.7e8 # Pa
    fluid_modulus = 1.5e9 # Pa
  []
  [FZ1]
    type = GamusinoMaterialMElastic
    block = 'FZ1'
    strain_model = incr_small_strain
    has_gravity = true
    gravity_acceleration = 9.81 # m/s**2
    solid_density_initial = 2600.0 # kg/m**3
    fluid_density_initial = 1000.0 # kg/m**3
    young_modulus = 10.0e+09 # Pa
    poisson_ratio = 0.25
    permeability_initial = '1.0e-15' # m**2
    fluid_viscosity_initial = 0.002 # Pa*s
    porosity_initial = 0.10
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    scaling_factor_initial = 1.0 # m
    scaling_uo = scaling
    permeability_uo = permeability
    solid_bulk_modulus = 0.7e8 # Pa
    fluid_modulus = 2.3e9 # Pa
  []
  [FZ2]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.81
    scaling_uo = scaling
    fluid_viscosity_initial = 0.002
    has_gravity = true
    solid_bulk_modulus = 0.7e8
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1000.0
    scaling_factor_initial = 1.0
    poisson_ratio = 0.25
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1.0e-15'
    young_modulus = 10.0e+09
    porosity_initial = 0.10
    fluid_modulus = 2.3e9
    fluid_density_uo = fluid_density
    solid_density_initial = 2600.0
    block = 'FZ2'
  []
  [FZ3]
    type = GamusinoMaterialMElastic
    gravity_acceleration = 9.81
    scaling_uo = scaling
    fluid_viscosity_initial = 0.002
    has_gravity = true
    solid_bulk_modulus = 0.7e8
    fluid_viscosity_uo = fluid_viscosity
    strain_model = incr_small_strain
    fluid_density_initial = 1000.0
    scaling_factor_initial = 1.0
    poisson_ratio = 0.25
    porosity_uo = porosity
    permeability_uo = permeability
    permeability_initial = '1.0e-15'
    young_modulus = 10.0e+09
    porosity_initial = 0.10
    fluid_modulus = 2.3e9
    fluid_density_uo = fluid_density
    solid_density_initial = 2600.0
    block = 'FZ3'
  []
[]

[UserObjects]
  [porosity]
    type = GamusinoPorosityConstant
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
  [scaling]
    type = GamusinoScaling
    characteristic_time = 1.0 # sec
    characteristic_length = 1.0 # m
    characteristic_temperature = 1.0 # K
    characteristic_stress = 1e6 # Pa
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
    petsc_options_value = 'hypre boomeramg cp 201 1E1 1E-06 500'
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
  # best overall
  # best if you don't have mumps:
  # petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = ' asm      2              lu            gmres     200'
  # very basic:
  # petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = ' bjacobi  gmres     200'
  type = Transient
  solve_type = NEWTON
  petsc_options = '-snes_converged_reason'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = ' lu       mumps'
  line_search = bt
  nl_abs_tol = 1e-3
  nl_rel_tol = 1e-5
  l_max_its = 200
  nl_max_its = 30
  start_time = 0.0
  end_time = 8640000 # sec
  dt = 21000 # sec
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
  marker = porepressure_grad_marker
  initial_marker = porepressure_grad_marker
  [Indicators]
    [porepressure_grad_indicator]
      type = GradientJumpIndicator
      variable = pore_pressure
    []
  []
  [Markers]
    [porepressure_grad_marker]
      type = ErrorFractionMarker
      indicator = porepressure_grad_indicator
      coarsen = 0.2
      refine = 0.1
    []
  []
[]
