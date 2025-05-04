#include "header/config.h"
#include "header/csv.h"
#include <stdlib.h>
#include <stdio.h>
#include <omp.h>

void vectorAddition(int * A, int * B, int * result){
	for (int i = 0; i < SIZE; i++){
		result[i] = A[i] + B[i];
	}
}

void vectorSubtraction(int * A, int * B, int * result){
	for (int i = 0; i < SIZE; i++){
		result[i] = A[i] - B[i];
	}
}

long dotProduct(int * A, int * B){
	long result =0;
	for (int i = 0; i < SIZE; i++){
		result += (long)  (A[i] * B[i]);
	}
	return result;
}


int main(int argc, char **argv){
	if (argc != 3){
		fprintf(stderr, "Usage: %s <vector1.csv> <vector2.csv>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	int * vectorA = (int *) malloc(SIZE * sizeof(int));
	int * vectorB = (int *) malloc(SIZE * sizeof(int));
	int * result = (int *) malloc(SIZE * sizeof(int));
	long dotProductResult = 0;


	readVectorFromCSV(argv[1], vectorA);
	readVectorFromCSV(argv[2], vectorB);
#pragma omp parallel for
for (int i = 0; i<1000; i++){
	vectorAddition(vectorA, vectorB, result);
	}
	writeVectorToCSV("result_addition_omp.csv", result);

#pragma omp parallel for
for (int i = 0; i<1000; i++){
	vectorSubtraction(vectorA, vectorB, result);
	}
	writeVectorToCSV("result_subtraction_omp.csv", result);

#pragma omp parallel for
for (int i = 0; i<1000; i++){
	dotProductResult =dotProduct(vectorA, vectorB);
	}
	writeScalarToFile("result_dot_product_omp.txt", &dotProductResult);


	free(vectorA);
	free(vectorB);
	free(result);
	
	return EXIT_SUCCESS;
}
