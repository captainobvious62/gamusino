#include "GamusinoPressureAction.h"
#include "Factory.h"
#include "FEProblem.h"
#include "Conversion.h"

template <>
InputParameters
validParams<GamusinoPressureAction>()
{
  InputParameters params = validParams<Action>();
  params.addClassDescription("Set up pressure boundary conditions.");
  params.addRequiredParam<std::vector<BoundaryName>>(
      "boundary", "The list of boundary IDs from the mesh where the pressure will be applied.");
  params.addRequiredParam<std::vector<NonlinearVariableName>>(
      "displacements",
      "The displacements appropriate for the simulation geometry and coordinate system");
  params.addParam<FunctionName>("function", "The function that describes the pressure.");
  params.addParam<UserObjectName>("scaling_uo", "The name of the scaling user object.");
  return params;
}

GamusinoPressureAction::GamusinoPressureAction(const InputParameters & params) : Action(params) {}

void
GamusinoPressureAction::act()
{
  const std::string kernel_name = "GamusinoPressureBC";

  std::vector<NonlinearVariableName> displacements =
      getParam<std::vector<NonlinearVariableName>>("displacements");

  // Create pressure BCs
  for (unsigned int i = 0; i < displacements.size(); ++i)
  {
    // Create unique kernel name for each of the components
    std::string unique_kernel_name = kernel_name + "_" + _name + "_" + Moose::stringify(i);

    InputParameters params = _factory.getValidParams(kernel_name);
    params.applyParameters(parameters());
    params.set<bool>("use_displaced_mesh") = true;
    params.set<unsigned int>("component") = i;
    params.set<NonlinearVariableName>("variable") = displacements[i];

    _problem->addBoundaryCondition(kernel_name, unique_kernel_name, params);
  }
}
