#pragma once
#include <constants.h>
#include <functionHandler.h>

FunctionHandler::FunctionHandler(const Parameter::Constraint constraint) {
  m_constraint = std::make_shared<Parameter::Constraint>(constraint);

  if (this->m_constraint->m_CaseType == 1 || this - m_constraint->m_CaseType == 2) {
    switch (this->m_constraint->m_WaveType) {
      case RIGHT_BRIGHT:
        InitializeBrightBrightFunctors();
        break;
      case DARK_DARK:
        InitializeDarkDarkFunctors();
        break;
      case FRONT_FRONT:
        InitializeFrontFrontFunctors();
        break;
      default:
        InitializeBrightBrightFunctors();
        break;
    }
  }
}

void FunctionHandler::InitializeBrightBrightFunctors() {
  this->m_A = [](double xPosition, double timePoint) {
    return (this->m_constraint->m_Eta * exp((2 * xPosition * real(m_constraint->k1)))
            + (2 * timePoint * real(m_constraint->W1)))
               / (1
                  + exp((2 * xPosition * real(m_constraint.k1))
                        + (2 * timePoint * real(m_constraint.W1))))
           ^ 2;
  };

  this->m_B = [](double xPosition, double timePoint) {
    return (this->m_constraint->m_Mu * exp((2 * xPosition * real(m_constraint->k1)))
            + (2 * timePoint * real(m_constraint->W1)))
               / (1
                  + exp((2 * xPosition * real(m_constraint.k1))
                        + (2 * timePoint * real(m_constraint.W1))))
           ^ 2;
  };
}

void FunctionHandler::InitializeDarkDarkFunctors() {
  this->m_A = [](double xPosition, double timePoint) {
    return (this->m_constraint->m_Eta * (1-exp(2 * (xPosition * real(m_constraint->k1) 
            + (timePoint * real(m_constraint->W1)))))^2)
               / (1 + exp(2 * (xPosition * real(m_constraint.k1) + (timePoint * real(m_constraint.W1))))
           ^ 2;
  };

  this->m_B = [](double xPosition, double timePoint) {
    return (this->m_constraint->m_Mu * (1-exp(2 * (xPosition * real(m_constraint->k1)) 
            + (timePoint * real(m_constraint->W1))))^2)
               / (1 + exp(2 * (xPosition * real(m_constraint.k1) + (timePoint * real(m_constraint.W1))))
           ^ 2;
  };
}

void FunctionHandler::InitializeFrontFrontFunctors() {
  this->m_A = [](double xPosition, double timePoint) {
    return (
        this->m_constraint->m_Eta
            * (1 - exp((xPosition * real(m_constraint->k1) + (timePoint * real(m_constraint->W1)))))
        ^ 2);
  };

  this->m_B = [](double xPosition, double timePoint) {
    return (this->m_constraint->m_Mu
            * (exp((2 * xPosition * real(m_constraint->k1))
                   + (2 * timePoint * real(m_constraint->W1)))))
               / (1
                  + exp((xPosition * real(m_constraint.k1)) + (timePoint * real(m_constraint.W1))))
           ^ 2;
  };
}

FnHandlerRetType FunctionHandler::A() { return this->m_A; }

FnHandlerRetType FunctionHandler::B() { return this->m_B; }
