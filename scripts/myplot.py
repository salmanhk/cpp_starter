import os
import sys
import plotext as plt

#
current_script_dir = os.path.dirname(os.path.abspath(__file__))
project_dir = os.path.dirname(current_script_dir)
protobufs_dir_path = os.path.join(project_dir, 'build', 'protobufs')
sys.path.append(protobufs_dir_path)
from plot_pb2 import *


def plot_time_series(plot_data):
    for i, series in enumerate(plot_data.series):
        plt.plot(series.data, label=plot_data.legends[i] if plot_data.legends else None)
    plt.title(plot_data.title)
    plt.show()

if __name__ == "__main__":
    plot_data = PlotData()
    plot_data.ParseFromString(sys.stdin.buffer.read())
    plot_time_series(plot_data)

