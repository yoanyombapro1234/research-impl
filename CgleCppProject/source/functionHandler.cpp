#include <constants.h>
#include <functionHandler.h>

using namespace CGLE;
FunctionHandler::FunctionHandler(const Constraint constraint) {
  m_constraint = std::make_shared<Constraint>(constraint);

  if (this->m_constraint->m_CaseType == 1 || this->m_constraint->m_CaseType == 2) {
    if (this->m_constraint->m_WaveType == BRIGHT_BRIGHT) {
      InitializeBrightBrightFunctors();
    } else if (this->m_constraint->m_WaveType == DARK_DARK)
      InitializeDarkDarkFunctors();
  } else {
    InitializeFrontFrontFunctors();
  }
}

void FunctionHandler::InitializeBrightBrightFunctors() {
  this->m_A = [this](double xPosition, double timePoint) {
    return (this->m_constraint->m_Eta * exp((2 * xPosition * real(this->m_constraint->m_k1)))
            + (2 * timePoint * real(this->m_constraint->m_W1)))
           / pow(1
                     + exp((2 * xPosition * real(this->m_constraint->m_k1))
                           + (2 * timePoint * real(this->m_constraint->m_W1))),
                 2);
  };

  this->m_B = [this](double xPosition, double timePoint) {
    return (this->m_constraint->m_Mu * exp((2 * xPosition * real(this->m_constraint->m_k1)))
            + (2 * timePoint * real(this->m_constraint->m_W1)))
           / pow(1
                     + exp((2 * xPosition * real(this->m_constraint->m_k1))
                           + (2 * timePoint * real(this->m_constraint->m_W1))),
                 2);
  };
}

void FunctionHandler::InitializeDarkDarkFunctors() {
  this->m_A = [this](double xPosition, double timePoint) {
    return (this->m_constraint->m_Eta
            * pow(1
                      - exp(2
                            * (xPosition * real(this->m_constraint->m_k1)
                               + (timePoint * real(this->m_constraint->m_W1)))),
                  2))
           / pow(1
                     + exp(2
                           * (xPosition * real(this->m_constraint->m_k1)
                              + (timePoint * real(this->m_constraint->m_W1)))),
                 2);
  };

  this->m_B = [this](double xPosition, double timePoint) {
    return (this->m_constraint->m_Mu
            * pow(1
                      - exp(2 * (xPosition * real(this->m_constraint->m_k1))
                            + (timePoint * real(this->m_constraint->m_W1))),
                  2))
           / pow(1
                     + exp(2
                           * (xPosition * real(this->m_constraint->m_k1)
                              + (timePoint * real(this->m_constraint->m_W1)))),
                 2);
  };
}

void FunctionHandler::InitializeFrontFrontFunctors() {
  this->m_A = [this](double xPosition, double timePoint) {
    return (this->m_constraint->m_Eta
            * pow(1
                      - exp((xPosition * real(this->m_constraint->m_k1)
                             + (timePoint * real(this->m_constraint->m_W1)))),
                  2));
  };

  this->m_B = [this](double xPosition, double timePoint) {
    return (this->m_constraint->m_Mu
            * (exp((2 * xPosition * real(this->m_constraint->m_k1))
                   + (2 * timePoint * real(this->m_constraint->m_W1)))))
           / pow(1
                     + exp((xPosition * real(this->m_constraint->m_k1))
                           + (timePoint * real(this->m_constraint->m_W1))),
                 2);
  };
}

FnHandlerRetType FunctionHandler::A() { return this->m_A; }

FnHandlerRetType FunctionHandler::B() { return this->m_B; }
