CC            = gcc

CFLAGS_VECTOR = -O3 -march=native -mtune=native

SRC_VECTOR    = input/input.c

OUTPUT_VECTOR = vector

VECTOR_ONE    = vector1.csv 
VECTOR_TWO    = vector2.csv

all: $(OUTPUT_VECTOR) create_input

$(OUTPUT_VECTOR): $(SRC_VECTOR)
	$(CC) $(CFLAGS_VECTOR) -o $(OUTPUT_VECTOR) $(SRC_VECTOR)

create_input: $(OUTPUT_VECTOR)
	./$(OUTPUT_VECTOR) $(VECTOR_ONE) $(VECTOR_TWO)

clean:
	rm -rf $(OUTPUT_VECTOR) $(VECTOR_ONE) $(VECTOR_TWO)
