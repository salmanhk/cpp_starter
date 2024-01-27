#include <cuda_runtime.h>

__global__ void addKernel(int* c, const int* a, const int* b, int size) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < size) {
    c[i] = a[i] + b[i];
  }
}

extern "C" void addWithCuda(int* c, const int* a, const int* b, int size) {
  int* dev_a = nullptr;
  int* dev_b = nullptr;
  int* dev_c = nullptr;

  // Allocate GPU buffers for three vectors (two input, one output).
  cudaMalloc((void**)&dev_c, size * sizeof(int));
  cudaMalloc((void**)&dev_a, size * sizeof(int));
  cudaMalloc((void**)&dev_b, size * sizeof(int));

  // Copy input vectors from host memory to GPU buffers.
  cudaMemcpy(dev_a, a, size * sizeof(int), cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, b, size * sizeof(int), cudaMemcpyHostToDevice);

  // Launch a kernel on the GPU.
  int threadsPerBlock = 256;
  int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;
  addKernel << <blocksPerGrid, threadsPerBlock >> > (dev_c, dev_a, dev_b, size);

  // cudaDeviceSynchronize waits for the kernel to finish, and returns
  // any errors encountered during the launch.
  cudaDeviceSynchronize();

  // Copy output vector from GPU buffer to host memory.
  cudaMemcpy(c, dev_c, size * sizeof(int), cudaMemcpyDeviceToHost);

  cudaFree(dev_c);
  cudaFree(dev_a);
  cudaFree(dev_b);
}
