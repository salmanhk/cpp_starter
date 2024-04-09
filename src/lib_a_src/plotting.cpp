#include "plotting.h"
#include "helpers.h"


int plot_lines(const Eigen::Ref<Eigen::MatrixXd> data, 
               const std::vector<std::string>& legends, 
               const std::string& title) 
{
    auto vv = eigen_matrix_to_std_vec(data);
    return plot_lines(vv, legends, title);
}

int plot_lines(const std::vector<std::vector<double>>& data, 
               const std::vector<std::string>& legends, 
               const std::string& title) 
{

  GOOGLE_PROTOBUF_VERIFY_VERSION;

  PlotData plotData;
  plotData.set_title(title);

  for (auto & legend: legends) {
    *plotData.add_legends() = legend;
  }

  for (auto & d: data) {
    auto series = plotData.add_series();
    for (auto& val : d)
        series->add_data(val);
  }

  // serialize 
  std::string serializedData;
  if (!plotData.SerializeToString(&serializedData)) {
    std::cerr << "Failed to serialize data.\n";
    return -1;
  }

  std::string tempFilePath = VENV_DIR "/temp_plot_data.bin"; 

  std::ofstream tempFile(tempFilePath, std::ios::binary | std::ios::out);
  if (!tempFile.write(serializedData.data(), serializedData.size())) {
    std::cerr << "Failed to write serialized data to temp file.\n";
    return -1;
  }
  tempFile.close();

#if defined(_WIN32)
  std::string command =
      VENV_DIR "\\python.exe " SCRIPTS_DIR "\\lineplot.py " + tempFilePath;
  std::cout << command << '\n';
#else
  std::string command = "python " SCRIPTS_DIR "/lineplot.py " + tempFilePath;
#endif

  system(command.c_str());
  std::remove(tempFilePath.c_str());

  google::protobuf::ShutdownProtobufLibrary();

  return 0;

}

