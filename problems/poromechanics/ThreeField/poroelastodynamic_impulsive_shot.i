# [Mesh]
# type = FileMesh
# file = mesh.msh
# block_id = '8'
# block_name = 'domain'
# boundary_id = '9 10 11 12 13'
# boundary_name = 'bottom right topright topleft left'
# []
inactive = 'Postprocessors'
[Mesh]
  type = GeneratedMesh
  block_id = '0'
  block_name = 'domain'
  dim = 2
  nx = 25
  ny = 5
  xmin = 0
  xmax = 200 # m
  ymin = 0
  ymax = 50 # m
  elem_type = QUAD8
  zmax = 0
  nz = 0
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
  [ricker_wavelet]
    type = ParsedFunction
    vars = 'f factor shift'
    value = 'factor*((1.0 - 2.0*(pi^2)*(f^2)*( (t + 1/f * pi/shift)^2))*exp(-1.0*(pi^2)*(f^2)*((t + 1/f * pi/shift)^2)))'
    vals = '10 1e6 -8'
  []
  [ricker_source_plus]
    type = ParsedFunction
    vars = 'f factor'
    value = 'factor*((1.0 - 2.0*(pi^2)*(f^2)*(t^2))*exp(-1.0*(pi^2)*(f^2)*(t^2)))'
    vals = '1 1e3'
  []
  [ricker_source_minus]
    type = ParsedFunction
    vars = 'f factor'
    value = 'factor*((1.0 - 2.0*(pi^2)*(f^2)*(t^2))*exp(-1.0*(pi^2)*(f^2)*(t^2)))'
    vals = '1 -1e3'
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
  inactive = 'ShotPoint_p'
  [ShotPoint_p]
    type = PointValue
    point = '5000 4500 0'
    outputs = 'csv'
    variable = p
  []
  [ShotPoint_u_y]
    type = PointValue
    point = '5000 4500 0'
    outputs = 'csv'
    variable = u_y
  []
  [shotpointdisp]
    type = PointValue
    point = '5000 5000 0'
    variable = u_y
  []
  [shotpointdarcy]
    type = PointValue
    point = '5000 5000 0'
    variable = w_y
  []
  [shotsurface_disp]
    type = PointValue
    point = '500 100 0'
    variable = u_y
  []
  [shotsurf_darcy]
    type = PointValue
    point = '500 100 0'
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
  end_time = 5
  dtmax = 0.001
  dtmin = 0.0000000001
  dt = 0.01
  verbose = true
  [TimeStepper]
    type = ConstantDT
    dt = 0.001
  []
[]

[Outputs]
  exodus = true
  output_on = 'timestep_end'
  [console]
    # perf_log = true
    type = Console
    execute_on = 'initial timestep_end failed nonlinear' # linear
  []
  [csv]
    type = CSV
    execute_on = 'initial timestep_end'
    execute_vector_postprocessors_on = 'TIMESTEP_END'
    sort_columns = true
    execute_postprocessors_on = 'TIMESTEP_END'
    time_data = true
    execute_scalars_on = 'TIMESTEP_END'
  []
[]

[DiracKernels]
  inactive = 'point_source_u_x point_source_p point_source_u_x_plus point_source_u_x_minus point_source_u_y_plus point_source_u_y_minus'
  [point_source_u_x]
    type = FunctionDiracSource
    function = ricker_wavelet
    point = '500 50 0'
    variable = u_x
  []
  [point_source_u_y]
    type = FunctionDiracSource
    function = ricker_wavelet
    point = '100 50 0'
    variable = u_y
  []
  [point_source_p]
    type = FunctionDiracSource
    function = ricker_wavelet
    point = '50 50 0'
    variable = p
  []
  [point_source_u_x_plus]
    type = FunctionDiracSource
    function = ricker_source_plus
    point = '500 50 0'
    variable = u_x
  []
  [point_source_u_x_minus]
    type = FunctionDiracSource
    function = ricker_source_minus
    point = '500 50 0'
    variable = u_x
  []
  [point_source_u_y_plus]
    type = FunctionDiracSource
    function = ricker_source_plus
    point = '500 50 0'
    variable = u_y
  []
  [point_source_u_y_minus]
    type = FunctionDiracSource
    function = ricker_source_minus
    point = '500 50 0'
    variable = u_y
  []
[]

[MeshModifiers]
[]

[Adaptivity]
  initial_steps = 2
  recompute_markers_during_cycles = true
  marker = efm_p
  initial_marker = efm_p
  [Indicators]
    inactive = 'ValueJump_p GradientJump_u_y'
    [GradientJump_p]
      type = GradientJumpIndicator
      scale_by_flux_faces = true
      variable = p
    []
    [ValueJump_p]
      type = ValueJumpIndicator
      block = '0'
      scale_by_flux_faces = true
      variable = p
    []
    [GradientJump_u_y]
      type = GradientJumpIndicator
      scale_by_flux_faces = true
      variable = u_y
    []
  []
  [Markers]
    inactive = 'efm_u_y'
    [efm_p]
      type = ErrorFractionMarker
      indicator = GradientJump_p
      coarsen = 0.45
      refine = 0.65
    []
    [efm_u_y]
      type = ErrorFractionMarker
      indicator = GradientJump_u_y
      coarsen = 0.45
      refine = 0.65
    []
  []
[]
