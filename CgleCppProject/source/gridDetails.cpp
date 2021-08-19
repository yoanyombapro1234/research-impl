#pragma once
#include <grid/grid.h>
using namespace Grid;

GridDetails::GridDetails()
    : m_num_x_points(DEFAULT_MAX_POSITION),
      m_num_y_points(DEFAULT_MAX_TIME),
      m_dx(DEFAULT_GRID_DX),
      m_dy(DEFAULT_GRID_DY),
{
  this->PopulateTimeAndPositionalVectors(0, m_num_y_points, 0, m_num_x_points, DEFAULT_NUM_PTS);
  this->SetGridDimension();
};

GridDetails::GridDetails(int grid_size_x, int grid_size_y, int totalNumberOfPts)
    : m_num_x_points(std::move(grid_size_x)), m_num_y_points(std::move(grid_size_y)) {
  // we dont add the 0 clause for the z dimension since it is ok to have a 2D grid
  if (m_num_x_points == 0 || m_num_y_points == 0 || totalNumberOfPts == 0) {
    throw std::invalid_argument("invalid input argument");
  }

  // if no dimensional spacing is provided, we automatically compute it based on the total number of
  // points
  m_dx = totalNumberOfPts / m_num_x_points;
  m_dy = totalNumberOfPts / m_num_y_points;

  this->PopulateTimeAndPositionalVectors(0, m_num_y_points, 0, m_num_x_points, totalNumberOfPts);
  this->SetGridDimension();
}

GridDetails::GridDetails(int grid_size_x, int grid_size_y, double dx, double dy)
    : m_num_x_points(std::move(grid_size_x)),
      m_num_y_points(std::move(grid_size_y)),
      m_dx(std::move(dx)),
      m_dy(std::move(dy)) {
  double numPts, spacing;
  // populate the number of values in the x axis and time axis
  if (m_num_x_points != m_num_y_points) {
    // obtain the maximal points which will dictate the size of the x and y axis of our grid
    numPts = max(m_num_x_points, m_num_y_points);
    m_num_y_points = m_num_x_points = numPts;
  }

  // obtain the spacing between points (we only care about the minimal spacing) as we want a more
  // fine grid if available
  spacing = min(dx, dy);

  int totalNumberOfPts = numPts / spacing;
  this->PopulateTimeAndPositionalVectors(0, m_num_y_points, 0, m_num_x_points, totalNumberOfPts);
  this->SetGridDimension();
}

GridDetails::GridDetails(int startTime, int endTime, int startPosition, int endPosition)
    : m_interval_start_time(std::move(startTime)),
      m_interval_end_time(std::move(endTime)),
      m_start_pos(std::move(startPosition)),
      m_end_pos(std::move(endPosition)) {
  if (endTime <= startTime || endPosition <= startPosition) {
    throw std::invalid_argument("invalid input arguments");
  }

  // obtain the largest interval as our grid must be a square grid
  int totalNumberOfPts = max(m_interval_end_time - m_interval_start_time, endTime - startTime);
  m_num_x_points = m_num_y_points = totalNumberOfPts;

  // populate x pts and time pts
  this->PopulateTimeAndPositionalVectors(startTime, endTime, startPosition, endPosition,
                                         totalNumberOfPts);
  this->SetGridDimension();
}

int GridDetails::GetNumXPts() const { return m_num_x_points; }

int GridDetails::GetNumYPts() const { return m_num_y_points; }

void GridDetails::SetGridDimension() { m_dimensions = GridDimensions::TwoDimensions; }

void GridDetails::PopulateTimeAndPositionalVectors(int startTime, int endTime, int startPosition,
                                                   int endPosition, int totalNumberOfPoints) {
  if ((endTime - startTime) % 2 == 0) {
    auto leftHalf = Helper::linspace(startPosition, 0, (totalNumberOfPoints / 2) - 1);
    auto rightHalf = Helper::linspace(0, endPosition, (totalNumberOfPoints / 2) - 1);
    leftHalf.insert(leftHalf.end(), std::make_move_iterator(rightHalf.begin()),
                    std::make_move_iterator(rightHalf.end()));
    m_x_pts = leftHalf;
    m_time_pts = Helper::linspace(startTime, endTime, totalNumberOfPoints);
    return;
  }

  m_x_pts = Helper::linspace(startPosition, endPosition, totalNumberOfPoints);
  m_time_pts = Helper::linspace(startTime, endTime, totalNumberOfPoints);
}