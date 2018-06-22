//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html
#ifndef GAMUSINOTESTAPP_H
#define GAMUSINOTESTAPP_H

#include "MooseApp.h"

class GamusinoTestApp;

template <>
InputParameters validParams<GamusinoTestApp>();

class GamusinoTestApp : public MooseApp
{
public:
  GamusinoTestApp(InputParameters parameters);
  virtual ~GamusinoTestApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* GAMUSINOTESTAPP_H */
