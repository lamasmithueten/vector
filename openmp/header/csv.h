#ifndef CSV_H_
#define CSV_H_

void readVectorFromCSV(const char * filename, int * vector);
void writeVectorToCSV(const char * filename, int * vector);
void writeScalarToFile(const char * filename, long * scalar);

#endif
