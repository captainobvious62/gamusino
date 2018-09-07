inactive = 'PorousFlowFullySaturated Postprocessors PorousFlowBasicTHM'
[Mesh]
  type = FileMesh
  uniform_refine = 2
  skip_partitioning = true
  file = ../MeshTest/60dipmodif_modified.exo
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  PorousFlowDictator = 'Pinochet'
  block = '1 2'
  biot_coefficient = '0.9'
  gravity = '0 0 0' # m/s**2
[]

[Variables]
  [disp_x]
    # displacement is in meters
  []
  [disp_y]
    # displacement is in meters
  []
  [porepressure]
    # Pressure is in pascals
  []
[]

[Modules]
  [FluidProperties]
    [simple_fluid]
      type = SimpleFluidProperties
      thermal_expansion = 0.0 # 1/K
      bulk_modulus = 2.2e9 # Pa
      viscosity = 0.002 # Pa*s
      density0 = 1000 # kg/m**3
      thermal_conductivity = 0.6 # W/m/K
      specific_entropy = 300 # J/kg/K
      cp = 4194 # J/kg/K
      cv = 4186 # J/kg/K
    []
  []
[]

[PorousFlowFullySaturated]
  coupling_type = HydroMechanical
  displacements = 'disp_x disp_y'
  porepressure = porepressure
  biot_coefficient = 0.9
  gravity = '0 -9.8 0' # m/s**2
  fp = the_simple_fluid
  dictator_name = Franco
[]

[BCs]
  inactive = 'drained_ymax'
  [roller_xmax]
    type = PresetBC
    variable = disp_x
    boundary = 'right_top right_base'
    value = 0
  []
  [roller_ymin]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0
  []
  [roller_xmin]
    type = PresetBC
    variable = disp_x
    boundary = 'left_top left_base'
    value = 0
  []
  [drained_ymax]
    type = PresetBC
    variable = porepressure
    boundary = 'surface'
    value = 0 # Pa
  []
  [noflow_xmin]
    type = DirichletBC
    variable = porepressure
    boundary = 'left_top left_base'
    value = 0
  []
  [noflow_xmax]
    type = DirichletBC
    variable = porepressure
    boundary = 'right_top right_base'
    value = 0
  []
  [noflow_ymin]
    type = DirichletBC
    variable = porepressure
    boundary = 'bottom'
    value = 0
  []
  [roller_ymax]
    type = PresetBC
    variable = disp_y
    boundary = 'surface'
    value = 0
  []
  [noflow_ymax]
    type = DirichletBC
    variable = porepressure
    boundary = 'surface'
    value = 0
  []
[]

[Kernels]
  inactive = 'gravity'
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
  [poro_x]
    type = PorousFlowEffectiveStressCoupling
    PorousFlowDictator = Pinochet
    component = 0
    variable = disp_x
    biot_coefficient = 0.9
  []
  [poro_y]
    type = PorousFlowEffectiveStressCoupling
    PorousFlowDictator = Pinochet
    component = 1
    variable = disp_y
    biot_coefficient = 0.9
  []
  [poro_vol_exp]
    type = PorousFlowMassVolumetricExpansion
    PorousFlowDictator = Pinochet
    variable = porepressure
  []
  [mass0]
    type = PorousFlowMassTimeDerivative
    PorousFlowDictator = Pinochet
    variable = porepressure
  []
  [flux]
    type = PorousFlowAdvectiveFlux
    PorousFlowDictator = Pinochet
    variable = porepressure
  []
  [gravity]
    type = Gravity
    value = 9.8 # m/s**2
    variable = disp_y
    function = -1
  []
[]

