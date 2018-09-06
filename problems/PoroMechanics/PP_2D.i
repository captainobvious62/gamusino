# Same as pp_generation.i, but using an Action
#
# A sample is constrained on all sides and its boundaries are
# also impermeable.  Fluid is pumped into the sample via a
# volumetric source (ie kg/second per cubic meter), and the
# rise in porepressure is observed.
#
# Source = s  (units = kg/m^3/second)
#
# Expect:
# fluid_mass = mass0 + s*t
# stress = 0 (remember this is effective stress)
# Porepressure = fluid_bulk*log(fluid_mass_density/density_P0), where fluid_mass_density = fluid_mass*porosity
# porosity = biot+(phi0-biot)*exp(pp(biot-1)/solid_bulk)
#
# Parameters:
# Biot coefficient = 0.3
# Phi0 = 0.1
# Solid Bulk modulus = 2
# fluid_bulk = 13
# density_P0 = 1
inactive = 'PorousFlowFullySaturated Postprocessors PorousFlowBasicTHM'
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 50
  ny = 50
  nz = 1
  xmin = 0
  xmax = 100
  ymin = 0
  ymax = 100
  zmin = 0
  zmax = 1.0
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  PorousFlowDictator = 'Pinochet'
  block = '0'
  biot_coefficient = '0.9'
  gravity = '0 9.8 0' # m/s**2
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
    scaling = 1E5
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
  [roller_xmax]
    type = PresetBC
    variable = disp_x
    boundary = 'right'
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
    boundary = 'left'
    value = 0
  []
  [drained_ymax]
    type = PresetBC
    variable = porepressure
    boundary = 'top'
    value = 0 # Pa
  []
  [noflow_xmin]
    type = DirichletBC
    variable = porepressure
    boundary = 'left'
    value = 0
  []
  [noflow_xmax]
    type = DirichletBC
    variable = porepressure
    boundary = 'right'
    value = 0
  []
  [noflow_ymin]
    type = DirichletBC
    variable = porepressure
    boundary = 'bottom'
    value = 0
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
    k0 = 1e-15
    phi0 = 0.02
  []
  [bulk_density]
    type = PorousFlowTotalGravitationalDensityFullySaturatedFromPorosity
    PorousFlowDictator = Pinochet
    rho_s = 2300 # kg/m**3
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
  inactive = 'andy Enhanced'
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
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0
  end_time = 10
  dt = 1
  verbose = true
  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-5
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  line_search = bt
  l_max_its = 200
  petsc_options_value = 'lu mumps'
  petsc_options = '-snes_converged_reason'
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
