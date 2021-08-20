#pragma once

#include <complex>
#include <memory>
#include <string>
#include <vector>

using namespace std;

namespace CGLE {
  class Constraint {
  public:
    friend std::ostream& operator<<(std::ostream& o, Constraint const& constraint);
    /**
     * @brief Constraint instantiates a new constraint object
     *
     */
    Constraint() {}
    /**
     * Constraint instantiates a new constraint object
     *
     * @param  {int} caseType                :
     * @param  {string} caseLetter           :
     * @param  {string} waveType             :
     * @param  {int} version                 :
     * @param  {int} startTime               :
     * @param  {int} endTime                 :
     * @param  {int} startPosition           :
     * @param  {int} endPosition             :
     * @param  {double} L                    :
     * @param  {complex<double>} k1          :
     * @param  {double} K1                   :
     * @param  {double} K2                   :
     * @param  {complex<double>} W1          :
     * @param  {double} eta                  :
     * @param  {double} mu                   :
     * @param  {double} omega1               :
     * @param  {double} omega2               :
     * @param  {double} beta                 :
     * @param  {double} alpha                :
     * @param  {double} q2r                  :
     * @param  {complex<double>} gamma1      :
     * @param  {complex<double>} gamma1prime :
     * @param  {complex<double>} p1          :
     * @param  {complex<double>} p1prime     :
     * @param  {complex<double>} q1          :
     * @param  {complex<double>} q2          :
     * @param  {complex<double>} q1prime     :
     * @param  {complex<double>} q2prime     :
     */
    Constraint(int caseType, string caseLetter, string waveType, int version, int startTime,
               int endTime, int startPosition, int endPosition, double L, complex<double> k1,
               double K1, double K2, complex<double> W1, double eta, double mu, double omega1,
               double omega2, double beta, double alpha, double q2r, complex<double> gamma1,
               complex<double> gamma1prime, complex<double> p1, complex<double> p1prime,
               complex<double> q1, complex<double> q2, complex<double> q1prime,
               complex<double> q2prime)
        : m_CaseType(caseType),
          m_CaseLetter(caseLetter),
          m_WaveType(waveType),
          m_Version(version),
          m_StartTime(startTime),
          m_EndTime(endTime),
          m_StartPosition(startPosition),
          m_EndPosition(endPosition),
          m_L(L),
          m_k1(k1),
          m_K1(K1),
          m_K2(K2),
          m_W1(W1),
          m_Eta(eta),
          m_Mu(mu),
          m_Omega1(omega1),
          m_Omega2(omega2),
          m_Beta(beta),
          m_Alpha(alpha),
          m_Q2r(q2r),
          m_Gamma1(gamma1),
          m_Gamma1Prime(gamma1prime),
          m_P1(p1),
          m_P1Prime(p1prime),
          m_Q1(q1),
          m_Q2(q2),
          m_Q1Prime(q1prime),
          m_Q2Prime(q2prime) {}

    int m_CaseType;
    string m_CaseLetter;
    string m_WaveType;
    int m_Version;

    int m_StartTime;
    int m_EndTime;
    int m_StartPosition;
    int m_EndPosition;

    double m_L;
    complex<double> m_k1;
    double m_K1, m_K2;
    complex<double> m_W1;
    double m_Eta;
    double m_Mu;
    double m_Omega1;
    double m_Omega2;
    double m_Beta;
    double m_Alpha;
    double m_Q2r;
    complex<double> m_Gamma1;
    complex<double> m_Gamma1Prime;
    complex<double> m_P1;
    complex<double> m_P1Prime;
    complex<double> m_Q1;
    complex<double> m_Q2;
    complex<double> m_Q1Prime;
    complex<double> m_Q2Prime;
  };
}  // namespace CGLE