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
  type = GeneratedMesh
  displacements = 'disp_x disp_y'
  dim = 2
  nx = 10
  ny = 10
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
  inactive = 'TensorMechanics Gravity'
  [TensorMechanics]
    displacements = 'disp_x disp_y'
  []
  [Gravity]
    type = Gravity
    value = 9.80 # m/s**2
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
    gravity = '0 0 0'
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
  [ymax_drained]
    type = DirichletBC
    variable = porepressure
    boundary = 'top'
    value = 0
  []
[]

[Modules]
  [./FluidProperties]
    [./simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 13
      density0 = 1
      thermal_expansion = 0
    [../]
  [../]
[]

[Materials]
  [./temperature]
    type = PorousFlowTemperature
  [../]
  [./temperature_nodal]
    type = PorousFlowTemperature
    at_nodes = true
  [../]
  [Elasticity_tensor]
    type = ComputeElasticityTensor
    block = '0'
    fill_method = symmetric_isotropic
    C_ijkl = '0 0.5e6'
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
  [./eff_fluid_pressure]
    type = PorousFlowEffectiveFluidPressure
  [../]
  [./eff_fluid_pressure_nodal]
    type = PorousFlowEffectiveFluidPressure
    at_nodes = true
  [../]
  [density]
    type = GenericConstantMaterial
    block = '0'
    prop_names = 'density'
    prop_values = '2.0387'
  []
  [biot_coefficient]
    type = GenericConstantMaterial
    prop_values = '0.9'
    prop_names = 'biot_coefficient'
  []
 [./vol_strain]
    type = PorousFlowVolumetricStrain
  [../]
  [./ppss]
    type = PorousFlow1PhaseFullySaturated
    porepressure = porepressure
  [../]
  [./ppss_nodal]
    type = PorousFlow1PhaseFullySaturated
    at_nodes = true
    porepressure = porepressure
  [../]
  [./massfrac]
    type = PorousFlowMassFraction
    at_nodes = true
  [../]
  [./simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
    at_nodes = true
  [../]
  [./simple_fluid_qp]
    type = PorousFlowSingleComponentFluid
    fp = simple_fluid
    phase = 0
  [../]
  [./dens_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_fluid_phase_density_nodal
  [../]
  [./dens_all_at_quadpoints]
    type = PorousFlowJoiner
    material_property = PorousFlow_fluid_phase_density_qp
    at_nodes = false
  [../]
  [./visc_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_viscosity_nodal
  [../]
  [./porosity]
    type = PorousFlowPorosity
    fluid = true
    mechanical = true
    at_nodes = true
    porosity_zero = 0.1
    biot_coefficient = 0.9
    solid_bulk = 2
  [../]
  [./porosity_qp]
    type = PorousFlowPorosity
    fluid = true
    mechanical = true
    porosity_zero = 0.1
    biot_coefficient = 0.9
    solid_bulk = 2
  [../]
  [./permeability]
    type = PorousFlowPermeabilityConst
    permeability = '1 0 0   0 1 0   0 0 1' # unimportant
  [../]
  [./relperm]
    type = PorousFlowRelativePermeabilityCorey
    at_nodes = true
    n = 0 # unimportant in this fully-saturated situation
    phase = 0
  [../]
  [./relperm_all]
    type = PorousFlowJoiner
    at_nodes = true
    material_property = PorousFlow_relative_permeability_nodal
  [../]
[]

[Executioner]
  type = Transient
  nl_abs_tol = 1e-10
  l_max_its = 20
  dt = 0.1
  solve_type = PJFNK
  end_time = 1
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
  [./porosity]
    order = CONSTANT
    family = MONOMIAL
  [../]
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
  [./porosity]
    type = MaterialRealAux
    variable = porosity
    property = PorousFlow_porosity_qp
  [../]
[]
