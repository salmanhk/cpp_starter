set(VENV_PATH "${CMAKE_SOURCE_DIR}/venv")

if(WIN32)
  set(VENV_SUBDIR "Scripts")
  set(PYTHON_EXECUTABLE_NAME "python.exe")
else()
  set(VENV_SUBDIR "bin")
  set(PYTHON_EXECUTABLE_NAME "python3")
endif()

add_compile_definitions(VENV_DIR="${CMAKE_SOURCE_DIR}/venv/${VENV_SUBDIR}")

set(PIP_EXECUTABLE "${VENV_PATH}/${VENV_SUBDIR}/pip")
set(PYTHON_EXECUTABLE "${VENV_PATH}/${VENV_SUBDIR}/${PYTHON_EXECUTABLE_NAME}")

# check if the platform-specific venv directory exists
if(NOT EXISTS "${VENV_PATH}/${VENV_SUBDIR}")
  # we assume that some version of python already exists on the system
  if(WIN32)
    find_program(SYSTEM_PYTHON_EXECUTABLE NAMES python python3 python.exe python3.exe)
  else()
    set(SYSTEM_PYTHON_EXECUTABLE "python3")
  endif()

  if(SYSTEM_PYTHON_EXECUTABLE STREQUAL "SYSTEM_PYTHON_EXECUTABLE-NOTFOUND")
    message(FATAL_ERROR "System Python executable not found.")
  else()
    # create venv with system python executable
    execute_process(
      COMMAND ${SYSTEM_PYTHON_EXECUTABLE} -m venv ${VENV_PATH}
      RESULT_VARIABLE VENV_CREATION_RESULT
    )

    if(NOT VENV_CREATION_RESULT STREQUAL "0")
      message(FATAL_ERROR "Failed to create the virtual environment.")
    endif()
  endif()
endif()

# install deps with venv pip
execute_process(
  COMMAND ${PIP_EXECUTABLE} install -r "${CMAKE_SOURCE_DIR}/requirements.txt"
  RESULT_VARIABLE PIP_INSTALL_RESULT
  OUTPUT_VARIABLE PIP_INSTALL_OUTPUT
  ERROR_VARIABLE PIP_INSTALL_ERROR
)

if(NOT PIP_INSTALL_RESULT STREQUAL "0")
  message(FATAL_ERROR "Failed to install the required Python packages. Error: ${PIP_INSTALL_ERROR}")
else()
  message(STATUS "Successfully installed Python packages: ${PIP_INSTALL_OUTPUT}")
endif()
