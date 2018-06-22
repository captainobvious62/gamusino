//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#include "GamusinoTestApp.h"
#include "GamusinoApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "MooseSyntax.h"
#include "ModulesApp.h"

template <>
InputParameters
validParams<GamusinoTestApp>()
{
  InputParameters params = validParams<GamusinoApp>();
  return params;
}

GamusinoTestApp::GamusinoTestApp(InputParameters parameters) : MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  GamusinoApp::registerObjectDepends(_factory);
  GamusinoApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  GamusinoApp::associateSyntaxDepends(_syntax, _action_factory);
  GamusinoApp::associateSyntax(_syntax, _action_factory);

  Moose::registerExecFlags(_factory);
  ModulesApp::registerExecFlags(_factory);
  GamusinoApp::registerExecFlags(_factory);

  bool use_test_objs = getParam<bool>("allow_test_objects");
  if (use_test_objs)
  {
    GamusinoTestApp::registerObjects(_factory);
    GamusinoTestApp::associateSyntax(_syntax, _action_factory);
    GamusinoTestApp::registerExecFlags(_factory);
  }
}

GamusinoTestApp::~GamusinoTestApp() {}

void
GamusinoTestApp::registerApps()
{
  registerApp(GamusinoApp);
  registerApp(GamusinoTestApp);
}

void
GamusinoTestApp::registerObjects(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new test objects here! */
}

void
GamusinoTestApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
  /* Uncomment Syntax and ActionFactory parameters and register your new test objects here! */
}

void
GamusinoTestApp::registerExecFlags(Factory & /*factory*/)
{
  /* Uncomment Factory parameter and register your new execute flags here! */
}

/***************************************************************************************************
 *********************** Dynamic Library Entry Points - DO NOT MODIFY ******************************
 **************************************************************************************************/
// External entry point for dynamic application loading
extern "C" void
GamusinoTestApp__registerApps()
{
  GamusinoTestApp::registerApps();
}

// External entry point for dynamic object registration
extern "C" void
GamusinoTestApp__registerObjects(Factory & factory)
{
  GamusinoTestApp::registerObjects(factory);
}

// External entry point for dynamic syntax association
extern "C" void
GamusinoTestApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory)
{
  GamusinoTestApp::associateSyntax(syntax, action_factory);
}

// External entry point for dynamic execute flag loading
extern "C" void
GamusinoTestApp__registerExecFlags(Factory & factory)
{
  GamusinoTestApp::registerExecFlags(factory);
}
