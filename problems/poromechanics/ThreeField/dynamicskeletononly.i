[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 40
  ny = 40
  xmin = 0
  xmax = 10
  ymin = 0
  ymax = 10
  elem_type = QUAD4
[]
[Variables]
  active = 'u_x u_y'
  
  [./u_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./u_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[AuxVariables]
  [./v_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./v_y]
    order = FIRST
    family = LAGRANGE
  [../]

  [./a_x]
    order = FIRST
    family = LAGRANGE
  [../]

  [./a_y]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  active = 'stressdivx stressdivy inertia_x inertia_y'
  
  [./stressdivx]
    type = StressDivergenceTensors
    variable = u_x
    component = 0
    displacements = 'u_x u_y'
    use_displaced_mesh = false
  [../]

  [./stressdivy]
    type = StressDivergenceTensors
    variable = u_y
    component = 1
    displacements = 'u_x u_y'
    use_displaced_mesh = false
  [../]

  [./inertia_x]
    type = InertialForce
    variable = u_x
    velocity = v_x
    acceleration = a_x
    beta = 0.25
    gamma = 0.5
    use_displaced_mesh = false
  [../]

  [./inertia_y]
    type = InertialForce
    variable = u_y
    velocity = v_y
    acceleration = a_y
    beta = 0.25
    gamma = 0.5
    use_displaced_mesh = false
  [../]
[]

[AuxKernels]
  [./accel_x]
    type = NewmarkAccelAux
    variable = a_x
    displacement = u_x
    velocity = v_x
    beta = 0.25
    execute_on = timestep_end
  [../]

  [./accel_y]
    type = NewmarkAccelAux
    variable = a_y
    displacement = u_y
    velocity = v_y
    beta = 0.25
    execute_on = timestep_end
  [../]

  [./vel_x]
    type = NewmarkVelAux
    variable = v_x
    acceleration = a_x
    gamma = 0.5
    execute_on = timestep_end
  [../]

  [./vel_y]
    type = NewmarkVelAux
    variable = v_y
    acceleration = a_y
    gamma = 0.5
    execute_on = timestep_end
  [../]
[]

[Materials]
  [./elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.0
    poissons_ratio = 0.3
    block = 0
  [../]

  [./strain]
    type = ComputeSmallStrain
    displacements = 'u_x u_y'
    block = 0
  [../]

  [./stress]
    type = ComputeLinearElasticStress
    block = 0
  [../]

  [./density]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'density'
    prop_values = '0.1'
  [../]
[]

[Functions]
  active = 'bc_func'

  [./bc_func]
    type = ParsedFunction
    value = 'if(x<5.0,0.0,10.0)'
  [../]
[]

[BCs]
  [./bottom_y]
    type = PresetBC
    variable = u_y
    boundary = 'bottom'
    value = 0
  [../]

  [./top_y]
    type = Pressure
    variable = u_y
    boundary = 'top'
    component = 1 #y
    factor = 1.0
    function = bc_func
    use_displaced_mesh = false
  [../]

  [./left_x]
    type = PresetBC
    variable = u_x
    boundary = 'left'
    value = 0
  [../]

  [./right_x]
    type = PresetBC
    variable = u_x
    boundary = 'right'
    value = 0
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'
  l_max_its = 20
  nl_max_its = 10
  l_tol = 1.0e-7
  nl_rel_tol = 1.0e-12
  start_time = 0
  end_time = 100
  dtmax = 0.1
  dtmin = 0.1

  [./TimeStepper]
    type = ConstantDT
    dt = 0.1
  [../]
[]

[Outputs]
  exodus = true
  output_on = 'timestep_end'

  [./console]
    type = Console
    perf_log = true
    execute_on = 'initial timestep_end failed nonlinear'
  [../]
[]

