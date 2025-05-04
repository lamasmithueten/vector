CC             = gcc

CFLAGS_VECTOR  = -O3 -march=native -mtune=native
CFLAGS_NORMAL  = -O3 -march=native -mtune=native
CFLAGS_OMP     = -O3 -march=native -mtune=native -fopenmp

SRC_VECTOR     = input/input.c
SRC_NORMAL     = normal/vector.c normal/header/csv.c
SRC_OMP        = openmp/vector.c openmp/header/csv.c

OUTPUT_VECTOR  = vector_gen
OUTPUT_NORMAL  = vector
OUTPUT_OMP     = vector_omp

VECTOR_ONE     = vector1.csv 
VECTOR_TWO     = vector2.csv

SIZE           = 10000000

FILES_TO_CHECK := $(VECTOR_ONE) $(VECTOR_TWO)

all: set_size $(OUTPUT_VECTOR) $(OUTPUT_NORMAL) $(OUTPUT_OMP) create_input

set_size: 
	find . -name "*.h" -exec sed -i -E 's/SIZE [0-9]+/SIZE $(SIZE)/g' {} \;
	find . -name "*.c" -exec sed -i -E 's/SIZE [0-9]+/SIZE $(SIZE)/g' {} \;

$(OUTPUT_VECTOR): $(SRC_VECTOR)
	$(CC) $(CFLAGS_VECTOR) -o $(OUTPUT_VECTOR) $(SRC_VECTOR)

$(OUTPUT_NORMAL): $(SRC_NORMAL)
	$(CC) $(CFLAGS_NORMAL) -o $(OUTPUT_NORMAL) $(SRC_NORMAL)

$(OUTPUT_OMP): $(SRC_OMP)
	$(CC) $(CFLAGS_OMP) -o $(OUTPUT_OMP) $(SRC_OMP)

create_input:
	[[ -f $(VECTOR_ONE) && -f $(VECTOR_TWO) ]] && printf "Files exist\n" || ./$(OUTPUT_VECTOR) $(VECTOR_ONE) $(VECTOR_TWO)
clean:
	rm -rf $(OUTPUT_VECTOR) $(OUTPUT_NORMAL) $(OUTPUT_OMP) $(VECTOR_ONE) $(VECTOR_TWO) *.csv *.txt
