#pragma once
#include <constraint.h>

using namespace Parameter;

std::ostream& operator<<(std::ostream& o, Constraint const& constraint) {
  return o << constraint.m_Alpha;
}