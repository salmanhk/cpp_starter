#pragma once

#include "pch.h"

Eigen::MatrixXd std_vec_to_eigen_matrix(const std::vector<std::vector<double>>& vv);

std::vector<std::vector<double>> 
eigen_matrix_to_std_vec(const Eigen::Ref<Eigen::MatrixXd> M);
