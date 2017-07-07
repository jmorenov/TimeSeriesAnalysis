#define ARMA_NO_DEBUG

// [[Rcpp::depends(RcppArmadillo, BH, bigmemory)]]
#include <RcppArmadillo.h>

using namespace Rcpp;
using namespace arma;

#include <bigmemory/BigMatrix.h>

template <typename T>
void BigArmaEuclidean(const Mat<T>& inBigMat, Mat<double> outBigMat) {
  int W = inBigMat.n_rows;
  for(int i = 0; i < W - 1; i++){
      for(int j = i + 1; j < W; j++){
        outBigMat(j,i) = outBigMat(i,j) = sqrt(sum(pow((inBigMat.row(i) - inBigMat.row(j)),2)));
      }
  }
}

// [[Rcpp::export]]
void BigArmaEuc(SEXP pInBigMat, SEXP pOutBigMat) {
  // First we tell Rcpp that the object we've been given is an external
  // pointer.
  XPtr<BigMatrix> xpMat(pInBigMat);
  XPtr<BigMatrix> xpOutMat(pOutBigMat);
  int type = xpMat->matrix_type();
  switch(type) {
  case 1:
    BigArmaEuclidean(
      arma::Mat<char>((char *)xpMat->matrix(), xpMat->nrow(), xpMat->ncol(), false),
      arma::Mat<double>((double *)xpOutMat->matrix(), xpOutMat->nrow(), xpOutMat->ncol(), false)
    );
    return;

  case 2:
    BigArmaEuclidean(
      arma::Mat<short>((short *)xpMat->matrix(), xpMat->nrow(), xpMat->ncol(), false),
      arma::Mat<double>((double *)xpOutMat->matrix(), xpOutMat->nrow(), xpOutMat->ncol(), false)
    );
    return;

  case 4:
    BigArmaEuclidean(
      arma::Mat<int>((int *)xpMat->matrix(), xpMat->nrow(), xpMat->ncol(), false),
      arma::Mat<double>((double *)xpOutMat->matrix(), xpOutMat->nrow(), xpOutMat->ncol(), false)
    );
    return;

  case 8:
    BigArmaEuclidean(
      arma::Mat<double>((double *)xpMat->matrix(), xpMat->nrow(), xpMat->ncol(), false),
      arma::Mat<double>((double *)xpOutMat->matrix(), xpOutMat->nrow(), xpOutMat->ncol(), false)
    );
    return;

  default:
    // We should never get here, but it resolves compiler warnings.
    throw Rcpp::exception("Undefined type for provided big.matrix");
  }
}
