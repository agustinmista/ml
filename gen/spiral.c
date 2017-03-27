#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

#include "random.h"

#define RADIUS 1.0


// Print simple usage message
void print_usage(char *exe) { 
    printf("Usage: %s [SIZE] [OUTPUT]\n", exe); 
}

double rho(double x, double y) { return sqrt(pow(x,2) + pow(y,2));  }

double theta(double x, double y) { return atan2l (y, x); }

int classify(double x, double y) { 
    double below = theta(x,y) / (4 * M_PI);
    double above = (theta(x,y) + M_PI) / (4 * M_PI);

    for (int i=0; i<M_PI*RADIUS; i++) {
        if (rho(x,y) > below && rho(x,y) < above) return 1;
        below += 0.5;
        above += 0.5;
    }

    return 0;
}


int main(int argc, char **argv) {

    init_random();

    // Check for stdin args    
    if (argc != 3) { print_usage(argv[0]); exit(1); }
    
    int n = atoi(argv[1]);
    char *output = argv[2];
    printf("n := %d | output := \"%s\"\n", n, output);
    
    // Create the output filenames
    char *data_path, *names_path;
    asprintf(&data_path, "%s.data", output);
    asprintf(&names_path, "%s.names", output);
    
    // Generate the data file
    FILE *data_file = fopen(data_path, "wb");
    if (!data_file) { printf("Error while opening %s\n", data_path); exit(1); }

    // Append points from both classes    
    for (int i=0; i<n; i++) {
        double x, y;
        int class = i < n/2 ? 0 : 1;

        do { 
            x = uniform_rand(-RADIUS, RADIUS);
            y = uniform_rand(-RADIUS, RADIUS);
        } while (rho(x,y) > RADIUS || classify(x,y) != class); 

        fprintf(data_file, "%f, %f, %d\n", x, y, class);

    }
    
    // Generate the header file
    FILE *names_file = fopen(names_path, "wb");
    if (!names_file) { printf("Error while opening %s\n", names_path); exit(1); }
    
    fprintf(names_file, "0, 1.\n");
    for (int i=0; i<2; i++) fprintf(names_file, "x%d: continous.\n", i);

    // Cleanup
    fclose(data_file);
    fclose(names_file);
    printf("Finished!\n");
    return 0;
}
