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
    char* outfile = argv[4];
    
    printf("d := %d | n := %d | sigma := %f | output := \"%s\"\n", 
            d, n, sigma, outfile);

    
    // Open the output file
    FILE *out = fopen(outfile, "wb");
    if (!out) { printf("Error while opening %s\n", outfile); exit(1); }

    
    // Generate 0-class values centered on (-1, -1, ... , -1)
    int zeroes = n / 2;
    for (int i=0; i < zeroes; i++) { 
        for (int j=0; j<d; j++) fprintf(out, "%f,\t", normal_rand(-1, sigma));
        fprintf(out, "0\n");
    }

    // Generate 1-class values centered on (1, 1, ... , 1)
    int ones = n - zeroes;
    for (int i=0; i < ones; i++) { 
        for (int j=0; j<d; j++) fprintf(out, "%f,\t", normal_rand(1, sigma));
        fprintf(out, "1\n");
    }

    fclose(out);
    printf("Finished!\n");
    return 0;
}
