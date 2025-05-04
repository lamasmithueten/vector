CC            = gcc

CFLAGS_VECTOR = -O3 -march=native -mtune=native
CFLAGS_NORMAL = -O3 -march=native -mtune=native

SRC_VECTOR    = input/input.c
SRC_NORMAL    = normal/vector.c normal/header/csv.c

OUTPUT_VECTOR = vector_gen
OUTPUT_NORMAL = vector

VECTOR_ONE    = vector1.csv 
VECTOR_TWO    = vector2.csv

all: $(OUTPUT_VECTOR) $(OUTPUT_NORMAL) create_input

$(OUTPUT_VECTOR): $(SRC_VECTOR)
	$(CC) $(CFLAGS_VECTOR) -o $(OUTPUT_VECTOR) $(SRC_VECTOR)

$(OUTPUT_NORMAL): $(SRC_NORMAL)
	$(CC) $(CFLAGS_NORMAL) -o $(OUTPUT_NORMAL) $(SRC_NORMAL)

create_input: $(OUTPUT_VECTOR)
	./$(OUTPUT_VECTOR) $(VECTOR_ONE) $(VECTOR_TWO)

clean:
	rm -rf $(OUTPUT_VECTOR) $(OUTPUT_NORMAL) $(VECTOR_ONE) $(VECTOR_TWO)
