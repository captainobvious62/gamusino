[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 10
  ny = 1
  nz = 1
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 0.1
  zmin = 0
  zmax = 1
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  pore_pressure = 'pore_pressure'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
  [pore_pressure]
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
  [MKernel_z]
    type = GamusinoKernelM
    variable = disp_z
    component = 2
  []
  [p_time]
    type = GamusinoKernelTimeH
    variable = pore_pressure
  []
  [HMKernel]
    type = GamusinoKernelHPoroElastic
    variable = pore_pressure
  []
[]

[Functions]
  [top_velocity]
    type = PiecewiseLinear
    x = '0 0.002 0.006   0.014   0.03    0.046   0.062   0.078   0.094   0.11    0.126   0.142   0.158   0.174   0.19 0.206 0.222 0.238 0.254 0.27 0.286 0.302 0.318 0.334 0.35 0.366 0.382 0.398 0.414 0.43 0.446 0.462 0.478 0.494 0.51 0.526 0.542 0.558 0.574 0.59 0.606 0.622 0.638 0.654 0.67 0.686 0.702'
    y = '-0.041824842    -0.042730269    -0.043412712    -0.04428867     -0.045509181    -0.04645965     -0.047268246 -0.047974749      -0.048597109     -0.0491467  -0.049632388     -0.050061697      -0.050441198     -0.050776675     -0.051073238      -0.0513354 -0.051567152      -0.051772022     -0.051953128 -0.052113227 -0.052254754 -0.052379865 -0.052490464 -0.052588233 -0.052674662 -0.052751065 -0.052818606 -0.052878312 -0.052931093 -0.052977751 -0.053018997 -0.053055459 -0.053087691 -0.053116185 -0.053141373 -0.05316364 -0.053183324 -0.053200724 -0.053216106 -0.053229704 -0.053241725 -0.053252351 -0.053261745 -0.053270049 -0.053277389 -0.053283879 -0.053289615'
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
  [tot_force]
    order = CONSTANT
    family = MONOMIAL
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
  [tot_force]
    type = ParsedAux
    args = 'stress_yy pore_pressure'
    execute_on = 'timestep_end'
    variable = tot_force
    function = '-stress_yy+0.6*pore_pressure'
  []
[]

[BCs]
  [roller_xmin]
    type = DirichletBC
    variable = disp_x
    boundary = 'left'
    value = 0.0 # m
  []
  [roller_ymin]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0 # m
  []
  [plane_strain]
    type = PresetBC
    variable = disp_z
    boundary = 'back front'
    value = 0
  []
  [xmax_drained]
    type = DirichletBC
    variable = pore_pressure
    boundary = 'right'
    value = 0.0 # Pa
  []
  [top_velocity]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 'top'
    function = top_velocity
  []
[]

[Materials]
  [HMMaterial]
    type = GamusinoMaterialMElastic
    block = '0'
    strain_model = incr_small_strain
    lame_modulus = 0.5
    shear_modulus = 0.75
    permeability_initial = '1.5e-03'
    fluid_viscosity_initial = 1.0e-03
    porosity_initial = 0.1
    solid_bulk_modulus = 2.5
    fluid_modulus = 8
    porosity_uo = porosity
    fluid_density_uo = fluid_density
    fluid_viscosity_uo = fluid_viscosity
    permeability_uo = permeability
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

[Postprocessors]
  [p0]
    type = PointValue
    outputs = 'csv'
    point = '0.0 0 0'
    variable = pore_pressure
  []
  [p1]
    type = PointValue
    outputs = 'csv'
    point = '0.1 0 0'
    variable = pore_pressure
  []
  [p2]
    type = PointValue
    outputs = 'csv'
    point = '0.2 0 0'
    variable = pore_pressure
  []
  [p3]
    type = PointValue
    outputs = 'csv'
    point = '0.3 0 0'
    variable = pore_pressure
  []
  [p4]
    type = PointValue
    outputs = 'csv'
    point = '0.4 0 0'
    variable = pore_pressure
  []
  [p5]
    type = PointValue
    outputs = 'csv'
    point = '0.5 0 0'
    variable = pore_pressure
  []
  [p6]
    type = PointValue
    outputs = 'csv'
    point = '0.6 0 0'
    variable = pore_pressure
  []
  [p7]
    type = PointValue
    outputs = 'csv'
    point = '0.7 0 0'
    variable = pore_pressure
  []
  [p8]
    type = PointValue
    outputs = 'csv'
    point = '0.8 0 0'
    variable = pore_pressure
  []
  [p9]
    type = PointValue
    outputs = 'csv'
    point = '0.9 0 0'
    variable = pore_pressure
  []
  [p99]
    type = PointValue
    outputs = 'csv'
    point = '1 0 0'
    variable = pore_pressure
  []
  [xdisp]
    type = PointValue
    outputs = 'csv'
    point = '1 0.1 0'
    variable = disp_x
  []
  [ydisp]
    type = PointValue
    outputs = 'csv'
    point = '1 0.1 0'
    variable = disp_y
  []
  [total_downwards_force]
    type = ElementAverageValue
    outputs = 'csv'
    variable = 'tot_force'
  []
  [dt]
    type = FunctionValuePostprocessor
    outputs = 'console'
    function = if(0.15*t<0.01,0.15*t,0.01)
  []
[]

[Preconditioning]
  inactive = 'precond hypre mine'
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
  [andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-14 1E-10 10000'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  start_time = 0
  end_time = 0.7
  [TimeStepper]
    type = PostprocessorDT
    postprocessor = dt
    dt = 0.001
  []
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  print_perf_log = true
  exodus = true
[]
