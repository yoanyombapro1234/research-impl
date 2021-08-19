#pragma once

#include <constraint.h>
#include <functionHandler.h>

#include <memory>
#include <vector>

#include "Eigen/Dense"
#include "helper.h"

namespace CGLE {

  /**
   * @brief Cell serves as an abstraction of the concept of a cell in a grid
   */
  struct Cell {
    /**
     * Cell instantiates a cell object
     *
     * @param  {int} xVal :  x position of the cell
     * @param  {int} yVal :  y position of the cell
     */
    Cell(int xVal, int yVal) : x(xVal), y(yVal) {}

    bool operator==(const Cell& that) const { return x == that.x && y == that.x; }

    int x, y;
  };
}  // namespace CGLE