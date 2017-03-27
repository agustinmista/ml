#include <math.h>
#include <time.h>

// Initializes the random number generator
void init_random();

// Calculate the normal probabillity of x using 
// mean mu and standard deviation sigma
double gauss(double x, double mu, double sigma);

// Generate a random double in the range [lower,upper)
double uniform_rand(double lower, double upper);

// Generate a random double under a normal distribution
// with mean mu and standard deviationn sigma
double normal_rand(double mu, double sigma);
