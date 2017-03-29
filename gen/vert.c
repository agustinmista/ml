#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#include "random.h"

// Print simple usage message
void print_usage(char *exe) { 
    printf("Usage: %s [DIM] [SIZE] [DEV] [OUTPUT]\n", exe); 
}


int main(int argc, char **argv) {

    init_random();

    // Check for stdin args    
    if (argc != 5) { print_usage(argv[0]); exit(1); }
    
    int d = atoi(argv[1]);
    int n = atoi(argv[2]);
    double C = atof(argv[3]);
    double sigma = C * sqrt(d);
    char *output = argv[4];
    
    if (C <= 0) { printf("Constant C must be positive. Aborting.\n"); exit(1); } 
    
    printf("Generating dateset:\n"
           "\td := %d\n"
           "\tn := %d\n"
           "\tsigma := %f\n"
           "\toutput := \"%s\"\n", 
            d, n, sigma, output);
    
    // Create the output filenames
    char *data_path, *names_path;
    asprintf(&data_path, "%s.data", output);
    asprintf(&names_path, "%s.names", output);
    
    // Open the .data file
    FILE *data_file = fopen(data_path, "wb");
    if (!data_file) { printf("Error while opening %s\n", data_path); exit(1); }
    
    // Append 0-class values centered on (-1, 0, ... , 0)
    int zeroes = n / 2;
    for (int i=0; i < zeroes; i++) { 
        fprintf(data_file, "%f,\t", normal_rand(-1, sigma));
        for (int j=1; j<d; j++) fprintf(data_file, "%f,\t", normal_rand(0, sigma));
        fprintf(data_file, "0\n");
    }

    // Append 1-class values centered on (1, 0, ... , 0)
    int ones = n - zeroes;
    for (int i=0; i < ones; i++) { 
        fprintf(data_file, "%f,\t", normal_rand(1, sigma));
        for (int j=1; j<d; j++) fprintf(data_file, "%f,\t", normal_rand(0, sigma));
        fprintf(data_file, "1\n");
    }

    // Open the .names file
    FILE *names_file = fopen(names_path, "wb");
    if (!names_file) { printf("Error while opening %s\n", names_path); exit(1); }
    
    // Append classes and vars identifiers.
    fprintf(names_file, "0, 1.\n");
    for (int i=0; i<d; i++) fprintf(names_file, "x%d: continous.\n", i);

    // Cleanup
    fclose(data_file);
    fclose(names_file);
    printf("Finished!\n");
    return 0;
}
