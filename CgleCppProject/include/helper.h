#include <cmath>
#include <iomanip>
#include <iostream>
#include <map>
#include <random>
#include <string>
#include <vector>
using namespace std;

namespace Helper {
  /**
   * linspace Generate linearly spaced vectors
   * @param  {T} a             : The minimal element in the vector
   * @param  {T} b             : The maximal element in the vector
   * @param  {size_t} N        : The number of points between the the minimal and maximal elements
   * @return {std::vector<T>}  : The linearly spaced vector
   */
  template <typename T> static std::vector<T> linspace(T a, T b, size_t N) {
    T h = (b - a) / static_cast<T>(N - 1);
    std::vector<T> xs(N);
    typename std::vector<T>::iterator x;
    T val;
    for (x = xs.begin(), val = a; x != xs.end(); ++x, val += h) *x = val;
    return xs;
  }

  /**
   * Generates a random number in a specified range
   * @param  {T} startRange : the lower bound of the range
   * @param  {T} endRange   : the upper bound of the range
   * @return {T}            : the random number generated
   */
  template <typename T> static T GenerateRandomNumber(T startRange, T endRange) {
    // Seed with a real random value, if available
    std::random_device r;
    std::default_random_engine e1(r());
    std::uniform_real_distribution<T> uniform_dist(startRange, endRange);
    T randomValue = uniform_dist(e1);
    return randomValue;
  }
}  // namespace Helper
