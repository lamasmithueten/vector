#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#define SIZE 10000000

void createVector(const char * filename){
	FILE * file = fopen(filename, "w");
	if(file == NULL){
		perror("Failed to open file");
		exit(EXIT_FAILURE);	
	}

	for (int i = 0; i < SIZE; i++){
		fprintf(file, "%d", rand() % 99 + 1);
		if (i < SIZE-1){
			fprintf(file, ",");
		}
	}
	fprintf(file, "\n");

	fclose(file);
}

int main(int argc, char ** argv){
	if (argc !=3 ){
		fprintf(stderr, "Usage: %s <vector1.csv> <vector2.csv\n", argv[0]);
		exit(EXIT_FAILURE);
	}
	srand(time(0));

	createVector(argv[1]);
	createVector(argv[2]);

	return EXIT_SUCCESS;
}
