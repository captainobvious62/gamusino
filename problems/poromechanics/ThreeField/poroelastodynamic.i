# [Mesh]
# type = FileMesh
# file = mesh.msh
# block_id = '8'
# block_name = 'domain'
# boundary_id = '9 10 11 12 13'
# boundary_name = 'bottom right topright topleft left'
# []
[Mesh]
  type = GeneratedMesh
  block_id = '0'
  block_name = 'domain'
  dim = 2
  nx = 40
  ny = 40
  xmin = 0
  xmax = 10
  ymin = 0
  ymax = 10
  elem_type = QUAD8
[]

[Variables]
  [u_x]
    order = SECOND
    family = LAGRANGE
  []
  [u_y]
    order = SECOND
    family = LAGRANGE
  []
  [w_x]
    order = SECOND
    family = LAGRANGE
  []
  [w_y]
    order = SECOND
    family = LAGRANGE
  []
  [p]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
  [v_x]
    order = SECOND
    family = LAGRANGE
  []
  [v_y]
    order = SECOND
    family = LAGRANGE
  []
  [a_x]
    order = SECOND
    family = LAGRANGE
  []
  [a_y]
    order = SECOND
    family = LAGRANGE
  []
  [af_x]
    order = SECOND
    family = LAGRANGE
  []
  [af_y]
    order = SECOND
    family = LAGRANGE
  []
[]

[Kernels]
  inactive = 'DynamicTensorMechanics'
  [stressdiv_x]
    # use_displaced_mesh = false
    type = StressDivergenceTensors
    variable = u_x
    component = 0
    displacements = 'u_x u_y'
  []
  [stressdiv_y]
    # use_displaced_mesh = false
    type = StressDivergenceTensors
    variable = u_y
    component = 1
    displacements = 'u_x u_y'
  []
  [skeletoninertia_x]
    type = InertialForce
    variable = u_x
    velocity = 'v_x'
    acceleration = 'a_x'
    beta = 0.25
    gamma = 0.5
    use_displaced_mesh = false
  []
  [skeletoninertia_y]
    type = InertialForce
    variable = u_y
    velocity = 'v_y'
    acceleration = 'a_y'
    beta = 0.25
    gamma = 0.5
    use_displaced_mesh = false
  []
  [porefluidIFcoupling_x]
    type = PoreFluidInertialForceCoupling
    variable = u_x
    fluidaccel = 'af_x'
    darcyvel = 'w_x'
    gamma = 0.5
  []
  [porefluidIFcoupling_y]
    type = PoreFluidInertialForceCoupling
    variable = u_y
    fluidaccel = 'af_y'
    darcyvel = 'w_y'
    gamma = 0.5
  []
  [darcyflow_x]
    type = DynamicDarcyFlow
    variable = w_x
    skeletondisp = 'u_x'
    skeletonvel = 'v_x'
    skeletonaccel = 'a_x'
    fluidaccel = 'af_x'
    gravity = 9.81
    beta = 0.25
    gamma = 0.5
  []
  [darcyflow_y]
    type = DynamicDarcyFlow
    variable = w_y
    skeletondisp = 'u_y'
    skeletonvel = 'v_y'
    skeletonaccel = 'a_y'
    fluidaccel = 'af_y'
    gravity = 9.81
    beta = 0.25
    gamma = 0.5
  []
  [poromechskeletoncoupling_x]
    type = PoroMechanicsCoupling
    variable = u_x
    porepressure = 'p'
    component = 0
  []
  [poromechskeletoncoupling_y]
    type = PoroMechanicsCoupling
    variable = u_y
    porepressure = 'p'
    component = 1
  []
  [poromechfluidcoupling_x]
    type = PoroMechanicsCoupling
    variable = w_x
    porepressure = 'p'
    component = 0
  []
  [poromechfluidcoupling_y]
    type = PoroMechanicsCoupling
    variable = w_y
    porepressure = 'p'
    component = 1
  []
  [massconservationskeleton]
    type = MassConservationNewmark
    variable = p
    displacements = 'u_x u_y'
    velocities = 'v_x v_y'
    accelerations = 'a_x a_y'
    beta = 0.25
    gamma = 0.5
  []
  [massconservationfluid]
    type = INSMass
    variable = p
    u = 'w_x'
    v = 'w_y'
    p = 'p'
    x_vel_forcing_func = bc_func
    rho_name = rhof
  []
  [DynamicTensorMechanics]
  []
[]

