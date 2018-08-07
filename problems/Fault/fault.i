#
# Pressure Test
#
# This test is designed to apply a gravity body force.
#
# The mesh is composed of one block with a single element.
# The bottom is fixed in all three directions.  Poisson's ratio
# is zero and the density is 20/9.81
# which makes it trivial to check displacements.
#
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

[Kernels]
  [TensorMechanics]
    displacements = 'disp_x disp_y'
  []
  [Gravity]
    type = Gravity
    value = 9.81
    variable = disp_y
  []
[]

[AuxVariables]
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
[]
[AuxKernels]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
    execute_on = timestep_end
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
    execute_on = timestep_end
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
    execute_on = timestep_end
  [../]
[]

[BCs]
  [no_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'bottom'
    value = 0.0
  []
  [no_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
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
  type = Steady
  solve_type = PJFNK
  nl_abs_tol = 1e-10
  l_max_its = 20
[]

[Outputs]
  [out]
    type = Exodus
    elemental_as_nodal = true
  []
[]

[Contact]
  [./fault]
    slave = fault_slave
    master = fault_master
    system = constraint
    model = coulomb
    formulation = penalty
    normalize_penalty = true
    friction_coefficient = 0.8
    penalty = 1e+9
  [../]
[]
