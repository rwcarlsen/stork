[Mesh]
  type = GeneratedMesh
  dim = 2

  nx = 10
  xmin = 0
  xmax = 10

  ny = 10
  ymin = 0
  ymax = 10
[]

[Variables]
  [./T]
    [./InitialCondition]
      type = ConstantIC
      value = 5.0
    [../]
  [../]
[]

[Kernels]
  #[./diff]
  #  type = Diffusion
  #  variable = T
  #[../]
  [./spacetime]
    type = SpaceTimeHeatConduction
    variable = T
    k = 1.0          # (W/m/K)
    heat_cap = 1.0   # (J/kg/K)
    density = 0.1    # (kg/m^3)
    source_rad = 1.0 # source radius
    source = 0.0     # source strength (W/m^3)
    source_t = '0 10'
    source_x = '0 10'
    source_y = '0 10' # unused for 1d spatial problem (i.e. 2d tot)
  [../]
[]

[BCs]
  [./bottom] # x=0
    type = DirichletBC
    variable = T
    boundary = bottom
    value = 5
  [../]
  [./top] # x=L
    type = DirichletBC
    variable = T
    boundary = top
    value = 5
  [../]
  [./left] # t=0
    type = FunctionDirichletBC
    function = bc_func
    variable = T
    boundary = left
  [../]
  #[./right] # t=T
  #  type = BC
  #  k = 1.0
  #  variable = T
  #  boundary = right
  #[../]
  #[./right] # t=T
  #  type = DirichletBC
  #  variable = T
  #  boundary = right
  #  value = 5
  #[../]
[]

[Functions]
  [./bc_func]
    type = ParsedFunction
    value = sqrt(25-(y-5)^2)+5
    #vars = 'alpha'
    #vals = '16'
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
[]

[Preconditioning]
  active = 'FDP'
  [./FDP]
    type = FDP
    full = true
  [../]
[]

[Outputs]
  exodus = true
[]
