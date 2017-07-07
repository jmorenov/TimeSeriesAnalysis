#define ARMA_NO_DEBUG

// [[Rcpp::depends(RcppArmadillo, BH, bigmemory)]]
#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

#include <bigmemory/BigMatrix.h>

void ComputeMatrix(const Mat<double>& inBigMat, Mat<double> outBigExp, Mat<double> outBigPot, double alpha) {
  int W = inBigMat.n_rows;
  double d, di;
  for(int i = 0; i < W - 1; i++) {
    di = 1;
    for(int j=i+1; j < W; j++) {
      outBigExp(j,i) = outBigExp(i,j) = d = exp(sum(pow((inBigMat.row(i) - inBigMat.row(j)),2)));
      d = pow(d, -alpha);
      di += d;
      outBigPot(j) += d;
    }
    outBigPot(i) = di;
  }
}

// [[Rcpp::export]]
RObject ChiuMethod(SEXP data_r, SEXP exponential_r, SEXP potential_r, double r_a = 0.5, double eps_high = 0.5, double eps_low = 0.15) {
  Rcpp::XPtr<BigMatrix> data_p(data_r);
  Rcpp::XPtr<BigMatrix> exponential_p(exponential_r);
  Rcpp::XPtr<BigMatrix> potential_p(potential_r);
  arma::Mat<double> data = arma::Mat<double>((double *)data_p->matrix(), data_p->nrow(), data_p->ncol(), false);
  arma::Mat<double> exponential = arma::Mat<double>((double *)exponential_p->matrix(), exponential_p->nrow(), exponential_p->ncol(), false);
  arma::Mat<double> potential = arma::Mat<double>((double *)potential_p->matrix(), potential_p->nrow(), potential_p->ncol(), false);
  double alpha = 4 / (r_a * r_a);
  double beta = 4 / ((1.5 * r_a) * (1.5 * r_a));
  int n = data.n_rows;
  ComputeMatrix(data, exponential, potential, alpha);

  NumericVector centers_index = NumericVector();
  return centers_index;
  // NumericVector centers_index = NumericVector::create(which_max(potential));
//     centers.index <- c(which.max(potential))
//     k1 <- centers.index[1]
//   pot_k1 <- potential[k1]
//   for (i in 2:n) {
//     potential <- potential - (potential[k1]*(exponential[,k1] ^ -beta))
//     k <-  which.max(potential)
//     pot_k <- potential[k]
//
//     if (pot_k > eps.high * pot_k1) {
//       centers.index <- c(centers.index, k)
//       k1 <- k
//       pot_k1 <- pot_k
//     } else if (pot_k < eps.low * pot_k1) break
//       else {
//         dmin <- min(mapply(centers.index, FUN = function(x) dist(rbind(data[k,], data[x,]))))
//         if ((dmin/r.a) + (pot_k/pot_k1) >= 1) {
//           centers.index <- c(centers.index, k)
//           k1 <- k
//           pot_k1 <- pot_k
//         }
//         else potential[k] <- 0
//       }
//   }
//   data <- DataCollection$new(data)
//     r <- DataCollection$new(ncols = data$cols())
//     for (i in centers.index)
//       r$addRow(data$getRow(i))
}
