[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = -1
  xmax = 1
  ymin = -1
  ymax = 1
  nx = 20
  ny = 20
[]

[Variables]
  [./u]
  [../]
[]

[AuxVariables]
  [./sink_strength]
    type = CONSTANT
    family = MONOMIAL
  [../]
[]

[ICs]
  [./gaussianIC]
    type = FunctionIC
    variable = u
    function = gaussian
  [../]
[]

[BCs]
  [./Periodic]
    [./all]
      variable = u
      auto_direction = 'x y'
    [../]
  [../]
[]

[Functions]
  [./gaussian]
    type = GaussianFunction
    sigma = 0.05
    scale = 2.0
    peak_location = '0.05 0.95 0.0'
    periodic_variable = u
  [../]
[]

[Kernels]
  [./dt]
    type = TimeDerivative
    variable = u
  [../]
  [./diffusion]
    type = Diffusion
    variable = u
  [../]
[]

[AuxKernels]
  [./sink_map_aux]
    type = SinkMapAux
    variable = sink_strength
    sink_map_user_object = sink_map_uo
    execute_on = 'timestep_end'
  [../]
[]

[UserObjects]
  [./sink_gaussian_uo]
    type = GaussianUserObject
    periodic_var = u
    sigma = 0.05
  [../]
  [./sink_map_uo]
    type = SinkMapUserObject
    spacing = 1.0
    strength = 3.0
    gaussian_user_object = sink_gaussian_uo
    periodic_variable = u
  [../]
[]

[Postprocessors]
  [./integral]
    type = ElementIntegralVariablePostprocessor
    variable = sink_strength
    execute_on = 'initial timestep_end'
  [../]
  [./average]
    type = ElementAverageValue
    variable = sink_strength
    execute_on = 'initial timestep_end'
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 2
  dt = 0.001
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  csv = true
  exodus = true
[]
