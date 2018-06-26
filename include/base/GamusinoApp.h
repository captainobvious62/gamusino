#ifndef GAMUSINOAPP_H
#define GAMUSINOAPP_H

#include "MooseApp.h"

class GamusinoApp;

template<>
InputParameters validParams<GamusinoApp>();

class GamusinoApp : public MooseApp
{
public:
  GamusinoApp(const InputParameters & parameters);
  virtual ~GamusinoApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void registerObjectDepends(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
  static void associateSyntaxDepends(Syntax & syntax, ActionFactory & action_factory);
  static void registerExecFlags(Factory & factory);
};

#endif /* GAMUSINOAPP_H */
