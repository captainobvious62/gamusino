#include "GamusinoApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

// Actions
#include "GamusinoPressureAction.h"

// AuxKernels
#include "GamusinoDarcyVelocity.h"
#include "GamusinoEqvInelasticStrain.h"
#include "GamusinoFluidVelocity.h"
#include "GamusinoStrain.h"
#include "GamusinoStress.h"
#include "GamusinoThermalStress.h"
#include "NewmarkPoreFluidAccelAux.h"

// BCs
#include "GamusinoConvectiveTHBC.h"
#include "GamusinoHeatFlowBC.h"
#include "GamusinoNonReflectingBC.h"
#include "GamusinoPressureBC.h"
#include "GamusinoSeismicForce.h"
#include "GamusinoVelocityBC.h"
#include "PorePressureBC.h"

// Controls
#include "GamusinoTimeControl.h"

// DiracKernels
#include "GamusinoDiracKernelTH.h"
#include "GamusinoFunctionPointForce.h"
#include "GamusinoSeismicSource.h"

// Functions
#include "GamusinoFunctionBCFromFile.h"
#include "GamusinoFunctionReadFile.h"

// Kernels
#include "DynamicDarcyFlow.h"
#include "GamusinoKernelH.h"
#include "GamusinoKernelHPoroElastic.h"
#include "GamusinoKernelM.h"
#include "GamusinoKernelT.h"
#include "GamusinoKernelTH.h"
#include "GamusinoKernelTimeH.h"
#include "GamusinoKernelTimeT.h"
#include "GMSEnergyResidual.h"
#include "GMSEnergyTimeDerivative.h"
#include "GMSMassResidual.h"
#include "MassConservationNewmark.h"
#include "PoreFluidInertialForceCoupling.h"

// Materials
#include "GamusinoDruckerPrager.h"
#include "GamusinoInelasticBase.h"
#include "GamusinoMaterialBase.h"
#include "GamusinoMaterialH.h"
#include "GamusinoMaterialMElastic.h"
#include "GamusinoMaterialMInelastic.h"
#include "GamusinoMaterialT.h"
#include "GamusinoMaterialTH.h"
#include "GamusinoPQPlasticity.h"
#include "GMSMaterial.h"

// UserObjects
#include "GamusinoFluidDensity.h"
#include "GamusinoFluidDensityConstant.h"
#include "GamusinoFluidDensityIAPWS.h"
#include "GamusinoFluidDensityLinear.h"
#include "GamusinoFluidViscosity.h"
#include "GamusinoFluidViscosityConstant.h"
#include "GamusinoFluidViscosityIAPWS.h"
#include "GamusinoFluidViscosityLinear.h"
#include "GamusinoHardeningConstant.h"
#include "GamusinoHardeningCubic.h"
#include "GamusinoHardeningExponential.h"
#include "GamusinoHardeningModel.h"
#include "GamusinoHardeningPlasticSaturation.h"
#include "GamusinoPermeability.h"
#include "GamusinoPermeabilityConstant.h"
#include "GamusinoPermeabilityCubicLaw.h"
#include "GamusinoPermeabilityKC.h"
#include "GamusinoPorosity.h"
#include "GamusinoPorosityConstant.h"
#include "GamusinoPorosityTHM.h"
#include "GamusinoPropertyReadFile.h"
#include "GamusinoScaling.h"
#include "GamusinoSUPG.h"

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
  registerMaterial(GMSMaterial);
  registerMaterial(GamusinoMaterialBase);
  registerMaterial(GamusinoMaterialH);
  registerMaterial(GamusinoMaterialT);
  registerMaterial(GamusinoMaterialTH);
  registerMaterial(GamusinoMaterialMElastic);
  registerMaterial(GamusinoMaterialMInelastic);
  registerMaterial(GamusinoDruckerPrager);

  // Kernels
  registerKernel(PoreFluidInertialForceCoupling);
  registerKernel(DynamicDarcyFlow);
  registerKernel(MassConservationNewmark);
  registerKernel(GMSEnergyTimeDerivative);
  registerKernel(GMSEnergyResidual);
  registerKernel(GMSMassResidual);
  registerKernel(GamusinoKernelTimeH);
  registerKernel(GamusinoKernelTimeT);
  registerKernel(GamusinoKernelH);
  registerKernel(GamusinoKernelT);
  registerKernel(GamusinoKernelTH);
  registerKernel(GamusinoKernelM);
  registerKernel(GamusinoKernelHPoroElastic);

  // AuxKernels
  registerAux(NewmarkPoreFluidAccelAux);
  registerAux(GamusinoDarcyVelocity);
  registerAux(GamusinoFluidVelocity);
  registerAux(GamusinoStress);
  registerAux(GamusinoStrain);
  registerAux(GamusinoThermalStress);
  registerAux(GamusinoEqvInelasticStrain);

  // DiracKernels
  registerDiracKernel(GamusinoDiracKernelTH);
  registerDiracKernel(GamusinoSeismicSource);
  registerDiracKernel(GamusinoFunctionPointForce);

  // BCs
  registerBoundaryCondition(PorePressureBC);
  registerBoundaryCondition(GamusinoConvectiveTHBC);
  registerBoundaryCondition(GamusinoVelocityBC);
  registerBoundaryCondition(GamusinoHeatFlowBC);
  registerBoundaryCondition(GamusinoPressureBC);

  // Controls
  registerControl(GamusinoTimeControl);

  // Function
  registerFunction(GamusinoFunctionBCFromFile);
  registerFunction(GamusinoFunctionReadFile);

  // UserObjects
  registerUserObject(GamusinoScaling);
  registerUserObject(GamusinoSUPG);
  registerUserObject(GamusinoPropertyReadFile);
  registerUserObject(GamusinoFluidDensityConstant);
  registerUserObject(GamusinoFluidDensityLinear);
  registerUserObject(GamusinoFluidDensityIAPWS);
  registerUserObject(GamusinoFluidViscosityConstant);
  registerUserObject(GamusinoFluidViscosityLinear);
  registerUserObject(GamusinoFluidViscosityIAPWS);
  registerUserObject(GamusinoPorosityConstant);
  registerUserObject(GamusinoPorosityTHM);
  registerUserObject(GamusinoPermeabilityConstant);
  registerUserObject(GamusinoPermeabilityKC);
  registerUserObject(GamusinoPermeabilityCubicLaw);
  registerUserObject(GamusinoHardeningConstant);
  registerUserObject(GamusinoHardeningCubic);
  registerUserObject(GamusinoHardeningExponential);
  registerUserObject(GamusinoHardeningPlasticSaturation);

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
