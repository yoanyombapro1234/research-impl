#pragma once

#include <cell.h>
#include <constraint.h>
#include <functionHandler.h>
#include <gridDetails.h>

#include <Eigen/Dense>
#include <memory>
#include <vector>

#include "helper.h"

using namespace std;

namespace CGLE {
  class Grid {
  public:
    /**
     * @brief generates a grid object
     *
     * @param  {Constraint} constraint : Object outlining grid constraints
     */
    Grid(Constraint& constraint);

    /**
     * @brief generates a grid object
     *
     * @param  {int} num_x_pts : number of points on x axis
     * @param  {int} num_y_pts : number of points on y axis
     * @param  {int} num_z_pts : number of points on z axis
     * @param  {int} num_pts   : total number of points across the entire grid
     * @param  {Constraint} constraint : Object outlining grid constraints
     */
    Grid(int num_x_pts, int num_y_pts, int num_z_pts, int num_pts, Constraint& constraint);

    /**
     * @brief generates a grid object
     *
     * @param  {int} num_x_pts : number of points on x axis
     * @param  {int} num_y_pts : number of points on y axis
     * @param  {int} num_z_pts : number of points on z axis
     * @param  {double} dx     : space between points on x axis
     * @param  {double} dy     : space between points on y axis
     * @param  {double} dz     : space between points on z axis
     * @param  {Constraint} constraint : Object outlining grid constraints
     */
    Grid(int num_x_pts, int num_y_pts, int num_z_pts, double dx, double dy, double dz,
         Constraint& constraint);

    /**
     * PerturbGrid perturbs the grid meaning computes the amplitude with some jitter at
     * all points where x =0 and time = 0:maxTime and t=0 and x=0:maxPos
     *
     * @param  {double} pertubationCoefficient : pertubation coefficient representing the percent
     * error necessary to add to the boundaries. To represent a 20% pertubation error for instance,
     * pass in 0.2
     */
    void PerturbGrid(const double pertubationCoefficient);

  private:
    /**
     * PerturbGridHelper serves as a helper function for grid pertubation
     *
     * @param  {double} position : positional point useful to generate amplitude
     * @param  {double} time     : time point useful to generate amplitude
     * @param  {Cell} cell       : cell delineating the positional point and time point where we
     * should generate the amplitude
     */
    void PerturbGridHelper(const double& position, const double& time, const Cell& cell,
                           double pertubationCoefficient);

    unique_ptr<FunctionHandler> m_functHdl;
    unique_ptr<GridDetails> m_details;
    Eigen::MatrixXcf m_grid, m_perturbed_gridA, m_perturbed_gridB, m_grid_groundtruthA,
        m_grid_groundtruthB;
  };

}  // namespace CGLE