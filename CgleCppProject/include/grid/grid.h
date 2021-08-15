#pragma once

#include <memory>
#include "Eigen/Dense"

using namespace std;

namespace grid {
    /**
     * @brief GridDetails encapsulates various details including dimensions, size, ... etc
     * 
     **/
    class GridDetails {
        public:
            /** Specifies the number of dimensions associated to the given grid **/
            enum class GridDimensions { TwoDimensions, ThreeDimensions, FourDimensions};

            /**
             * @brief Creates a new grid details object 
             * 
             **/ 
            GridDetails() : m_num_x_points(m_DEFAULT_GRID_SIZE_X),
                            m_num_y_points(m_DEFAULT_GRID_SIZE_Y),
                            m_num_z_points(m_DEFAULT_GRID_SIZE_Z),
                            m_dx(m_DEFAULT_GRID_DX),
                            m_dy(m_DEFAULT_GRID_DY),
                            m_dz(m_DEFAULT_GRID_DZ)
            {
                // default case hence we define a 2 dimensional grid
                m_dimensions = GridDimensions::TwoDimensions;
            };

            /**
             * @brief Creates a new grid details object based on specified input parameters
             *  
             * 
             * @param  {int} grid_size_x      : number of elements on x axis
             * @param  {int} grid_size_y      : number of elements on y axis
             * @param  {int} grid_size_z      : number of elements on z axis
             * @param  {int} totalNumberOfPts : number of elements across all grid
             */
            GridDetails(int grid_size_x, 
                        int grid_size_y, 
                        int grid_size_z, 
                        int totalNumberOfPts): m_num_x_points(grid_size_x),
                                               m_num_y_points(grid_size_y),
                                               m_num_z_points(grid_size_z)
            {
                // we dont add the 0 clause for the z dimension since it is ok to have a 2D grid
                if(m_num_x_points == 0 || m_num_y_points == 0 || totalNumberOfPts == 0){
                    throw std::invalid_argument("invalid input argument");
                }                

                // if no dimensional spacing is provided, we automatically compute it based on the total number of points
                m_dx = totalNumberOfPts/m_num_x_points;
                m_dy = totalNumberOfPts/m_num_y_points;
                
                if(m_num_z_points != 0){
                    m_dz = totalNumberOfPts/m_num_z_points;
                }
                
                SetGridDimension();
            }
            /**
             * @brief creates a grid details object  
             * 
             * @param  {int} grid_size_x : number of elements in x axis
             * @param  {int} grid_size_y : number of elements in y axis
             * @param  {int} grid_size_z : number of elements in z axis
             * @param  {double} dx       : space between elements on x axis
             * @param  {double} dy       : space between elements on y axis
             * @param  {double} dz       : space between elements on z axis
             */
            GridDetails(int grid_size_x, 
                        int grid_size_y, 
                        int grid_size_z, 
                        double dx,
                        double dy,
                        double dz): m_num_x_points(grid_size_x),
                                    m_num_y_points(grid_size_y),
                                    m_num_z_points(grid_size_z),
                                    m_dx(dx),
                                    m_dy(dy),
                                    m_dz(dz)
            {
               SetGridDimension();
            }

        private:
            // define the default grid parametersß
            const int m_DEFAULT_GRID_SIZE_X = 100;
            const int m_DEFAULT_GRID_SIZE_Y = 100;
            const int m_DEFAULT_GRID_SIZE_Z = 0;
            const double m_DEFAULT_GRID_DX = 1.0;
            const double m_DEFAULT_GRID_DY = 1.0; 
            const double m_DEFAULT_GRID_DZ = 0.0;
            const int m_DEFAULT_NUM_PTS = 100;
            
            GridDimensions m_dimensions;
            int m_num_x_points;
            int m_num_y_points;
            int m_num_z_points;
            double m_dx;
            double m_dy;
            double m_dz;
            /**
             * @brief sets the grid dimension enum
             */
            void SetGridDimension(){
                if(m_num_z_points != 0 && m_dz != 0){
                    m_dimensions = GridDimensions::ThreeDimensions;
                } else {
                    m_dimensions = GridDimensions::TwoDimensions;
                }
            };
    };

    class Grid {
        public:
            /**
             * @brief generates a grid object
             * 
             */
            Grid(){
                m_details = make_unique<GridDetails>();
                m_grid = Eigen::MatrixXcf(m_details->m_num_x_points, m_details->m_num_y_points);
            };

            
            /**
             * @brief generates a grid object 
             * 
             * @param  {int} num_x_pts : number of points on x axis
             * @param  {int} num_y_pts : number of points on y axis
             * @param  {int} num_z_pts : number of points on z axis
             * @param  {int} num_pts   : total number of points across the entire grid
             */
            Grid(int num_x_pts, int num_y_pts, int num_z_pts, int num_pts){
                m_details = make_unique<GridDetails>(num_x_pts, num_y_pts, num_z_pts, num_pts);
                m_grid = Eigen::MatrixXcf(m_details->m_num_x_points, m_details->m_num_y_points);
            };

            /**
             * @brief generates a grid object 
             * 
             * @param  {int} num_x_pts : number of points on x axis
             * @param  {int} num_y_pts : number of points on y axis
             * @param  {int} num_z_pts : number of points on z axis
             * @param  {double} dx     : space between points on x axis
             * @param  {double} dy     : space between points on y axis
             * @param  {double} dz     : space between points on z axis
             */
            Grid(int num_x_pts, int num_y_pts, int num_z_pts, double dx, double dy, double dz){
                m_details = make_unique<GridDetails>(num_x_pts, num_y_pts, num_z_pts, dx, dy, dz);
                m_grid = Eigen::MatrixXcf(m_details->m_num_x_points, m_details->m_num_y_points);
            }

        private:
            unique_ptr<GridDetails> m_details;
            Eigen::MatrixXcf m_grid, m_perturbed_grid;
    };

}