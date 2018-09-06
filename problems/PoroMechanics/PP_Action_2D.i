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
inactive = 'Postprocessors PorousFlowBasicTHM'
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
  PorousFlowDictator = 'Franco'
  block = '0'
  biot_coefficient = '0.9'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [porepressure]
    scaling = 1E-5
  []
[]

[Modules]
  [FluidProperties]
    [the_simple_fluid]
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
  inactive = 'noflow_xmin noflow_xmax'
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
[]

[Materials]
  [elasticity_tensor]
    # bulk modulus is lambda + 2*mu/3 = 1 + 2*1.5/3 = 2
    type = ComputeElasticityTensor
    C_ijkl = '1 1.5'
    fill_method = symmetric_isotropic
  []
  [strain]
    type = ComputeSmallStrain
  []
  [stress]
    type = ComputeLinearElasticStress
  []
  [porosity]
    type = PorousFlowPorosityConst
    PorousFlowDictator = Franco
    porosity = '0.1'
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1 0 0   0 1 0   0 0 1' # unimportant
  []
  [bulk_density]
    type = PorousFlowTotalGravitationalDensityFullySaturatedFromPorosity
    PorousFlowDictator = Franco
    rho_s = 2300 # kg/m**3
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
  dt = 1
  verbose = true
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
