#include <Rcpp.h>
// [[Rcpp::depends(RcppParallel)]]
#include <RcppParallel.h>

using namespace Rcpp;
using namespace RcppParallel;

/*struct ComputeCenters : public Worker {

  const RVector<int> groups_1;
  const RVector<int> groups_2;

  std::vector<NumericVector > centers_1;
  std::vector<NumericVector > centers_2;

  ComputeCenters(const IntegerVector &groups_1,
                 const IntegerVector &groups_2,
                 std::vector<NumericVector > &centers_1,
                 std::vector<NumericVector > &centers_2)
    : groups_1(groups_1), groups_2(groups_2),
      centers_1(centers_1), centers_2(centers_2){}

  void operator()(std::size_t begin, std::size_t end) {
    for (std::size_t i = begin; i < end; i++) {
      centers_1[groups_1[i] - 1].push_back(i);
      centers_2[groups_2[i] - 1].push_back(i);
    }
  }

};*/


struct CompareClusterV2 : public Worker {

  const std::vector<NumericVector > centers_1;
  const std::vector<NumericVector > centers_2;

  RMatrix<double> centers;
  RMatrix<double> max_centers;

  double clust_diff(const NumericVector& c1, const NumericVector& c2) {
    double elements = 0;
    double max = std::max(c1.size(), c2.size());
    for(NumericVector::const_iterator i = c1.begin(); i != c1.end(); ++i) {
      for(NumericVector::const_iterator j = c2.begin(); j != c2.end(); ++j) {
        if (*i == *j) elements++;
      }
    }
    return (elements/max)*100;
  }

  struct max_value {
    double value;
    int pos;
  };

  max_value max(RcppParallel::RMatrix<double>::Row row) {
    max_value m;
    m.value = row[0];
    m.pos = 0;
    for (int i = 1; i < row.length(); i++) {
      if (m.value < row[i]) {
        m.value = row[i];
        m.pos = i;
      }
    }
    return m;
  }

  CompareClusterV2(const std::vector<NumericVector > &centers_1,
                 const std::vector<NumericVector > &centers_2,
                 NumericMatrix &centers,
                 NumericMatrix &max_centers)
    : centers_1(centers_1), centers_2(centers_2),
      centers(centers), max_centers(max_centers){}

  void operator()(std::size_t begin, std::size_t end) {
    for (std::size_t i = begin; i < end; i++) {
      max_value m;
      m.value = 0;
      double c;
      for (std::size_t j = 0; j < centers_2.size(); j++) {
        c = centers(i,j) = clust_diff(centers_1[i], centers_2[j]);
        if (m.value < c) {
          m.value = c;
          m.pos = j;
        }
      }
      if (m.value != 0) {
        max_centers(i,0) = m.value;
        max_centers(i,1) = m.pos + 1;
      }
    }
  }
};

// [[Rcpp::export]]
RObject compareParallelClusteringV2(SEXP groups_1_v, int ncenters_1, SEXP groups_2_v, int ncenters_2) {

  Rcpp::IntegerVector groups_1(groups_1_v);
  Rcpp::IntegerVector groups_2(groups_2_v);
  std::vector<NumericVector > centers_1(ncenters_1);
  std::vector<NumericVector > centers_2(ncenters_2);
  for (int i=0; i<groups_1.size(); i++) {
   centers_1[groups_1(i) - 1].push_back(i);
   centers_2[groups_2(i) - 1].push_back(i);
  }

  /*ComputeCenters compcenters(groups_1, groups_2, centers_1, centers_2);
  parallelFor(0, groups_1.size(), compcenters);*/

  NumericMatrix centers = NumericMatrix(ncenters_1, ncenters_2);
  NumericMatrix max_centers = NumericMatrix(ncenters_1, 2);
  CompareClusterV2 compclust(centers_1, centers_2, centers, max_centers);
  parallelFor(0, centers.length(), compclust);

  return List::create(_["centers"]  = centers, _["max_centers"]  = max_centers);
}
