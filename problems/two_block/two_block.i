
[Mesh]
  type = FileMesh
  file = 2blockmesh.e
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  PorousFlowDictator = 'dictator'
  block = '0'
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'porepressure disp_x disp_y'
    number_fluid_phases = 1
    number_fluid_components = 1
  []
  [pc]
    type = PorousFlowCapillaryPressureVG
    m = 0.8
    alpha = 1
  []
[]

[Variables]
  [disp_x]
    block = 'crust mantle'
  []
  [disp_y]
    block = 'crust mantle'
  []
  [porepressure]
    block = 'crust mantle'
  []
[]

[BCs]
  [confinex]
    type = PresetBC
    variable = disp_x
    boundary = 'left right'
    value = 0 # m
  []
  [confiney]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0 # m
  []
  [topdrained]
    type = DirichletBC
    variable = porepressure
    boundary = 'top'
    value = 0
  []
  [topload]
    type = NeumannBC
    variable = disp_y
    boundary = 'top'
    value = -1
  []
[]

[Kernels]
  [grad_stress_x]
    type = StressDivergenceTensors
    variable = disp_x
    component = 0
  []
  [grad_stress_y]
    type = StressDivergenceTensors
    variable = disp_y
    component = 1
  []
  [poro_x]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.6
    variable = disp_x
    component = 0
  []
  [poro_y]
    type = PorousFlowEffectiveStressCoupling
    biot_coefficient = 0.6
    variable = disp_y
    component = 1
  []
  [poro_vol_exp]
    type = PorousFlowMassVolumetricExpansion
    variable = porepressure
    fluid_component = 0
  []
  [mass0]
    type = PorousFlowMassTimeDerivative
    fluid_component = 0
    variable = porepressure
  []
  [flux]
    type = PorousFlowAdvectiveFlux
    variable = porepressure
    gravity = '0 0 0' # m/s**2
    fluid_component = 0
  []
[]

[Modules]
  [FluidProperties]
    [simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 8
      density0 = 1
      thermal_expansion = 0
      viscosity = 0.96
    []
  []
[]

[Materials]
  # Crust
  # Mantle
  [temperature_crust]
    type = PorousFlowTemperature
    block = 'crust'
  []
  [temperature_nodal_crust]
    type = PorousFlowTemperature
    at_nodes = true
    block = 'crust'
  []
  [elasticity_tensor_crust]
    # bulk modulus is lambda + 2*mu/3 = 2 + 2*3/3 = 4
    type = ComputeElasticityTensor
    C_ijkl = '2 3'
    fill_method = symmetric_isotropic
    block = 'crust'
  []
  [strain_crust]
    type = ComputeSmallStrain
    block = 'crust'
  []
  [stress_crust]
    type = ComputeLinearElasticStress
    block = 'crust'
  []
  [eff_fluid_pressure_crust]
    type = PorousFlowEffectiveFluidPressure
    at_nodes = true
    block = 'crust'
  []
  [eff_fluid_pressure_qp_crust]
    type = PorousFlowEffectiveFluidPressure
    block = 'crust'
  []
  [vol_strain_crust]
    type = PorousFlowVolumetricStrain
    block = 'crust'
  []
  [ppss_crust]
    type = PorousFlow1PhaseP
    porepressure = 'porepressure'
    capillary_pressure = pc
    block = 'crust'
  []
  [ppss_nodal_crust]
    type = PorousFlow1PhaseP
    at_nodes = true
    porepressure = 'porepressure'
    capillary_pressure = pc
    block = 'crust'
  []
  [massfrac_crust]
    type = PorousFlowMassFraction
    at_nodes = true
    block = 'crust'
  []
  [simple_fluid_crust]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    at_nodes = true
    block = 'crust'
  []
  [simple_fluid_qp_crust]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    block = 'crust'
  []
  [relperm_crust]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = true
    n = 0 # unimportant in this fully-saturated situation
    phase = 0
    block = 'crust'
  []
  [porosity_crust]
    type = PorousFlowPorosity
    fluid = true
    mechanical = true
    ensure_positive = false
    at_nodes = true
    porosity_zero = '0.1'
    biot_coefficient = 0.6
    solid_bulk = 4
    block = 'crust'
  []
  [permeability_crust]
    type = PorousFlowPermeabilityConst
    permeability = '1.5 0 0   0 1.5 0   0 0 1.5'
    block = 'crust'
  []
  [temperature_mantle]
    type = PorousFlowTemperature
    block = 'mantle'
  []
  [temperature_nodal_mantle]
    type = PorousFlowTemperature
    at_nodes = true
    block = 'mantle'
  []
  [elasticity_tensor_mantle]
    # bulk modulus is lambda + 2*mu/3 = 2 + 2*3/3 = 4
    type = ComputeElasticityTensor
    C_ijkl = '2 3'
    fill_method = symmetric_isotropic
    block = 'mantle'
  []
  [strain_mantle]
    type = ComputeSmallStrain
    block = 'mantle'
  []
  [stress_mantle]
    type = ComputeLinearElasticStress
    block = 'mantle'
  []
  [eff_fluid_pressure_mantle]
    type = PorousFlowEffectiveFluidPressure
    at_nodes = true
    block = 'mantle'
  []
  [eff_fluid_pressure_qp_mantle]
    type = PorousFlowEffectiveFluidPressure
    block = 'mantle'
  []
  [vol_strain_mantle]
    type = PorousFlowVolumetricStrain
    block = 'mantle'
  []
  [ppss_mantle]
    type = PorousFlow1PhaseP
    porepressure = 'porepressure'
    capillary_pressure = pc
    block = 'mantle'
  []
  [ppss_nodal_mantle]
    type = PorousFlow1PhaseP
    at_nodes = true
    porepressure = 'porepressure'
    capillary_pressure = pc
    block = 'mantle'
  []
  [massfrac_mantle]
    type = PorousFlowMassFraction
    at_nodes = true
    block = 'mantle'
  []
  [simple_fluid_mantle]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    at_nodes = true
    block = 'mantle'
  []
  [simple_fluid_qp_mantle]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    block = 'mantle'
  []
  [relperm_mantle]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = true
    n = 0 # unimportant in this fully-saturated situation
    phase = 0
    block = 'mantle'
  []
  [porosity_mantle]
    type = PorousFlowPorosity
    fluid = true
    mechanical = true
    ensure_positive = false
    at_nodes = true
    porosity_zero = '0.1'
    biot_coefficient = 0.6
    solid_bulk = 4
    block = 'mantle'
  []
  [permeability_mantle]
    type = PorousFlowPermeabilityConst
    permeability = '1.5 0 0   0 1.5 0   0 0 1.5'
    block = 'mantle'
  []
[]

[Postprocessors]
  [dt]
    type = FunctionValuePostprocessor
    outputs = 'console'
    function = if(0.5*t<0.1,0.5*t,0.1)
  []
[]

[Preconditioning]
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
  end_time = 10
  [TimeStepper]
    type = PostprocessorDT
    postprocessor = dt
    dt = 0.0001
  []
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = two_block
  [csv]
    type = CSV
  []
[]
