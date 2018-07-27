# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
# ==============================================================================
[Mesh]
  type = GeneratedMesh
  displacements = 'disp_x disp_y'
  dim = 2
  nx = 25
  ny = 25
  nz = 0
  zmax = 0
  ymax = 100 # m
  xmax = 100 # m
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  PorousFlowDictator = 'Franco'
  block = '0'
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
  [porepressure]
  []
[]

[Kernels]
  [Gravity]
    type = Gravity
    value = -9.80 # m/s**2
    variable = disp_y
  []
  [poro_x]
    type = PoroMechanicsCoupling
    component = 0
    porepressure = 'porepressure'
    variable = disp_x
  []
  [poro_y]
    type = PoroMechanicsCoupling
    component = 1
    porepressure = 'porepressure'
    variable = disp_y
  []
  [flux]
    type = PorousFlowAdvectiveFlux
    variable = porepressure
    gravity = '0 -9.8 0' # m / s**2
    fluid_component = 0
  []
  [grad_stress_x]
    type = StressDivergenceTensors
    component = 0
    variable = disp_x
  []
  [grad_stress_y]
    type = StressDivergenceTensors
    component = 1
    variable = disp_y
  []
  [poro_vol_exp]
    type = PorousFlowMassVolumetricExpansion
    PorousFlowDictator = Franco
    variable = porepressure
  []
  [P_time_deriv]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = porepressure
  []
[]

[BCs]
  inactive = 'roller_xmin roller_xmax'
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
    variable = porepressure
    boundary = 'top'
    value = 0.0 # Pa
  []
  [noflow_xmin]
    type = NeumannBC
    variable = porepressure
    boundary = 'left'
    value = 0.0
  []
  [noflow_xmax]
    type = NeumannBC
    variable = porepressure
    boundary = 'right'
    value = 0.0
  []
  [noflow_ymin]
    type = NeumannBC
    variable = porepressure
    boundary = 'bottom'
    value = 0
  []
[]

[Modules]
  [FluidProperties]
    [simple_fluid]
      type = SimpleFluidProperties
      density0 = 999.526 # kg / m**3
      bulk_modulus = 2E9 # Pa
      viscosity = 0.001 # Pa * s
      cv = 4180
      thermal_expansion = 0.0
    []
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
  []
  [temperature_nodal]
    type = PorousFlowTemperature
    at_nodes = true
  []
  [elasticity_tensor]
    type = ComputeElasticityTensor
    C_ijkl = '8.65E9 5.77E9' # young = 15GPa, poisson = 0.3
    fill_method = symmetric_isotropic
  []
  [strain]
    type = ComputeSmallStrain
    block = '0'
    displacements = 'disp_x disp_y'
  []
  [stress]
    type = ComputeLinearElasticStress
    block = '0'
  []
  [eff_fluid_pressure]
    type = PorousFlowEffectiveFluidPressure
  []
  [eff_fluid_pressure_nodal]
    type = PorousFlowEffectiveFluidPressure
    at_nodes = true
  []
  [density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = '2386.0' # = (1-0.9)*2540 + 0.1*999.526
  []
  [biot_coefficient]
    type = GenericConstantMaterial
    prop_values = '0.9'
    prop_names = 'biot_coefficient'
  []
  [vol_strain]
    type = PorousFlowVolumetricStrain
  []
  [ppss]
    type = PorousFlow1PhaseFullySaturated
    porepressure = 'porepressure'
  []
  [ppss_nodal]
    type = PorousFlow1PhaseFullySaturated
    at_nodes = true
    porepressure = 'porepressure'
  []
  [massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  []
  [simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    at_nodes = true
  []
  [simple_fluid_qp]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  []
  [dens_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_density_nodal
  []
  [dens_all_at_quadpoints]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
    at_nodes = false
  []
  [visc_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_viscosity_nodal
  []
  [porosity]
    type = PorousFlowPorosity
    fluid = true
    mechanical = true
    at_nodes = true
    porosity_zero = '0.1'
    biot_coefficient = 0.9
    solid_bulk = 2E9
  []
  [porosity_qp]
    type = PorousFlowPorosity
    fluid = true
    mechanical = true
    porosity_zero = '0.1'
    biot_coefficient = 0.9
    solid_bulk = 2E9
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1.0E-12 0 0   0 1.0E-12 0   0 0 1.0E-12' # m**2
  []
  [relperm]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = true
    n = 0 # unimportant in this fully-saturated situation
    phase = 0
  []
  [relperm_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_relative_permeability_nodal
  []
[]

[Executioner]
  type = Transient
  nl_abs_tol = 1e-10
  l_max_its = 20
  dt = 86400.0 # sec
  solve_type = PJFNK
  num_steps = 10
  nl_max_its = 500
[]

[Preconditioning]
  inactive = 'superlu sub_pc_superlu'
  [original]
    type = SMP
    full = true
    petsc_options = '-snes_monitor -snes_linesearch_monitor'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1E0 1E-10 200 500 lu NONZERO'
  []
  [superlu]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-ksp_type -pc_type -pc_factor_mat_solver_package'
    petsc_options_value = 'gmres lu superlu_dist'
  []
  [sub_pc_superlu]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-ksp_type -pc_type -sub_pc_type -sub_pc_factor_shift_type -sub_pc_factor_mat_solver_package'
    petsc_options_value = 'gmres asm lu NONZERO superlu_dist'
  []
[]

[Outputs]
  [out]
    type = Exodus
    elemental_as_nodal = true
  []
[]

[UserObjects]
  [Franco]
    type = PorousFlowDictator
    porous_flow_vars = 'porepressure disp_x disp_y'
    number_fluid_phases = 1
    number_fluid_components = 1
  []
[]

[AuxVariables]
  [stress_xx]
    family = MONOMIAL
    order = CONSTANT
  []
  [stress_xy]
    family = MONOMIAL
    order = CONSTANT
  []
  [stress_yy]
    family = MONOMIAL
    order = CONSTANT
  []
  [porosity]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    index_j = 0
    index_i = 0
    variable = stress_xx
  []
  [stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    index_j = 1
    index_i = 0
    variable = stress_xy
  []
  [stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    index_j = 1
    index_i = 1
    variable = stress_yy
  []
  [porosity]
    type = MaterialRealAux
    variable = porosity
    property = PorousFlow_porosity_qp
  []
[]
