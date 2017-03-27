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
    char* outfile = argv[2];
    printf("n := %d | output := \"%s\"\n", n, outfile);
    
    // Open the output file
    FILE *out = fopen(outfile, "wb");
    if (!out) { printf("Error while opening %s\n", outfile); exit(1); }

    // Generate points from both classes    
    for (int i=0; i<n; i++) {
        double x, y;
        int class = i < n/2 ? 0 : 1;

        do { 
            x = uniform_rand(-RADIUS, RADIUS);
            y = uniform_rand(-RADIUS, RADIUS);
        } while (rho(x,y) > RADIUS || classify(x,y) != class); 

        fprintf(out, "%f, %f, %d\n", x, y, class);

    }

    fclose(out);
    printf("Finished!\n");
    return 0;
}
