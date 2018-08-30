[Mesh]
  type = GeneratedMesh
  zmax = 0
  ymax = 10
  nx = 50
  ny = 50
  nz = 0
  dim = 2
  xmax = 10
[]

[GlobalParams]
  block = '0'
  displacements = 'disp_x disp_y'
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
[]

[Kernels]
  inactive = 'TensorMechanics DynamicTensorMechanics'
  [TensorMechanics]
    displacements = 'disp_x disp_y'
  []
  [DynamicTensorMechanics]
  []
  [MKernel_x]
    type = GamusinoKernelM
    component = 0
    variable = disp_x
  []
  [MKernel_y]
    type = GamusinoKernelM
    component = 1
    variable = disp_y
  []
[]

[BCs]
  [xmin_xzero]
    type = PresetBC
    variable = disp_x
    boundary = 'left'
    value = 0
  []
  [ymin_yzero]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0
  []
  [ymax_disp]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 'top'
    function = -1E-4*t
  []
  [xmax_disp]
    type = FunctionPresetBC
    variable = disp_x
    boundary = 'right'
    function = -1E-2*t*(1-y)
  []
[]

[AuxVariables]
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
  [mc_int]
    order = CONSTANT
    family = MONOMIAL
  []
  [yield_fcn]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [stress_xx]
    type = GamusinoStress
    index_j = 0
    index_i = 0
    variable = stress_xx
  []
  [stress_xy]
    type = GamusinoStress
    index_j = 1
    index_i = 0
    variable = stress_xy
  []
  [stress_yy]
    type = GamusinoStress
    index_j = 1
    index_i = 1
    variable = stress_yy
  []
  [mc_int_auxk]
    type = MaterialStdVectorAux
    index = 0
    property = plastic_internal_parameter
    variable = mc_int
  []
  [yield_fcn_auxk]
    type = MaterialStdVectorAux
    index = 0
    property = plastic_yield_function
    variable = yield_fcn
  []
[]

[UserObjects]
  inactive = 'mc_coh mc_phi mc_psi mc'
  [mc_coh]
    type = TensorMechanicsHardeningConstant
    value = 10E6
  []
  [mc_phi]
    type = TensorMechanicsHardeningConstant
    value = 2
    convert_to_radians = true
  []
  [mc_psi]
    type = TensorMechanicsHardeningConstant
    value = 2
    convert_to_radians = true
  []
  [mc]
    type = TensorMechanicsPlasticMohrCoulomb
    cohesion = mc_coh
    friction_angle = mc_phi
    dilation_angle = mc_psi
    mc_tip_smoother = 0.01E6
    mc_edge_smoother = 29
    yield_function_tolerance = 1E-5
    internal_constraint_tolerance = 1E-11
  []
  [dp_coh]
    type = GamusinoHardeningConstant
    value = 10e6
  []
  [dp_phi]
    type = GamusinoHardeningConstant
    convert_to_radians = true
    value = 2
  []
  [dp_psi]
    type = GamusinoHardeningConstant
    convert_to_radians = true
    value = 2
  []
  [porosity]
    type = GamusinoPorosityTHM
  []
  [fluid_viscosity]
    type = GamusinoFluidViscosityConstant
  []
  [fluid_density]
    type = GamusinoFluidDensityConstant
  []
  [permeability]
    type = GamusinoPermeabilityConstant
  []
[]

[Materials]
  [MMaterial]
    type = GamusinoMaterialMInelastic
    inelastic_models = 'gDP'
    strain_model = incr_small_strain
    poisson_ratio = 0.0
    young_modulus = 1e9
  []
  [gDP]
    type = GamusinoDruckerPrager
    yield_function_tol = 1e-5
    smoother = 0.01e6
    MC_friction = dp_phi
    MC_dilation = dp_psi
    MC_cohesion = dp_coh
  []
[]

[Preconditioning]
  [andy]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  end_time = 5.0
  dt = 0.1
  solve_type = NEWTON
  l_tol = 1E-2
  nl_abs_tol = 1E-5
  nl_rel_tol = 1E-7
  l_max_its = 200
  nl_max_its = 400
  petsc_options_iname = '-pc_type -pc_asm_overlap -sub_pc_type -ksp_type -ksp_gmres_restart'
  petsc_options_value = ' asm      2              lu            gmres     200'
[]

[Outputs]
  file_base = uni_axial2
  exodus = true
  [csv]
    type = CSV
  []
[]
