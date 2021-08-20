#include <constants.h>
#include <constraint.h>
#include <fileReader.h>

#include <algorithm>
#include <iostream>
using namespace CGLE;

ConstraintReader::ConstraintReader(string& filePath) : m_filePath(std::move(filePath)) {}

void ConstraintReader::ProcessConstraint(int numProcessedConstraints, const string& value,
                                         complex<double>* cmplxValue) {
  switch (numProcessedConstraints) {
    case 0:
      this->m_constraint.m_WaveType = value;
      break;
    case 1:
      this->m_constraint.m_CaseLetter = value;
      break;
    case 2:
      this->m_constraint.m_CaseType = std::stoi(value);
      break;
    case 3:
      this->m_constraint.m_StartTime = std::stod(value);
      break;
    case 4:
      this->m_constraint.m_EndTime = std::stod(value);
      break;
    case 5:
      this->m_constraint.m_StartPosition = std::stod(value);
      break;
    case 6:
      this->m_constraint.m_EndPosition = std::stod(value);
      break;
    case 7:
      this->m_constraint.m_L = std::stod(value);
      break;
    case 8:
      // TODO: handle this by throwing an exception
      this->m_constraint.m_k1 = *cmplxValue;
      break;
    case 9:
      this->m_constraint.m_K1 = std::stod(value);
      break;
    case 10:
      this->m_constraint.m_K2 = std::stod(value);
      break;
    case 11:
      this->m_constraint.m_W1 = *cmplxValue;
      break;
    case 12:
      this->m_constraint.m_Eta = std::stod(value);
      break;
    case 13:
      this->m_constraint.m_Omega1 = std::stod(value);
      break;
    case 14:
      this->m_constraint.m_Omega2 = std::stod(value);
      break;
    case 15:
      this->m_constraint.m_Beta = std::stod(value);
      break;
    case 16:
      this->m_constraint.m_Alpha = std::stod(value);
      break;
    case 17:
      this->m_constraint.m_Q2r = std::stod(value);
      break;
    case 18:
      this->m_constraint.m_Gamma1 = *cmplxValue;
      break;
    case 19:
      this->m_constraint.m_Gamma1Prime = *cmplxValue;
      break;
    case 20:
      this->m_constraint.m_P1 = *cmplxValue;
      break;
    case 21:
      this->m_constraint.m_P1Prime = *cmplxValue;
      break;
    case 22:
      this->m_constraint.m_Q1 = *cmplxValue;
      break;
    case 23:
      this->m_constraint.m_Q2 = *cmplxValue;
      break;
    case 24:
      this->m_constraint.m_Q1Prime = *cmplxValue;
      break;
    case 25:
      this->m_constraint.m_Q2Prime = *cmplxValue;
      break;
  }
}

void ConstraintReader::ReadHelper() {
  ifstream readData(FILEPATH);
  if (!readData.is_open())
    throw runtime_error("Error opening file containing constraint configurations");

  string line;
  std::string delimiter = "=";
  int processedConstraints = 0;

  while (getline(readData, line)) {
    while (std::size_t pos = line.find(delimiter) != std::string::npos) {
      string token = line.substr(0, pos);
      string value = line.substr(pos, line.length());
      std::unique_ptr<complex<double>> cmplxValue
          = std::make_unique<complex<double>>(TransformToCmplxValue(value));
      ProcessConstraint(processedConstraints, value, cmplxValue.get());
      processedConstraints++;
    }
  }
}

void ConstraintReader::Read() {
  if (this->m_filePath.empty()) {
    // TODO: implement this in a smarter manner
    throw std::invalid_argument("file path is misconfigured and must be set");
  }

  this->ReadHelper();
}

bool ConstraintReader::IsOperator(const char& element) { return element == '-' || element == '+'; }

bool ConstraintReader::HasOperatorAndImaginaryNumber(const char& element, bool containsOperator,
                                                     bool containsImaginaryValue) {
  if (IsOperator(element)) {
    containsOperator = true;
  }

  if (element == 'i') {
    containsImaginaryValue = true;
  }

  // safe to assume if "i" is present and the value contains an operator, this is a complex
  // number
  if (containsImaginaryValue && containsOperator) {
    return true;
  }

  return false;
}

bool ConstraintReader::IsComplex(const string& val) {
  bool containsImaginaryValue = false;
  bool containsOperator = false;

  auto it = find_if(val.begin(), val.end(), [&](const char& element) {
    return HasOperatorAndImaginaryNumber(element, containsOperator, containsImaginaryValue);
  });

  return it != val.end();
}

complex<double> ConstraintReader::TransformToCmplxValue(const string& value) {
  // check if value is a complex value
  if (IsComplex(value)) {
    // obtain complev value;
    int re, im;
    char sign;
    std::stringstream stream(value);
    while (stream >> re >> sign >> im) {
      return complex<double>(re, (sign == '-') ? -im : im);
    }
  }

  return complex<double>(0, 0);
}

void ConstraintReader::Print() { std::cout << "Constraint object: " << this->m_constraint << "\n"; }