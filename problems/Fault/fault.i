inactive = 'Contact'
[GlobalParams]
  block = '2'
  displacements = 'disp_x disp_y'
[]

[Mesh]
  type = FileMesh
  file = 2D_60_F_MS.exo
  dim = 2
[]

[Variables]
  [disp_x]
    order = FIRST
    family = LAGRANGE
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
  [stress_xx]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_yy]
    order = CONSTANT
    family = MONOMIAL
  []
  [stress_xy]
    order = CONSTANT
    family = MONOMIAL
  []
  [elastic_energy]
    family = MONOMIAL
    order = CONSTANT
  []
  [von_mises]
    family = MONOMIAL
    order = CONSTANT
  []
  [hydrostatic]
    family = MONOMIAL
    order = CONSTANT
  []
  [first_inv]
    family = MONOMIAL
    order = CONSTANT
  []
  [second_inv]
    family = MONOMIAL
    order = CONSTANT
  []
  [third_inv]
    family = MONOMIAL
    order = CONSTANT
  []
  [max_principal]
    family = MONOMIAL
    order = CONSTANT
  []
  [min_principal]
    family = MONOMIAL
    order = CONSTANT
  []
  [direction]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Kernels]
  [TensorMechanics]
    use_displaced_mesh = true
    displacements = 'disp_x disp_y'
  []
  [Gravity]
    type = Gravity
    value = 9.81
    variable = disp_y
  []
[]

[AuxKernels]
  [stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
    execute_on = 'timestep_end'
  []
  [stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
    execute_on = 'timestep_end'
  []
  [stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
    execute_on = 'timestep_end'
  []
  [elastic_energy]
    type = ElasticEnergyAux
    variable = elastic_energy
  []
  [von_mises]
    type = RankTwoScalarAux
    scalar_type = VonMisesStress
    rank_two_tensor = stress
    variable = von_mises
  []
  [hydrostatic]
    type = RankTwoScalarAux
    scalar_type = Hydrostatic
    rank_two_tensor = stress
    variable = hydrostatic
  []
  [fi]
    type = RankTwoScalarAux
    scalar_type = FirstInvariant
    rank_two_tensor = stress
    variable = first_inv
  []
  [si]
    type = RankTwoScalarAux
    scalar_type = SecondInvariant
    rank_two_tensor = stress
    variable = second_inv
  []
  [ti]
    type = RankTwoScalarAux
    scalar_type = ThirdInvariant
    rank_two_tensor = stress
    variable = third_inv
  []
  [maxprincipal]
    type = RankTwoScalarAux
    scalar_type = MaxPrincipal
    rank_two_tensor = stress
    variable = max_principal
  []
  [minprincipal]
    type = RankTwoScalarAux
    scalar_type = MinPrincipal
    rank_two_tensor = stress
    variable = min_principal
  []
  [direction]
    type = RankTwoScalarAux
    scalar_type = Direction
    rank_two_tensor = stress
    variable = direction
  []
[]

[BCs]
  [roller_xmin]
    type = DirichletBC
    variable = disp_x
    boundary = 'left'
    value = 0.0
  []
  [roller_ymin]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  []
  [roller_xmax]
    type = DirichletBC
    variable = disp_x
    boundary = 'right'
    value = 0.0
  []
  [fault_traction_master_x]
    type = NeumannBC
    variable = disp_x
    boundary = 'fault_master'
    value = 5
  []
  [fault_traction_master_y]
    type = NeumannBC
    variable = disp_y
    boundary = 'fault_master'
    value = 5
  []
[]

[Materials]
  [Elasticity_tensor]
    type = ComputeElasticityTensor
    block = '2'
    fill_method = symmetric_isotropic
    C_ijkl = '0 0.5e6'
  []
  [strain]
    type = ComputeSmallStrain
    block = '2'
    displacements = 'disp_x disp_y'
  []
  [stress]
    type = ComputeLinearElasticStress
    block = '2'
  []
  [density]
    type = GenericConstantMaterial
    block = '2'
    prop_names = 'density'
    prop_values = '2.0387'
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
  solve_type = PJFNK
  start_time = 0.0
  end_time = 50000
  dt = 5000
  petsc_options = '-dm_moose_print_embedding'
[]

[Outputs]
  exodus = true
  print_perf_log = true
[]

[Contact]
  [frictional_fault]
    slave = fault_slave
    disp_y = disp_y
    disp_x = disp_x
    displacements = 'disp_x disp_y'
    master = fault_master
  []
[]