[AuxKernels]
  [accel_x]
    type = NewmarkAccelAux
    variable = a_x
    displacement = 'u_x'
    velocity = 'v_x'
    beta = 0.25
    execute_on = 'timestep_end'
  []
  [accel_y]
    type = NewmarkAccelAux
    variable = a_y
    displacement = 'u_y'
    velocity = 'v_y'
    beta = 0.25
    execute_on = 'timestep_end'
  []
  [vel_x]
    type = NewmarkVelAux
    variable = v_x
    acceleration = 'a_x'
    gamma = 0.5
    execute_on = 'timestep_end'
  []
  [vel_y]
    type = NewmarkVelAux
    variable = v_y
    acceleration = 'a_y'
    gamma = 0.5
    execute_on = 'timestep_end'
  []
  [fluidaccel_x]
    type = NewmarkPoreFluidAccelAux
    variable = af_x
    darcyvel = 'w_x'
    gamma = 0.5
    execute_on = 'timestep_end'
  []
  [fluidaccel_y]
    type = NewmarkPoreFluidAccelAux
    variable = af_y
    darcyvel = 'w_y'
    gamma = 0.5
    execute_on = 'timestep_end'
  []
[]

[Materials]
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 14.5e6
    poissons_ratio = 0.3
    block = 'domain'
  []
  [strain]
    type = ComputeSmallStrain
    displacements = 'u_x u_y'
    block = 'domain'
  []
  [stress]
    type = ComputeLinearElasticStress
    block = 'domain'
  []
  [density]
    type = GenericConstantMaterial
    block = 'domain'
    prop_names = 'density'
    prop_values = '1986'
  []
  [rhof]
    type = GenericConstantMaterial
    block = 'domain'
    prop_names = 'rhof'
    prop_values = '1000'
  []
  [porosity]
    type = GenericConstantMaterial
    block = 'domain'
    prop_names = 'porosity'
    prop_values = '0.42'
  []
  [hydconductivity]
    type = GenericConstantMaterial
    block = 'domain'
    prop_names = 'hydconductivity'
    prop_values = '0.0001'
  []
  [biotcoeff]
    type = GenericConstantMaterial
    block = 'domain'
    prop_names = 'biot_coefficient'
    prop_values = '1.0'
  []
  [viscosity]
    type = GenericConstantMaterial
    prop_values = '0.002'
    prop_names = 'mu'
    block = 'domain'
  []
[]

[Functions]
  [bc_func]
    # value = 'if(x<5.0,0.0,15.0)*if(t<0.1,10*t,1.0)'
    type = ParsedFunction
    value = 'if(t<0.1,10*t,1.0)'
  []
[]

[BCs]
  # [./topleft_y]
  # type = Pressure
  # variable = u_y
  # boundary = 'topleft'
  # component = 1 #y
  # factor = 0.0
  # use_displaced_mesh = false
  # [../]
  # [./porepressure]
  # type = PresetBC
  # variable = p
  # boundary = 'topleft'
  # value = 0
  # [../]
  [bottom_y]
    type = PresetBC
    variable = u_y
    boundary = 'bottom'
    value = 0
  []
  [topright_y]
    # boundary = 'topright'
    type = Pressure
    variable = u_y
    boundary = 'top'
    use_displaced_mesh = false
    component = 1 # y
    factor = 15.0e3
    function = bc_func
  []
  [left_x]
    type = PresetBC
    variable = u_x
    boundary = 'left'
    value = 0
  []
  [right_x]
    type = PresetBC
    variable = u_x
    boundary = 'right'
    value = 0
  []
  [fluidbottom_y]
    type = PresetBC
    variable = w_y
    boundary = 'bottom'
    value = 0
  []
  [fluidleft_x]
    type = PresetBC
    variable = w_x
    boundary = 'left'
    value = 0
  []
  [fluidright_x]
    type = PresetBC
    variable = w_x
    boundary = 'right'
    value = 0
  []
  [fluidtopright_y]
    # boundary = 'topright'
    type = PresetBC
    variable = w_y
    boundary = 'top'
    value = 1
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_type -pc_factor_shift_type'
    petsc_options_value = 'lu umfpack NONZERO'
  []
[]

[Postprocessors]
  [rightcornerdisp]
    type = PointValue
    point = '10 10 0'
    variable = u_y
  []
  [leftcornerdisp]
    type = PointValue
    point = '0 10 0'
    variable = u_y
  []
  [rightcornerdarcy]
    type = PointValue
    point = '10 10 0'
    variable = w_y
  []
  [leftcornerdarcy]
    type = PointValue
    point = '0 10 0'
    variable = w_y
  []
[]

[Executioner]
  type = Transient
  solve_type = PJFNK
  l_max_its = 1
  nl_max_its = 1
  l_tol = 1.0e-6
  nl_rel_tol = 0.1
  nl_abs_tol = 1.0
  start_time = 0
  end_time = 10.0
  dtmax = 0.002
  dtmin = 0.002
  [TimeStepper]
    type = ConstantDT
    dt = 0.002
  []
[]

[Outputs]
  exodus = true
  output_on = 'timestep_end'
  inactive = 'console'
  [console]
    # perf_log = true
    type = Console
    execute_on = 'initial timestep_end failed nonlinear' # linear
  []
  [csv]
    type = CSV
    execute_on = 'initial timestep_end'
  []
[]
