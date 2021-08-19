#pragma once
#include <constraint.h>

#include <functional>
#include <memory>

using namespace std;

namespace CGLE {
  using FnHandlerRetType = std::function<complex<double>(double, double)>;

  class FunctionHandler {
  public:
    /**
     * @brief FunctionHandler iniatializes and instantiates a function handler object
     *
     * @param  {Constraint} constraint :
     */
    FunctionHandler(const Constraint constraint);
    /**
     * Returns the function handle representing A(x,t)
     * @return {FnHandlerRetType}  :
     */
    FnHandlerRetType A();
    /**
     * Returns the function handle representing B(x,t)
     * @return {FnHandlerRetType}  :
     */
    FnHandlerRetType B();

  private:
    shared_ptr<Constraint> m_constraint;
    FnHandlerRetType m_A;
    FnHandlerRetType m_B;
    /**
     * InitializeBrightBrightFunctors initializes the function definitions of the bright bright wave
     *
     */
    void InitializeBrightBrightFunctors();
    /**
     * InitializeDarkDarkFunctors initializes the function definitions of the dark dark wave
     */
    void InitializeDarkDarkFunctors();
    /**
     * InitializeDarkDarkFunctors initializes the function definitions of the front front wave
     */
    void InitializeFrontFrontFunctors();
  };
}  // namespace CGLE
