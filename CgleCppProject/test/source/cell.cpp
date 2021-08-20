#include <cell.h>
#include <doctest/doctest.h>

#include <string>

TEST_CASE("Cell Initialization") {
  using namespace CGLE;

  int xval, yval;
  xval = 0;
  yval = 0;
  Cell cell(xval, yval);

  CHECK(cell.x == xval);
  CHECK(cell.y == yval);
}

TEST_CASE("Cell Equality Check") {
  using namespace CGLE;

  int scenario1Xval, scenario1Yval, scenario2Xval, scenario2Yval;
  scenario1Xval = 0;
  scenario1Xval = 0;
  scenario2Xval = 0;
  scenario2Yval = 0;

  Cell cell1(scenario1Xval, scenario1Yval);
  Cell cell2(scenario2Xval, scenario2Yval);
  CHECK(cell1 == cell2);

  cell1.x = 3;
  cell1.y = 3;
  CHECK(cell1 != cell2);
}