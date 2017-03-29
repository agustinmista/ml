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

// Cartesian to polar translations
double rho(double x, double y) { return sqrt(pow(x,2) + pow(y,2));  }
double theta(double x, double y) { return atan2l (y, x); }

// Classify a generated dot by checking if it belongs to the 1-class
// between the curves (theta / 4 * PI) and ((theta + PI) / (4 * PI)).
// If not, it belongs to 0-class.
int classify(double x, double y) { 
    
    // Calculate the first interval of pertenece in radians
    double below = theta(x,y) / (4 * M_PI);
    double above = (theta(x,y) + M_PI) / (4 * M_PI);

    // Check if the dot lies in some turn of the 1-class spiral.
    for (int i=0; i<M_PI*RADIUS; i++) {
        
        // If the dot radius lies between the bounds, then it belongs to 1-class.,
        if (rho(x,y) > below && rho(x,y) < above) return 1;
        
        // Update the bounds to the next turn of the spiral.
        // This is made using the fact that the curves defines 
        // archimedean spirals, of constant turn separation 
        // defined by (2*PI*b) with b = 1/4 in the given case.
        // Hence, the spiral separation equals to (2*PI*(1/4) = 0.5) radians
        below += 0.5;
        above += 0.5;
    
    }

    // In the case that the dot does not belongs to 
    // 1-class, it belongs to 0-class.
    return 0;
}


int main(int argc, char **argv) {

    init_random();

    // Check for stdin args    
    if (argc != 3) { print_usage(argv[0]); exit(1); }
    
    int n = atoi(argv[1]);
    char *output = argv[2];
    
    printf("Generating dataset:\n"
            "\tn := %d\n"
            "\toutput := \"%s\"\n",
            n, output);
    
    // Create the output filenames
    char *data_path, *names_path;
    asprintf(&data_path, "%s.data", output);
    asprintf(&names_path, "%s.names", output);
    
    // Open the .data file
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
    
    // Open the .names file
    FILE *names_file = fopen(names_path, "wb");
    if (!names_file) { printf("Error while opening %s\n", names_path); exit(1); }
    
    // Append classes and vars identifiers.
    fprintf(names_file, "0, 1.\n");
    for (int i=0; i<2; i++) fprintf(names_file, "x%d: continous.\n", i);

    // Cleanup
    fclose(data_file);
    fclose(names_file);
    printf("Finished!\n");
    return 0;
}