[Materials]
  [elasticity_tensor]
    # bulk modulus is lambda + 2*mu/3 = 1 + 2*1.5/3 = 2
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1E10 # Pa
    bulk_modulus = 7.7E8 # Pa
  []
  [strain]
    type = ComputeSmallStrain
  []
  [stress]
    type = ComputeLinearElasticStress
  []
  [porosity]
    type = PorousFlowPorosity
    PorousFlowDictator = Pinochet
    porosity_zero = '0.1'
    solid_bulk = 7E8
    fluid = true
    mechanical = true
    biot_coefficient = 0.9
  []
  [permeability]
    type = PorousFlowPermeabilityKozenyCarman
    PorousFlowDictator = Pinochet
    poroperm_function = kozeny_carman_phi0
    m = 2
    n = 2
    k0 = 1e-15 # m**2
    phi0 = 0.1 # frac
  []
  [bulk_density]
    type = PorousFlowTotalGravitationalDensityFullySaturatedFromPorosity
    PorousFlowDictator = Pinochet
    rho_s = 2600 # kg/m**3
  []
  [ppss]
    type = PorousFlow1PhaseFullySaturated
    PorousFlowDictator = Pinochet
    porepressure = 'porepressure'
  []
  [vol_strain]
    type = PorousFlowVolumetricStrain
    PorousFlowDictator = Pinochet
  []
  [eff_fluid_pressure]
    type = PorousFlowEffectiveFluidPressure
    PorousFlowDictator = Pinochet
  []
  [mass_frac]
    type = PorousFlowMassFraction
    PorousFlowDictator = Pinochet
  []
  [simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    PorousFlowDictator = Pinochet
    phase = 0
  []
  [relperm]
    type = PorousFlowRelativePermeabilityCorey
    PorousFlowDictator = Pinochet
    n = 0
    phase = 0
  []
  [temperature]
    type = PorousFlowTemperature
    PorousFlowDictator = Pinochet
  []
[]

[Postprocessors]
  [fluid_mass]
    type = PorousFlowFluidMass
    fluid_component = 0
    execute_on = 'initial timestep_end'
    use_displaced_mesh = true
  []
  [porosity]
    type = PointValue
    outputs = 'console csv'
    point = '0 0 0'
    variable = porosity
  []
  [p0]
    type = PointValue
    outputs = 'csv'
    point = '0 0 0'
    variable = porepressure
  []
  [porosity_analytic]
    type = FunctionValuePostprocessor
    function = porosity_analytic
  []
  [zdisp]
    type = PointValue
    outputs = 'csv'
    point = '0 0 0.5'
    variable = disp_z
  []
  [stress_xx]
    type = PointValue
    outputs = 'csv'
    point = '0 0 0'
    variable = stress_xx
  []
  [stress_yy]
    type = PointValue
    outputs = 'csv'
    point = '0 0 0'
    variable = stress_yy
  []
[]

[Preconditioning]
  inactive = 'andy Enhanced lu_test basic'
  [andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-14 1E-10 10000'
  []
  [Enhanced]
    type = SMP
    full = true
  []
  [precon]
    type = SMP
    petsc_options_value = 'gmres asm 1E-10 1E-10 200 500 lu NONZERO'
    petsc_options = '-snes_ksp_ew'
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
  []
  [lu_test]
    type = SMP
    petsc_options_value = 'gmres lu 1E-10 1E-10 200 500 lu NONZERO'
    petsc_options = '-snes_ksp_ew'
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
  []
  [basic]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0
  end_time = 1000
  dt = 1
  verbose = true
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-8
  line_search = bt
  l_max_its = 10000
  petsc_options = '-info -snes_monitor -ksp_monitor_true_residual -snes_converged_reason -dm_moose_print_embedding -ksp_converged_reason'
  nl_max_its = 500
  contact_line_search_allowed_lambda_cuts = 5
  nl_abs_step_tol = 1e-8
  l_tol = 1e-8
  nl_rel_step_tol = 1e-8
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = pp_generation_fullysat_action
  csv = true
  exodus = true
[]

[PorousFlowBasicTHM]
  porepressure = porepressure
  gravity = '0 0 -9.80'
  biot_coefficient = 0.9
  coupling_type = HydroMechanical
  dictator_name = Franco
  displacements = 'disp_x disp_y'
[]

[UserObjects]
  [Pinochet]
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
    family = MONOMIAL
    order = CONSTANT
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

[Adaptivity]
  initial_steps = 1
  recompute_markers_during_cycles = true
  marker = porepressure_grad_marker
  initial_marker = porepressure_grad_marker
  [Indicators]
    [porepressure_grad_indicator]
      type = GradientJumpIndicator
      variable = porepressure
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
