#include "GamusinoApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

// Actions

// Materials
#include "GamusinoMaterialBase.h"

// Kernels
#include "PoreFluidInertialForceCoupling.h"
#include "DynamicDarcyFlow.h"
#include "MassConservationNewmark.h"

// AuxKernels
#include "NewmarkPoreFluidAccelAux.h"

// DiracKernels

// BCs
#include "PorePressureBC.h"

// Controls

// Functions

// UserObjects
#include "GamusinoScaling.h"
#include "GamusinoSUPG.h"
#include "GamusinoPropertyReadFile.h"
#include "GamusinoFluidDensityConstant.h"
#include "GamusinoFluidDensityLinear.h"
#include "GamusinoFluidViscosityConstant.h"
#include "GamusinoFluidViscosityLinear.h"
#include "GamusinoPorosityConstant.h"
#include "GamusinoPermeabilityConstant.h"
#include "GamusinoPermeabilityKC.h"
#include "GamusinoPermeabilityCubicLaw.h"

template<>
InputParameters validParams<GamusinoApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  return params;
}

GamusinoApp::GamusinoApp(const InputParameters & parameters) : 
    MooseApp(parameters)
{
  srand(processor_id());

  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  GamusinoApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  GamusinoApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  GamusinoApp::registerExecFlags(_factory);
}

GamusinoApp::~GamusinoApp()
{
}

// External entry point for dynamic application loading

void
GamusinoApp::registerApps()
{
  registerApp(GamusinoApp);
}


// External entry point for dynamic object registration
void
GamusinoApp::registerObjects(Factory & factory)
{
  // Materials
  registerMaterial(GamusinoMaterialBase);

  // Kernels
  registerKernel(PoreFluidInertialForceCoupling);
  registerKernel(DynamicDarcyFlow);
  registerKernel(MassConservationNewmark);

  // AuxKernels
  registerAux(NewmarkPoreFluidAccelAux);

  // DriacKernels

  // BCs
  registerBoundaryCondition(PorePressureBC);

  // Controls

  // Function

  // UserObjects
  registerUserObject(GamusinoScaling);
  registerUserObject(GamusinoSUPG);
  registerUserObject(GamusinoPropertyReadFile);
  registerUserObject(GamusinoFluidDensityConstant);
  registerUserObject(GamusinoFluidDensityLinear);
  registerUserObject(GamusinoFluidViscosityConstant);
  registerUserObject(GamusinoFluidViscosityLinear);
  registerUserObject(GamusinoPorosityConstant);
  registerUserObject(GamusinoPorosityTHM);
  registerUserObject(GamusinoPermeabilityConstant);
  registerUserObject(GamusinoPermeabilityKC);
  registerUserObject(GamusinoPermeabilityCubicLaw);

    Registry::registerObjectsTo(factory, {"GamusinoApp"});
}

void
GamusinoApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & action_factory)
{
  Registry::registerActionsTo(action_factory, {"GamusinoApp"});

  /* Uncomment Syntax parameter and register your new production objects here! */
}

void
GamusinoApp::registerObjectDepends(Factory & /*factory*/)
{
}

void
GamusinoApp::associateSyntaxDepends(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}

void
GamusinoApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execution flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
extern "C" void
GamusinoApp__registerApps()
{
  GamusinoApp::registerApps();
}

extern "C" void
GamusinoApp__registerObjects(Factory & factory)
{
  GamusinoApp::registerObjects(factory);
}

extern "C" void
GamusinoApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  GamusinoApp::associateSyntax(syntax, action_factory);
}

extern "C" void
GamusinoApp__registerExecFlags(Factory & factory)
{
  GamusinoApp::registerExecFlags(factory);
}
