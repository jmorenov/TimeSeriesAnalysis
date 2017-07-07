#define ARMA_NO_DEBUG

// [[Rcpp::depends(RcppArmadillo, BH, bigmemory)]]
#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

#include <bigmemory/BigMatrix.h>

void BigExpPot(const Mat<double>& inBigMat, Mat<double> outBigExp, Mat<double> outBigPot, double alpha) {
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
void BigExpPot(SEXP pInBigMat, SEXP pOutBigExp, SEXP pOutBigPot, double alpha) {
  XPtr<BigMatrix> xpMat(pInBigMat);
  XPtr<BigMatrix> xpOutExp(pOutBigExp);
  XPtr<BigMatrix> xpOutPot(pOutBigPot);

  BigExpPot(
    arma::Mat<double>((double *)xpMat->matrix(), xpMat->nrow(), xpMat->ncol(), false),
    arma::Mat<double>((double *)xpOutExp->matrix(), xpOutExp->nrow(), xpOutExp->ncol(), false),
    arma::Mat<double>((double *)xpOutPot->matrix(), xpOutPot->nrow(), xpOutPot->ncol(), false),
    alpha
  );
  return;
}
