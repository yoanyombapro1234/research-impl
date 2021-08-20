#include <constraint.h>

#include <fstream>
#include <memory>
#include <string>
#include <vector>

using namespace std;

namespace CGLE {
  class ConstraintReader {
  public:
    /**
     * ConstraintReader instantiates a constraint reader object based on a file present at a defined
     * file path
     *
     * @param  {string} filePath : path of the constraint file
     */
    ConstraintReader(string& filePath);

    /**
     * Read reads the contents of the file located at a defined path
     */
    void Read();

  private:
    string m_filePath;
    Constraint m_constraint;

    /**
     * ReadHelper helper function to read the contents of a constraint file
     *
     */
    void ReadHelper();

    /**
     * Print prints out a list of constraints to console
     */
    void Print();

    void ProcessConstraint(int numProcessedConstraints, const string& value,
                           complex<double>* cmplxValue);
    /**
     * Checks if the element being read in has and operator (- | +)
     * @param  {char} element :  The element of interest
     * @return {bool}         :  The status specifying wether or not an operator exists
     */
    bool IsOperator(const char& element);

    /**
     * Checks if a string of interest is comprised of a complex number
     * @param  {string} val : String of interest
     * @return {bool}       : Status specifying wether or not this is a complex number
     */
    bool IsComplex(const string& val);

    /**
     * Transforms a complex number represented in string form to a complex number of complex type
     * @param  {string} value                 : String representation of complex number
     * @return {unique_ptr<complex<double>>}  : Pointer to the complex type
     */
    complex<double> TransformToCmplxValue(const string& value);

    bool HasOperatorAndImaginaryNumber(const char& element, bool containsOperator,
                                       bool containsImaginaryValue);
  };
}  // namespace CGLE