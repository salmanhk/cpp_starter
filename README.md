# CPP Starter

This project is a C++ template designed to kickstart cross-platform development with ease. It leverages the power of CMake for building and testing and vcpkg manifest for dependency management. The structure is Dockerized for Linux, ensuring seamless development and testing within Visual Studio Code Remote - Containers. It is also compatible with Visual Studio on Windows as a CMake project.

## Prerequisites

- [CMake](https://cmake.org/download/) for building the project
- [vcpkg](https://github.com/microsoft/vcpkg) for managing C++ libraries
- [Docker](https://www.docker.com/get-started) for containerization (required for Linux)
- [Visual Studio Code](https://code.visualstudio.com/) with the [Remote - Containers extension](https://code.visualstudio.com/docs/remote/containers) for development

## Caveats

On Windows in Debug configuration, the project will compile but DuckDB calls will crash program at runtime. No problems otherwise.

## Getting Started

To get started, clone the repository to your local machine using your preferred method.

### Configuration

Before building the project, you need to configure it with the dependencies. Run the following script to configure the project:

```sh
./scripts/configure.sh
```

This script will set up the necessary configurations for building the project.

### Building the Project

To build the project, execute:

```sh
./scripts/build.sh
```

This will compile the project and generate the required executables.

### Running the Project

After building the project, you can run the main console application using:

```sh
./scripts/run.sh
```

This script executes the compiled `console` executable.

### Running Tests

To ensure your build passes all the tests, use the following command:

```sh
./scripts/run_tests.sh
```

This will execute the test suite defined in the project.

### Cleaning Build Artifacts

If you need to clean the build directory to start a fresh build, simply run:

```sh
./scripts/clean.sh
```

This script will delete the `build` directory, removing all compiled binaries and artifacts.

## Docker and VSCode Remote Containers

The project is ready to be used with Docker, especially when working on Linux. A `Dockerfile` is provided to create a development environment consistent across any platform.

For a smooth development experience in VSCode, open the repository in a Remote Container. This will ensure all dependencies and toolchains are set up exactly as they should be, regardless of your host system.

## CUDA (not tested on Linux)
There is a CUDA sample that can be compiled. The CUDA toolkit needs to be installed and discoverable by find_package. The WITH_CUDA variable can be set in the CMakeSettings.json file. This has not been tested on Linux.

## Cross-Platform Compatibility

The project is designed to be cross-platform, compatible with both Windows and Linux. All scripts and code are prepared to be run on either operating system with no modifications needed.

If you see the following error while configuring the project on Windows:

```
Severity	Code	Description	Project	File	Line	Suppression State	Details
Error		CMake Error at C:/vcpkg/scripts/buildsystems/vcpkg.cmake:899 (message):
  vcpkg install failed.  See logs for more information:
  C:\Users\sk\home\dev\repos_pn\starter_projects\cpp_starter\build\x64-win-debug\vcpkg-manifest-install.log		C:/vcpkg/scripts/buildsystems/vcpkg.cmake	899		
```

Go to your vcpkg directory and do a `git fetch`.



## License

Distributed under the MIT License. See `LICENSE` for more information.

## Acknowledgements

- [CMake](https://cmake.org/)
- [vcpkg](https://github.com/microsoft/vcpkg)
- [Docker](https://www.docker.com/)
- [Microsoft's VSCode](https://code.visualstudio.com/)

