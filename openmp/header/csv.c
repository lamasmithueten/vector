#include "csv.h"
#include <stdio.h>
#include <stdlib.h>
#include "config.h"


void readVectorFromCSV(const char * filename, int * vector){
	FILE * file = fopen(filename, "r");
	if (file == NULL ){
		perror("Failed to open file");
		exit(EXIT_FAILURE);
	}
	for (int i = 0; i < SIZE; i++){
		if (fscanf(file, "%d,", &vector[i]) != 1){
			fprintf(stderr, "Error reading file\n");
			fclose(file);
			exit(EXIT_FAILURE);
		}
	}
	
	fclose(file);
}
void writeVectorToCSV(const char * filename, int * vector){
	FILE * file = fopen(filename, "w");
	if (file == NULL){
		perror("Failed to open file");
		exit(EXIT_FAILURE);
	}
	for (int i = 0; i < SIZE; i++){
		fprintf(file, "%d", vector[i]);
		if (i < SIZE - 1){
			fprintf(file, ",");
		}
	}

	fprintf(file, "\n");

	fclose (file);

}

void writeScalarToFile(const char * filename, long * scalar){
	FILE * file = fopen(filename, "w");
	if (file == NULL){
		perror("Failed to open file");
		exit(EXIT_FAILURE);
	}
		fprintf(file, "%d", *scalar);

	fprintf(file, "\n");

	fclose (file);

}
