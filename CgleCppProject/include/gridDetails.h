#pragma once

#include <constraint.h>
#include <functionHandler.h>

#include <memory>
#include <vector>

#include "Eigen/Dense"
#include "helper.h"

namespace CGLE {
  /**
   * @brief GridDetails encapsulates various details including dimensions, size, ... etc
   *
   **/
  class GridDetails {
  public:
    /** Specifies the number of dimensions associated to the given grid **/
    enum class GridDimensions { TwoDimensions, ThreeDimensions };

    /**
     * @brief Creates a new grid details object with default values
     *
     **/
    GridDetails();

    /**
     * @brief Creates a new grid details object based on specified input parameters
     *
     *
     * @param  {int} grid_size_x      : max size of x axis
     * @param  {int} grid_size_y      : max size of y axis
     * @param  {int} totalNumberOfPts : number of elements across all grid
     */
    GridDetails(int grid_size_x, int grid_size_y, int totalNumberOfPts);

    /**
     * @brief creates a grid details object
     *
     * @param  {int} grid_size_x : number of elements in x axis
     * @param  {int} grid_size_y : number of elements in y axis
     * @param  {double} dx       : space between elements on x axis
     * @param  {double} dy       : space between elements on y axis
     */
    GridDetails(int grid_size_x, int grid_size_y, double dx, double dy);
    /**
     * GridDetails defines a grid details object based on input parameters
     *
     * @param  {int} startTime     :  start time of the simulationß
     * @param  {int} endTime       :  end time of the simulation
     * @param  {int} startPosition :  start position of the simulation
     * @param  {int} endPosition   :  end position of the simulation
     */
    GridDetails(int startTime, int endTime, int startPosition, int endPosition);
    /**
     * @brief Gets the number of x points on the grid details object
     * @return {int} : number of points on the x axis
     */
    int GetNumXPts() const;

    /**
     * @brief Gets the number of y points on the grid details object
     * @return {int}  : number of points on the y axis
     */
    int GetNumYPts() const;

  private:
    GridDimensions m_dimensions;
    int m_num_x_points;
    int m_num_y_points;
    double m_dx;
    double m_dy;

    int m_interval_start_time;
    int m_interval_end_time;
    int m_start_pos;
    int m_end_pos;

    vector<double> m_time_pts;
    vector<double> m_x_pts;

    /**
     * @brief sets the grid dimension enum
     */
    void SetGridDimension();
    /**
     * @brief Populates the time and positional vectors
     * @param  {int} startTime           :  Start time of the simulation
     * @param  {int} endTime             :  End time of the simulation
     * @param  {int} startPosition       :  Start position of the simulation
     * @param  {int} endPosition         :  End position of the simulation
     * @param  {int} totalNumberOfPoints :  Total number of points between the start and end
     * position of both time and positions
     */
    void PopulateTimeAndPositionalVectors(int startTime, int endTime, int startPosition,
                                          int endPosition, int totalNumberOfPoints);
  };

}  // namespace CGLE
