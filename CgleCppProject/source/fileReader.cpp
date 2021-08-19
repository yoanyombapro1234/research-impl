#pragma once
#include <constants.h>
#include <constraint.h>
#include <fileReader.h>

#include <algorithm>
#include <ifstream>
#include <string>
using namespace Reader;

ConstraintReader::ConstraintReader(string& filePath) : m_filePath(std::move(filePath)) {}

void ConstraintReader::ProcessConstraint(int* numProcessedConstraints, const string& value,
                                         std::unique_ptr<complex<double>>& cmplxValue) {
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
      this->m_constraint.m_k1 = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 9:
      this->m_constraint.m_K1 = std::stod(value);
      break;
    case 10:
      this->m_constraint.m_K2 = std::stod(value);
      break;
    case 11:
      this->m_constraint.m_W1 = cmplxValue != nullptr ? *cmplxValue.get() : 0;
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
      this->m_constraint.m_Gamma1 = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 19:
      this->m_constraint.m_Gamma1Prime = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 20:
      this->m_constraint.m_P1 = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 21:
      this->m_constraint.m_P1Prime = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 22:
      this->m_constraint.m_Q1 = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 23:
      this->m_constraint.m_Q2 = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 24:
      this->m_constraint.m_Q1Prime = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
    case 24:
      this->m_constraint.m_Q2Prime = cmplxValue != nullptr ? *cmplxValue.get() : 0;
      break;
  }

  *numProcessedConstraints++
}

void ConstraintReader::ReadHelper() {
  ifstream readData(Constants::FILEPATH);
  if (!readData.is_open())
    throw runtime_error("Error opening file containing constraint configurations");

  string line;
  std::string delimiter = "=";
  int pos = 0;
  int processedConstraints = 0;

  while (getline(readData, line)) {
    while ((pos = s.find(delimiter)) != std::string::npos) {
      string token = s.substr(0, pos);
      string value = s.substr(pos, s.length());
      std::unique_ptr<complex<double>> cmplxValue = TransformToCmplxValue(value);
      ProcessConstraint(&processedConstraints, value, cmplxValue)
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

bool ConstraintReader::IsOperator(const char& element) { return element == "-" || element == "+"; }

bool ConstraintReader::IsComplex(const string& val) {
  bool containsImaginaryValue = false;
  bool constainsOperator = false;

  return find_if(val.begin(), val.end(), [&](const char& element) {
    if (IsOperator(element)) {
      constainsOperator = true;
    }

    if (element == "i") {
      containsImaginaryValue = true;
    }

    // safe to assume if "i" is present and the value contains an operator, this is a complex number
    if (containsImaginaryValue && containsOperator) {
      return true;
    }

    return false;
  });
}

unique_ptr<complex<double>>& ConstraintReader::TransformToCmplxValue(const string& value) {
  // check if value is a complex value
  std::unique_ptr<complex<double>> cmplxValue;
  if (IsComplex(value)) {
    // obtain complev value;
    int re, im;
    char sign;
    std::stringstream stream(value);
    while (stream >> re >> sign >> im) {
      return std::make_unique<complex<double>>(re, (sign == '-') ? -im : im);
    }
  }

  return nullptr;
}

void ConstraintReader::Print() { std::cout << "Constraint object: " << this->m_constraint << "\n"; }