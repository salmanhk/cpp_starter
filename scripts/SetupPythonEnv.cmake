# IN-TERMINAL PLOTTING WITH PYTHON
set(VENV_PATH "${CMAKE_SOURCE_DIR}/venv")

# Check the platform and set the Python executable accordingly
if(WIN32)
  set(PYTHON_EXECUTABLE "py")
else()
  set(PYTHON_EXECUTABLE "python3")
endif()

# Check if the virtual environment already exists
if(NOT EXISTS "${VENV_PATH}/Scripts")
  # if virtual environment does not exist, so create it
  execute_process(
    COMMAND ${PYTHON_EXECUTABLE} -m venv ${VENV_PATH}
    RESULT_VARIABLE VENV_CREATION_RESULT
  )
  
  # check if the virtual environment was created successfully
  if(NOT VENV_CREATION_RESULT STREQUAL "0")
    message(FATAL_ERROR "Failed to create the virtual environment.")
  endif()
endif()

# Define pip executable path based on the platform
if(WIN32)
  set(PIP_EXECUTABLE "${VENV_PATH}/Scripts/pip")
else()
  set(PIP_EXECUTABLE "${VENV_PATH}/bin/pip")
endif()

# install the dependencies using pip from the virtual environment
execute_process(
  COMMAND ${PIP_EXECUTABLE} install -r "${CMAKE_SOURCE_DIR}/requirements.txt"
  RESULT_VARIABLE PIP_INSTALL_RESULT
)

# check if the dependencies were installed successfully
if(NOT PIP_INSTALL_RESULT STREQUAL "0")
  message(FATAL_ERROR "Failed to install the required Python packages.")
endif()
