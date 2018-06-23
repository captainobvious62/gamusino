# Darcy flow
inactive = 'DiracKernels'
[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 30
  ny = 30
  xmin = 0
  xmax = 50 # metres
  ymin = 0
  ymax = 50 # metres
  parallel_type = DISTRIBUTED
[]

[GlobalParams]
  # displacements = 'disp_x disp_y'
  PorousFlowDictator = 'dictator'
  block = '0'
  biot_coefficient = '0.8'
  displacements = 'disp_x disp_y'
[]

[Variables]
  [porepressure]
    scaling = 1E-6
  []
  [disp_x]
  []
  [disp_y]
    inactive = 'InitialCondition'
    [InitialCondition]
      type = BimodalInverseSuperellipsoidsIC
    []
  []
[]

[PorousFlowBasicTHM]
  porepressure = porepressure
  coupling_type = HydroMechanical
  gravity = '0 -9.8E-6  0' # m / s**2
  fp = the_simple_fluid
  displacements = 'disp_x disp_y'
  multiply_by_density = true
[]

[Modules]
  [FluidProperties]
    [the_simple_fluid]
      type = SimpleFluidProperties
      bulk_modulus = 2E9 # Pa
      viscosity = 1.0E-3 # Pa * s
      density0 = 1000.0 # kg / m**3
    []
  []
[]

[Materials]
  [porosity]
    type = PorousFlowPorosity
    porosity_zero = '0.1' # frac
  []
  [biot_modulus]
    type = PorousFlowConstantBiotModulus
    biot_coefficient = 0.8
    solid_bulk_compliance = 2E-7 # 1/Pa
    fluid_bulk_modulus = 1E7 # Pa
  []
  [permeability]
    type = PorousFlowPermeabilityConst
    block = '0'
    permeability = '1E-14 0 0   0 1E-14 0   0 0 1E-14' # m**2
  []
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 5E9 # Pa
    poissons_ratio = 0.25
  []
  [strain]
    type = ComputeSmallStrain
  []
  [stress]
    type = ComputeLinearElasticStress
  []
  [Bulk_Density]
    type = PorousFlowTotalGravitationalDensityFullySaturatedFromPorosity
    rho_s = 2300.0 # kg / m**3
  []
[]

[Preconditioning]
  inactive = 'preferred_but_might_not_be_installed'
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 2
  dt = 1
  nl_abs_tol = 1E-10
  nl_max_its = 300
  steady_state_detection = true
[]

[Outputs]
  exodus = true
  interval = 1
[]

[BCs]
  [Free_Surface]
    type = PresetBC
    variable = porepressure
    boundary = 'top'
    value = 0 # Pa
  []
  [roller_y]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0
  []
  [roller_x]
    type = PresetBC
    variable = disp_x
    boundary = 'left right'
    value = 0 # metres
  []
  [Ambient_Pressure]
    type = NeumannBC
    variable = disp_y
    boundary = 'top'
    value = -101325E-6
  []
[]

[DiracKernels]
  inactive = 'PointPressure'
  [PointPressure]
    type = PorousFlowSquarePulsePointSource
    point = '25 25 0 '
    start_time = 1
    mass_flux = 1
    variable = porepressure
  []
[]
