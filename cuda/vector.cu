#include "header/config.h"
#include "header/csv.h"
#include <stdlib.h>
#include <stdio.h>
#include <cuda_runtime.h>

__global__ void vectorAddition(int * A, int * B, int * result){
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if(i < SIZE)
	result[i] = A[i] + B[i];
}

__global__ void vectorSubtraction(int * A, int * B, int * result){
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if(i < SIZE)
	result[i] = A[i] - B[i];
}

__global__ void dotProduct(int * A, int * B, long * result ){
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	if(i < SIZE)
	result[i] = A[i] * B[i];
}




int main(int argc, char **argv){
	if (argc != 3){
		fprintf(stderr, "Usage: %s <vector1.csv> <vector2.csv>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	int * vectorA = (int *) malloc(SIZE * sizeof(int));
	int * vectorB = (int *) malloc(SIZE * sizeof(int));
	int * result = (int *) malloc(SIZE * sizeof(int));
	int * d_vectorA, * d_vectorB, * d_result;
	long * dotProductPartialResult = (long *) malloc(SIZE*sizeof(long));
	long * d_dotProductPartialResult;
	long finalSum=0;
	int threadsPerBlock=16;
	int numBlocks= (SIZE + threadsPerBlock - 1) / threadsPerBlock;



	readVectorFromCSV(argv[1], vectorA);
	readVectorFromCSV(argv[2], vectorB);

	cudaMalloc((void **)&d_vectorA, SIZE*sizeof(int));
	cudaMalloc((void **)&d_vectorB, SIZE*sizeof(int));
	cudaMalloc((void **)&d_result, SIZE*sizeof(int));
	cudaMalloc((void **)&d_dotProductPartialResult,SIZE* sizeof(long));

	cudaMemcpy(d_vectorA, vectorA, SIZE*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(d_vectorB, vectorB, SIZE*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(d_result, result, SIZE*sizeof(int),cudaMemcpyHostToDevice);
	cudaMemcpy(d_dotProductPartialResult, dotProductPartialResult,SIZE* sizeof(long),cudaMemcpyHostToDevice);







for (int i = 0; i<1000; i++){
	vectorAddition<<<threadsPerBlock, numBlocks>>> (d_vectorA, d_vectorB, d_result);
	}
	cudaMemcpy(result, d_result, SIZE*sizeof(int), cudaMemcpyDeviceToHost);
	writeVectorToCSV("result_addition_cuda.csv", result);

for (int i = 0; i<1000; i++){
	vectorSubtraction<<<threadsPerBlock, numBlocks>>>(d_vectorA, d_vectorB, d_result);
	}
	cudaMemcpy(result, d_result, SIZE*sizeof(int), cudaMemcpyDeviceToHost);
	writeVectorToCSV("result_subtraction_cuda.csv", result);

for (int i = 0; i<1000; i++){
	dotProduct<<<threadsPerBlock, numBlocks>>>(d_vectorA, d_vectorB, d_dotProductPartialResult);
	}
	cudaMemcpy(dotProductPartialResult, d_dotProductPartialResult,SIZE* sizeof(long), cudaMemcpyDeviceToHost);
	for (int i = 0; i < SIZE; i++){
		finalSum += dotProductPartialResult[i];
	}
	writeScalarToFile("result_dot_product_cuda.txt", &finalSum);
	  //cudaDeviceSynchronize();


	  cudaFree(d_vectorA);
	  cudaFree(d_vectorB);
	  cudaFree(d_result);
	  cudaFree(d_dotProductPartialResult);

	free(vectorA);
	free(vectorB);
	free(result);
	free(dotProductPartialResult);

	
	return EXIT_SUCCESS;
}
