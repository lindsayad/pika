[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  uniform_refine = 1
  elem_type = QUAD8
[]

[Variables]
  [./u]
    order = SECOND
  [../]
[]

[AuxVariables]
  [./phi]
  [../]
  [./abs_error]
  [../]
[]

[Functions]
  [./phi_func]
    type = ParsedFunction
    value = t*x*y
  [../]
  [./u_func]
    type = ParsedFunction
    value = t*sin(2.0*pi*x)*cos(2.0*pi*y)
  [../]
[]

[Kernels]
  [./u_time]
    type = TimeDerivative
    variable = u
  [../]
  [./u_diff]
    type = MatDiffusion
    variable = u
    D_name = diffusion_coefficient
    block = 0
  [../]
  [./mms]
    type = MassTransportSourceMMS
    variable = u
    phi = phi
    use_dt_dphi = true
  [../]
  [./phi_time]
    type = PikaTimeDerivative
    variable = u
    coefficient = 0.5
    differentiated_variable = phi
  [../]
[]

[AuxKernels]
  [./phi_kernel]
    type = FunctionAux
    variable = phi
    function = phi_func
  [../]
  [./error_aux]
    type = ErrorFunctionAux
    variable = abs_error
    function = u_func
    solution_variable = u
  [../]
[]

[BCs]
  [./all]
    type = FunctionDirichletBC
    variable = u
    boundary = 'bottom left right top'
    function = u_func
  [../]
[]

[PikaMaterials]
  phi = phi
  temperature = 273.15
[]

[Postprocessors]
  [./L2_errror]
    type = ElementL2Error
    variable = u
    function = u_func
  [../]
[]

[Executioner]
  type = Transient
  num_steps = 2
  dt = 0.25
[]

[Adaptivity]
[]

[Outputs]
  exodus = true
[]

[ICs]
  [./u_ic]
    function = u_func
    variable = u
    type = FunctionIC
  [../]
  [./phi_ic]
    function = phi_func
    variable = phi
    type = FunctionIC
  [../]
[]

