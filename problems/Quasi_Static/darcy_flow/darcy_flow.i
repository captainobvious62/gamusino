# Checking that gravity head is established
# 1phase, constant and large fluid-bulk, constant viscosity, constant permeability
# fully saturated with fully-saturated Kernel
# For better agreement with the analytical solution (ana_pp), just increase nx
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 45
  ny = 45
  xmin = 0
  xmax = 1000
  ymin = 0
  ymax = 500
  zmax = 0
[]

[GlobalParams]
  PorousFlowDictator = 'dictator'
[]

[Variables]
  [porepressure]
  []
[]

[Kernels]
  [flux0]
    type = PorousFlowFullySaturatedDarcyBase
    variable = porepressure
    gravity = '0 -9.8 0'
  []
[]

[Functions]
  [ana_pp]
    type = ParsedFunction
    vars = 'g B p0 rho0'
    vals = '1 1E3 0 1'
    value = '-B*log(exp(-p0/B)+g*rho0*x/B)' # expected pp at base
  []
[]

[BCs]
  inactive = 'FreeSurface'
  [constant_injection_porepressure]
    type = PresetBC
    variable = porepressure
    boundary = 'left'
    value = 1E6
  []
  [constant_outer_porepressure]
    type = PresetBC
    variable = porepressure
    boundary = 'right'
    value = 0
  []
  [FreeSurface]
    type = PresetBC
    variable = porepressure
    boundary = 'top'
    value = 0
  []
  [DepthSurface]
    type = PresetBC
    variable = porepressure
    boundary = 'top'
    value = 1E6 # Pa
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'porepressure'
    number_fluid_phases = 1
    number_fluid_components = 1
  []
[]

[Modules]
  [FluidProperties]
    [simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 2E9
      density0 = 1000.0
      viscosity = 1.0E-3
      thermal_expansion = 0
    []
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
  []
  [ppss_qp]
    type = PorousFlow1PhaseFullySaturated
    porepressure = 'porepressure'
  []
  [massfrac]
    type = PorousFlowMassFraction
  []
  [simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  []
  [porosity_qp]
    type = PorousFlowPorosity
    porosity_zero = '0.1'
  []
  [porosity]
    type = PorousFlowPorosity
    porosity_zero = '0.1'
    at_nodes = true
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1E-14 0 0   0 1E-14 0   0 0 1E-14'
  []
[]

[Postprocessors]
  [pp_base]
    type = PointValue
    variable = porepressure
    point = '1 0 0'
  []
[]

[Preconditioning]
  inactive = 'check'
  [andy]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-15 1E-10 10000'
  []
  [check]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -snes_type'
    petsc_options_value = 'bcgs bjacobi 1E-15 1E-10 10000 test'
  []
[]

[Executioner]
  type = Steady
  solve_type = Newton
[]

[Outputs]
  execute_on = 'timestep_end'
  file_base = darcy_flow
  exodus = true
  [csv]
    type = CSV
  []
[]
