// File: src_dir/lib_a_src/adder.cpp

#include "helpers.h"

Eigen::MatrixXd std_vec_to_eigen_matrix(const std::vector<std::vector<double>>& vv)
{
  auto nc = vv.size();
  auto nr = vv[0].size();
  Eigen::MatrixXd M = Eigen::MatrixXd::Zero(nr, nc);
  for (int c = 0; c < nc; c++) {
    for (int r = 0; r < nr; r++) {
      M(r, c) = vv[c][r];
    }
  }

  return M;    
}

std::vector<std::vector<double>> 
eigen_matrix_to_std_vec(const Eigen::Ref<Eigen::MatrixXd> M) 
{
    std::vector<std::vector<double>> vv(M.cols(), std::vector<double>(M.rows(), 0.));

    for (int c = 0; c < M.cols(); ++c)
        for (int r = 0; r < M.rows(); ++r)
            vv[c][r] = M(r, c);

    return vv;
}



