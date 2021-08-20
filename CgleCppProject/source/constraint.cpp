#include <constraint.h>

using namespace CGLE;

std::ostream& operator<<(std::ostream& o, Constraint const& constraint) {
  return o << constraint.m_Alpha;
}