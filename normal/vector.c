#include "header/config.h"
#include "header/csv.h"
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv){
	if (argc != 3){
		fprintf(stderr, "Usage: %s <vector1.csv> <vector2.csv>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	int * vectorA = (int *) malloc(SIZE * sizeof(int));
	int * vectorB = (int *) malloc(SIZE * sizeof(int));


	readVectorFromCSV(argv[1], vectorA);
	readVectorFromCSV(argv[2], vectorB);

	writeVectorToCSV("result1.csv", vectorA);
	writeVectorToCSV("result2.csv", vectorB);
	
	return EXIT_SUCCESS;
}
