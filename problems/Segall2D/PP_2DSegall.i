[Mesh]
  type = FileMesh
  file = Segall2D.exo
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  PorousFlowDictator = 'Pinochet'
  biot_coefficient = '0.9'
  gravity = '0 -9.8 0' # m/s**2
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

[BCs]
  [roller_xmax]
    type = PresetBC
    variable = disp_x
    boundary = 'BasementEast FormationEast MudrockEast'
    value = 0
  []
  [roller_ymin]
    type = PresetBC
    variable = disp_y
    boundary = 'Floor'
    value = 0
  []
  [roller_xmin]
    type = PresetBC
    variable = disp_x
    boundary = 'MudrockWest FormationWest BasementWest'
    value = 0
  []
  [drained_ymax]
    type = PresetBC
    variable = porepressure
    boundary = 'Surface'
    value = 0 # Pa
  []
[]

[Kernels]
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
    function = 1
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
  end_time = 864000.0
  dt = 21900
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
