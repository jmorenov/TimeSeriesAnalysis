#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
RObject ErrorForecast(SEXP data_forecast, SEXP centers_) {
  Rcpp::NumericMatrix data_f(data_forecast);
  Rcpp::List centers(centers_);
  NumericMatrix result = NumericMatrix(centers.size(), data_f.cols());
  for (int i = 0; i < result.rows(); i++) {
    NumericVector centers_i(centers[i]);
    for (int j = 0; j < result.cols(); j++) {
      double v = 0;
      for (int t = 0; t < centers_i.size(); t++) {
        v += data_f(centers_i[t], j);
      }
      v /= centers_i.size();
      result(i,j) = v;
    }
  }
  return result;
}

void R_init_TimeSeriesForecast(DllInfo* info) {
  R_registerRoutines(info, NULL, NULL, NULL, NULL);
  R_useDynamicSymbols(info, TRUE);
}
