#include <Rcpp.h>
using namespace Rcpp;

double clust_diff(NumericVector& c1, NumericVector& c2) {
  double elements = 0;
  double max = std::max(c1.size(), c2.size());
  for(NumericVector::iterator i = c1.begin(); i != c1.end(); ++i) {
    for(NumericVector::iterator j = c2.begin(); j != c2.end(); ++j) {
      if (*i == *j) elements++;
    }
  }
  return (elements/max)*100;
}

// [[Rcpp::export]]
RObject compareClustering(SEXP groups_1_v, int ncenters_1, SEXP groups_2_v, int ncenters_2) {
  Rcpp::NumericVector groups_1(groups_1_v);
  Rcpp::NumericVector groups_2(groups_2_v);

  std::vector<NumericVector > centers_1(ncenters_1);
  std::vector<NumericVector > centers_2(ncenters_2);
  int n_groups = groups_1.size();
  if (n_groups > groups_2.size())
    n_groups = groups_2.size();
  for (int i=0; i<n_groups; i++) {
    centers_1[groups_1(i) - 1].push_back(i);
    centers_2[groups_2(i) - 1].push_back(i);
  }
  NumericMatrix centers = NumericMatrix(ncenters_1, ncenters_2);
  NumericMatrix max_centers = NumericMatrix(ncenters_1, 2);

  for (int i = 0; i < ncenters_1; i++) {
    for (int j = 0; j < ncenters_2; j++) {
      centers(i,j) = clust_diff(centers_1[i], centers_2[j]);
    }
    if (max(centers.row(i)) != 0) {
      max_centers(i,0) = max(centers.row(i));
      max_centers(i,1) = which_max(centers.row(i)) + 1;
    }
  }
  return List::create(_["centers"]  = centers, _["max_centers"]  = max_centers, _["centers_1"] = centers_1, _["centers_2"] = centers_2);
}
