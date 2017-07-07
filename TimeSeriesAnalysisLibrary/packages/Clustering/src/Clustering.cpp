#include <Rcpp.h>
using namespace Rcpp;


// [[Rcpp::export]]
std::vector<NumericVector > timeseries_in_centers(SEXP groups_v, int ncenters) {
  Rcpp::NumericVector groups(groups_v);
  std::vector<NumericVector > centers(ncenters);
  for (int i=0; i<ncenters; i++) {
    centers[groups(i) - 1].push_back(i);
  }
  return centers;
}
