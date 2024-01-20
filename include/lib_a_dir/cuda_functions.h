// cuda_functions.h

#ifndef CUDA_FUNCTIONS_H
#define CUDA_FUNCTIONS_H

// Declare your CUDA function
extern "C" void addWithCuda(int* c, const int* a, const int* b, int size);

#endif // CUDA_FUNCTIONS_H
