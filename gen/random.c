#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>


void init_random() { 
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    srand((time_t)ts.tv_nsec); 
}

double gauss(double x, double mu, double sigma) {
    double var = pow(sigma,  2);
    double denom = sqrt( 2 * M_PI * var);
    double num = exp( -pow(x-mu, 2) / (2*var) ) ;
    return num/denom;
}


double uniform_rand(double lower, double upper) {
    return lower + (rand() / ((double) RAND_MAX) * (upper-lower));
}


double normal_rand(double mu, double sigma){

    double lower = mu - 5 * sigma;
    double upper = mu + 5 * sigma;
    
    double x, y;

    do {
        x = uniform_rand(lower, upper);
        y = uniform_rand(0, 1);
    } while (y > gauss(x, mu, sigma));

    return x;
}




