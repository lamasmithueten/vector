CC             = gcc
NVCC           = nvcc

CFLAGS_VECTOR  = -O3 -march=native -mtune=native
CFLAGS_NORMAL  = -O3 -march=native -mtune=native -ffast-math -flto
CFLAGS_OMP     = -O3 -march=native -mtune=native -ffast-math -flto -fopenmp
CFLAGS_NVCC    = -O3 -Wno-deprecated-gpu-targets -use_fast_math -Xcompiler -march=native

SRC_VECTOR     = input/input.c
SRC_NORMAL     = normal/vector.c normal/header/csv.c
SRC_OMP        = openmp/vector.c openmp/header/csv.c
SRC_NVCC       = cuda/vector.cu cuda/header/csv.cu

OUTPUT_VECTOR  = vector_gen
OUTPUT_NORMAL  = vector
OUTPUT_OMP     = vector_omp
OUTPUT_NVCC    = vector_cuda

VECTOR_ONE     = vector1.csv 
VECTOR_TWO     = vector2.csv

VECTOR_SIZE    = 65536
LOOP_SIZE      = 10000000

FILES_TO_CHECK := $(VECTOR_ONE) $(VECTOR_TWO)

all: set_size $(OUTPUT_VECTOR) $(OUTPUT_NORMAL) $(OUTPUT_OMP) $(OUTPUT_NVCC) create_input

set_size: 
	find . -name "*.h" -exec sed -i -E 's/SIZE [0-9]+/SIZE $(VECTOR_SIZE)/g' {} \;
	find . -name "*.c" -exec sed -i -E 's/SIZE [0-9]+/SIZE $(VECTOR_SIZE)/g' {} \;
	find . -name "*.cu" -exec sed -i -E 's/SIZE [0-9]+/SIZE $(VECTOR_SIZE)/g' {} \;
	find -name "*.h" -exec sed -i -E 's/i[ ]*<[ ]*[0-9]+/i<$(LOOP_SIZE)/g' {} \;
	find -name "*.c" -exec sed -i -E 's/i[ ]*<[ ]*[0-9]+/i<$(LOOP_SIZE)/g' {} \;
	find -name "*.cu" -exec sed -i -E 's/i[ ]*<[ ]*[0-9]+/i<$(LOOP_SIZE)/g' {} \;

$(OUTPUT_VECTOR): $(SRC_VECTOR)
	$(CC) $(CFLAGS_VECTOR) -o $(OUTPUT_VECTOR) $(SRC_VECTOR)

$(OUTPUT_NVCC): $(SRC_NVCC)
	$(NVCC) $(CFLAGS_NVCC) -o $(OUTPUT_NVCC) $(SRC_NVCC)

$(OUTPUT_NORMAL): $(SRC_NORMAL)
	$(CC) $(CFLAGS_NORMAL) -o $(OUTPUT_NORMAL) $(SRC_NORMAL)

$(OUTPUT_OMP): $(SRC_OMP)
	$(CC) $(CFLAGS_OMP) -o $(OUTPUT_OMP) $(SRC_OMP)

create_input:
	[[ -f $(VECTOR_ONE) && -f $(VECTOR_TWO) ]] && printf "Files exist\n" || ./$(OUTPUT_VECTOR) $(VECTOR_ONE) $(VECTOR_TWO)
clean:
	rm -rf $(OUTPUT_VECTOR) $(OUTPUT_NORMAL) $(OUTPUT_OMP) $(VECTOR_ONE) $(VECTOR_TWO) *.csv *.txt

time:
	bash -c	"time ./$(OUTPUT_NORMAL) $(VECTOR_ONE) $(VECTOR_TWO) "
	bash -c "time ./$(OUTPUT_OMP)  $(VECTOR_ONE) $(VECTOR_TWO)"
	bash -c "time ./$(OUTPUT_NVCC) $(VECTOR_ONE) $(VECTOR_TWO)"

pretty:	
	find . -name "*.h" -exec clang-format -i {} \;
	find . -name "*.c" -exec clang-format -i {} \;
	find . -name "*.cu" -exec clang-format -i {} \;
