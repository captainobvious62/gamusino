# Isotropic Poroelasticity with Gravity - Elastic Material
inactive = 'XFEM'
[Mesh]
  type = GeneratedMesh
  displacements = 'disp_x disp_y'
  dim = 2
  nx = 25
  ny = 25
  ymin = 0.0
  ymax = 100 # m
  xmin = 0.0
  xmax = 100 # m
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
  inactive = 'p_time'
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
  [p_time]
    type = GamusinoKernelTimeH
    variable = pore_pressure
  []
  [HPKernel]
    type = GamusinoKernelHPoroElastic
    variable = pore_pressure
    displacements = 'disp_x disp_y'
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
    order = FIRST
    family = LAGRANGE
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
  inactive = 'roller_xmin roller_xmax noflow_xmin noflow_xmax'
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
  [HMMaterial]
    type = GamusinoMaterialMElastic
    block = '0'
    strain_model = incr_small_strain
    has_gravity = true
    gravity_acceleration = 9.81
    solid_density_initial = 3058.104
    fluid_density_initial = 1019.368
    young_modulus = 10.0e+09
    poisson_ratio = 0.25
    permeability_initial = '1.0e-10'
    fluid_viscosity_initial = 1.0e-03
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    permeability_uo = permeability
    porosity_initial = 0.08
  []
[]

[UserObjects]
  inactive = 'Fault'
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
    type = GamusinoPermeabilityKC
  []
  [Fault]
    type = LineSegmentCutUserObject
    cut_data = '38 50 67 75'
  []
[]

[Preconditioning]
  inactive = 'precond mine'
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
  solve_type = Newton
  start_time = 0.0
  end_time = 2
  dt = 1
  num_steps = 2
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  print_perf_log = true
  exodus = true
[]

[XFEM]
  crack_growth_increment = 0.0
  output_cut_plane = true
[]
