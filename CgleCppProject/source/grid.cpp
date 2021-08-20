#include <grid.h>

#include <iterator>
#include <vector>
using namespace CGLE;
using namespace std;

Grid::Grid(Constraint& constraint) {
  m_details = make_unique<GridDetails>();
  m_grid = Eigen::MatrixXcd(double(m_details->GetNumXPts()), double(m_details->GetNumYPts()));
  m_functHdl = make_unique<FunctionHandler>(constraint);
  m_perturbed_gridA = m_grid;
  m_perturbed_gridB = m_grid;
  m_grid_groundtruthA = m_grid;
  m_grid_groundtruthB = m_grid;
};

Grid::Grid(int num_x_pts, int num_y_pts, int num_z_pts, int num_pts, Constraint& constraint) {
  m_details = make_unique<GridDetails>(num_x_pts, num_y_pts, num_z_pts, num_pts);
  m_grid = Eigen::MatrixXcd(double(m_details->GetNumXPts()), double(m_details->GetNumYPts()));
  m_functHdl = make_unique<FunctionHandler>(constraint);
  m_perturbed_gridA = m_grid;
  m_perturbed_gridB = m_grid;
  m_grid_groundtruthA = m_grid;
  m_grid_groundtruthB = m_grid;
};

Grid::Grid(int num_x_pts, int num_y_pts, int num_z_pts, double dx, double dy, double dz,
           Constraint& constraint) {
  m_details = make_unique<GridDetails>(num_x_pts, num_y_pts, num_z_pts, dx, dy, dz);
  m_grid = Eigen::MatrixXcd(double(m_details->GetNumXPts()), double(m_details->GetNumYPts()));
  m_functHdl = make_unique<FunctionHandler>(constraint);
  m_perturbed_gridA = m_grid;
  m_perturbed_gridB = m_grid;
  m_grid_groundtruthA = m_grid;
  m_grid_groundtruthB = m_grid;
}

void Grid::PerturbGrid(const double pertubationCoefficient) {
  for (int xPoint = 0; xPoint < this->m_details->GetNumXPts(); xPoint++) {
    for (int timePoint = 0; timePoint < this->m_details->GetNumYPts(); timePoint++) {
      Cell cell(xPoint, timePoint);
      auto posValue = this->m_details->m_x_pts.at(xPoint);
      auto timeValue = this->m_details->m_time_pts.at(timePoint);
      this->PerturbGridHelper(posValue, timeValue, cell, pertubationCoefficient);
    }
  }
}

void Grid::PerturbGridHelper(const double& position, const double& time, const Cell& cell,
                             double pertubationCoefficient) {
  if (time < 0) throw invalid_argument("time cannot be negative");

  complex<double> amplitudeA = this->m_functHdl->A()(position, time);
  complex<double> amplitudeB = this->m_functHdl->B()(position, time);

  if (position == 0 || time == 0) {
    double noiseValue = 1 + (pertubationCoefficient * Helper::GenerateRandomNumber<double>(0, 1));
    this->m_perturbed_gridA(cell.x, cell.y) = amplitudeA * (noiseValue);
    this->m_perturbed_gridB(cell.x, cell.y) = amplitudeB * (noiseValue);
  } else {
    this->m_perturbed_gridA(cell.x, cell.y) = amplitudeA;
    this->m_perturbed_gridB(cell.x, cell.y) = amplitudeB;
  }

  // populate the ground truth waves
  this->m_grid_groundtruthA(cell.x, cell.y) = amplitudeA;
  this->m_grid_groundtruthB(cell.x, cell.y) = amplitudeB;
}