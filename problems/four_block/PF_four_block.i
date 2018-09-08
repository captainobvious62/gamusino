[Mesh]
  type = FileMesh
  file = mesh.exo
  dim = 2
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  pore_pressure = 'pore_pressure'
  biot_coefficient = '0.9'
[]

[Variables]
  [pore_pressure]
    order = FIRST
    family = LAGRANGE
  []
  [disp_x]
    order = FIRST
    family = LAGRANGE
    scaling = 1E-5
  []
  [disp_y]
    order = FIRST
    family = LAGRANGE
    scaling = 1E-5
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
    PorousFlowDictator = Franco
    component = 0
    variable = disp_x
  []
  [poro_y]
    type = PorousFlowEffectiveStressCoupling
    PorousFlowDictator = Franco
    component = 1
    variable = disp_y
  []
  [flux]
    type = PorousFlowFullySaturatedDarcyFlow
    PorousFlowDictator = Franco
    gravity = '0 -9.81 0 '
    variable = pore_pressure
  []
  [mass0]
    type = PorousFlowFullySaturatedMassTimeDerivative
    PorousFlowDictator = Franco
    coupling_type = HydroMechanical
    variable = pore_pressure
  []
  [gravity_y]
    type = Gravity
    value = -9.81
    variable = disp_y
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
[]

[AuxKernels]
  inactive = 'permeability porosity'
  [permeability]
    type = MaterialRealVectorValueAux
    variable = permeability
    property = PorousFlow_permeability_qp
  []
  [porosity]
    type = MaterialRealAux
    variable = permeability
    property = PorousFlow_porosity_qp
  []
[]

[BCs]
  inactive = 'noflow_xmin noflow_xmax noflow_ymin'
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
  [Injection]
    type = PorousFlowSink
    variable = pore_pressure
    boundary = 'fault'
    flux_function = -1e-2
    PorousFlowDictator = Franco
    fluid_phase = 0
  []
[]

[Materials]
  [porosity]
    type = PorousFlowPorosity
    PorousFlowDictator = Franco
    porosity_zero = '0.1'
    at_nodes = true
    solid_bulk = 0.7e9
    fluid = true
    mechanical = true
  []
  [permeability]
    type = PorousFlowPermeabilityKozenyCarman
    PorousFlowDictator = Franco
    poroperm_function = kozeny_carman_phi0
    m = 2
    n = 3
    k0 = 1e-13
    phi0 = 0.1
  []
  [drained_elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 10E9
    poissons_ratio = 0.2
  []
  [strain]
    type = ComputeSmallStrain
  []
  [stress]
    type = ComputeLinearElasticStress
  []
  [bulk_density]
    type = PorousFlowTotalGravitationalDensityFullySaturatedFromPorosity
    PorousFlowDictator = Franco
    rho_s = 2300
  []
  [volumetric_strain]
    type = PorousFlowVolumetricStrain
    PorousFlowDictator = Franco
  []
  [mass_frac]
    type = PorousFlowMassFraction
    PorousFlowDictator = Franco
  []
  [eff_fluid_pressure]
    type = PorousFlowEffectiveFluidPressure
    PorousFlowDictator = Franco
  []
  [ppss]
    type = PorousFlow1PhaseFullySaturated
    PorousFlowDictator = Franco
    porepressure = 'pore_pressure'
  []
  [pore_fluid]
    type = PorousFlowSingleComponentFluid
    fp = pore_fluid
    PorousFlowDictator = Franco
    phase = 0
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    PorousFlowDictator = Franco
  []
  [temperature]
    type = PorousFlowTemperature
    PorousFlowDictator = Franco
  []
  [porosity_for_aux]
    type = PorousFlowPorosity
    PorousFlowDictator = Franco
    porosity_zero = '0.1'
    solid_bulk = 0.7e9
    fluid = true
    mechanical = true
  []
  [eff_fluid_pressure_nodal]
    type = PorousFlowEffectiveFluidPressure
    at_nodes = true
    PorousFlowDictator = Franco
  []
  [ppss_nodal]
    type = PorousFlow1PhaseFullySaturated
    at_nodes = true
    PorousFlowDictator = Franco
    porepressure = 'pore_pressure'
  []
[]

[UserObjects]
  [Franco]
    type = PorousFlowDictator
    porous_flow_vars = 'pore_pressure disp_x disp_y'
    number_fluid_phases = 1
    number_fluid_components = 1
  []
[]

[Preconditioning]
  inactive = 'hypre mine'
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
  solve_type = NEWTON
  start_time = 0.0
  end_time = 50000
  dt = 5000
  petsc_options = '-dm_moose_print_embedding'
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  print_perf_log = true
  exodus = true
  gnuplot = true
[]

[Adaptivity]
  initial_steps = 1
  recompute_markers_during_cycles = true
  marker = porepressure_marker
  initial_marker = porepressure_marker
  [Indicators]
    [porepressure_gradient]
      type = GradientJumpIndicator
      variable = pore_pressure
    []
  []
  [Markers]
    [porepressure_marker]
      type = ErrorFractionMarker
      indicator = porepressure_gradient
      coarsen = 0.25
      refine = 0.75
    []
  []
[]

[Modules]
  [FluidProperties]
    [pore_fluid]
      type = SimpleFluidProperties
    []
  []
[]

[Constraints]
  [New_0]
    type = CoupledTiedValueConstraint
  []
[]
