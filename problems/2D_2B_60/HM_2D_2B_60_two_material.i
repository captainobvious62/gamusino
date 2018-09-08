[Mesh]
  type = FileMesh
  #uniform_refine = 1
  file = 60dipmodif_modified.exo
  dim = 2
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  pore_pressure = 'pore_pressure'
#  block = '1 2'
[]

[Variables]
  [pore_pressure]
    order = FIRST
    family = LAGRANGE
    block = '1 2'
  []
  [disp_x]
    order = FIRST
    family = LAGRANGE
    block = '1 2'  
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
    block = '1 2'
  []
[]

[Kernels]
  [HKernel]
    type = GamusinoKernelH
    variable = pore_pressure
    block = '1 2'
  []
  [MKernel_x]
    type = GamusinoKernelM
    variable = disp_x
    component = 0
    block = '1 2'
  []
  [MKernel_y]
    type = GamusinoKernelM
    variable = disp_y
    component = 1
    block = '1 2'
  []
  [HMKernel]
    type = GamusinoKernelHPoroElastic
    variable = pore_pressure
    block = '1 2'
  []
  [p_time]
    type = GamusinoKernelTimeH
    variable = pore_pressure
    block = '1 2'
  []
[]

[AuxVariables]
  [strain_xx]
    order = CONSTANT
    family = MONOMIAL
    block = '1 2'
  []
  [strain_xy]
    order = CONSTANT
    family = MONOMIAL
    block = '1 2'
  []
  [strain_yy]
    order = CONSTANT
    family = MONOMIAL
    block = '1 2'
  []
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
    block = '1 2'
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
    block = '1 2'
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
    block = '1 2'
  []
  [porosity]
    order = CONSTANT
    family = MONOMIAL
    block = '1 2'
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
    block = '1 2'
  []
  [strain_xy]
    type = GamusinoStrain
    variable = strain_xy
    index_i = 0
    index_j = 1
    block = '1 2'
  []
  [strain_yy]
    type = GamusinoStrain
    variable = strain_yy
    index_i = 1
    index_j = 1
    block = '1 2'
  []
  [stress_xx]
    type = GamusinoStress
    variable = stress_xx
    index_i = 0
    index_j = 0
    block = '1 2'
  []
  [stress_xy]
    type = GamusinoStress
    variable = stress_xy
    index_i = 0
    index_j = 1
    block = '1 2'
  []
  [stress_yy]
    type = GamusinoStress
    variable = stress_yy
    index_i = 1
    index_j = 1
    block = '1 2'
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
    boundary = 'left_top left_base'
    value = 0.0 # m
  []
  [roller_xmax]
    type = DirichletBC
    variable = disp_x
    boundary = 'right_top right_base'
    value = 0.0 # m
  []
  [roller_ymin]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0 # m
  []
  [roller_ymax]
    type = DirichletBC
    variable = disp_y
    boundary = 'surface'
    value = 0.0 # m
  []
#  [ymax_drained]
#    type = DirichletBC
#    variable = pore_pressure
#    boundary = 'surface'
#    value = 689475.73 # Pa ~ 100 psi
#  []
  [injection]
    type = DirichletBC
#    type = GamusinoPressureBC
    variable = pore_pressure
#    component = 0
    boundary = 'left_top'
#    scaling_uo = scaling
    value = 2068427.2 # Pa ~ 100 psi
  []

[]

[Materials]
  [HMMaterial_Top]
    block = 2
    type = GamusinoMaterialMElastic
    strain_model = incr_small_strain
    has_gravity = false
    gravity_acceleration = 9.81 # m/s**2
    solid_density_initial = 2500.0 # kg/m**3
    fluid_density_initial = 1000.0 # kg/m**3
    young_modulus = 10.0e+09 # Pa
    poisson_ratio = 0.2
    permeability_initial = '1.0e-15' # m**2
    fluid_viscosity_initial = 0.002 # Pa*s
    porosity_initial = 0.15
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    scaling_factor_initial = 1.0 # m
    scaling_uo = scaling
    permeability_uo = permeability
    solid_bulk_modulus = 0.7e8 # Pa
    fluid_modulus = 2.3e9 # Pa
  []

  [HMMaterial_Bottom]
    block = 1
    type = GamusinoMaterialMElastic
    strain_model = incr_small_strain
    has_gravity = false
    gravity_acceleration = 9.81 # m/s**2
    solid_density_initial = 3000.0 # kg/m**3
    fluid_density_initial = 1000.0 # kg/m**3
    young_modulus = 11.0e+09 # Pa
    poisson_ratio = 0.25
    permeability_initial = '1.0e-20' # m**2
    fluid_viscosity_initial = 0.002 # Pa*s
    porosity_initial = 0.05
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    scaling_factor_initial = 1.0 # m
    scaling_uo = scaling
    permeability_uo = permeability
    solid_bulk_modulus = 0.7e8 # Pa
    fluid_modulus = 2.3e9 # Pa
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
    characteristic_length = 1 # m
    characteristic_temperature = 1.0 # K
    characteristic_stress = 1E6 # Pa
  []
[]

[Preconditioning]
  inactive ='mine hypre' 
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
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      3              ilu            gmres     500'
  # very basic:
  # petsc_options_iname = '-pc_type -ksp_type -ksp_gmres_restart'
  # petsc_options_value = ' bjacobi  gmres     200'
  type = Transient
  solve_type = NEWTON
  petsc_options = '-snes_converged_reason'
  #petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  #petsc_options_value = ' lu       mumps'
  line_search = bt
  nl_abs_tol = 1e-3
  nl_rel_tol = 1e-5
  l_max_its = 200
  nl_max_its = 30
  start_time = 0.0
  end_time = 8640000 # sec
  dt = 86400 # sec
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
      coarsen = 0.1
      refine = 0.1
    []
  []
[]

