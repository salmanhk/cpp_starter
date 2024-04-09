#pragma once

#include "pch.h"
#include "plot.pb.h"

int plot_lines(const std::vector<std::vector<double>>& data, 
               const std::vector<std::string>& legends, 
               const std::string& title);

int plot_lines(const Eigen::Ref<Eigen::MatrixXd> M, 
               const std::vector<std::string>& legends, 
               const std::string& title);
