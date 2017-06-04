/*
nb_n.c : Clasificador Naive Bayes usando la aproximacion de funciones normales 
para features continuos.
Formato de datos: c4.5
La clase a predecir tiene que ser un numero comenzando de 0: por ejemplo, para 
3 clases, las clases deben ser 0,1,2

PMG - Ultima revision: 20/06/2001
*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>

#define LOW 1.e-14  /* Minimo valor posible para una probabilidad. */
#define PI  3.141592653

#define ERROR(s)    exit((perror(s), -1))

int N_IN;       /* Total number of inputs. */
int N_Class;    /* Total number of classes (outputs). */

int PTOT;       /* Cantidad TOTAL de patrones en el archivo .data. */
int PR;         /* Cantidad de patrones de ENTRENAMIENTO. */
int PTEST;      /* Cantidad de patrones de TEST (archivo .test). */
                /* Cantidad de patrones de VALIDACION: PTOT - PR. */

int SEED;       /* Semilla para la funcion rand(). Los posibles valores son:
                 *  -1: No mezclar los patrones: usar los primeros PR para
                 *      entrenar y el resto para validar. Toma la semilla del 
                 *      rand con el reloj.
                 *   0: Seleccionar semilla con el reloj, y mezclar los 
                 *      patrones.
                 *  >0: Usa el numero leido como semilla, y mezcla los 
                 *      patrones. 
                 */

int CONTROL;    /* Nivel de verbosity: 
                 *  0 -> resumen, 
                 *  1 -> 0 + pesos, 
                 *  2 -> 1 + datos 
                 */

int N_TOTAL;    /* Numero de patrones a usar durante el entrenamiento. */
int N_BINS;     /* Cantidad de bins a utilizar por cada dimension */

/* Matrices globales */
double *class_prior; /* Probabilidad a priori de cada clase */
double **class_mean; /* Valor medio de cada atributo de cada clase*/
double **class_sdev; /* Desviacion estandar de cada atributo de cada clase*/

double **data;  /* Train data. */
double **test;  /* Test  data. */
int *pred;      /* Clases predichas. */
int *seq;      	/* Sequencia de presentacion de los patrones. */

/* Variables globales auxiliares. */
char filepat[100];


/* Obtiene la clase de un patron */
int get_class(int pat) { return (int) data[pat][N_IN]; }

/* ------------------------------------------------------------------------- */
/* define_matrix: reserva espacio en memoria para todas las matrices 
 * declaradas. Todas las dimensiones son leidas del archivo .nb en           */
/* ------------------------------------------------------------------------- */
void define_matrix() { 

    int i, max;
    
    max = PTOT > PTEST ? PTOT : PTEST;

    seq  = (int *) calloc(max, sizeof(int));
    pred = (int *) calloc(max, sizeof(int));
  
    data = (double **) calloc(PTOT, sizeof(double *));
    test = (double **) calloc(PTEST, sizeof(double *));
    
    for (i=0; i<PTOT;  i++) data[i] = (double *) calloc(N_IN+1, sizeof(double));
    for (i=0; i<PTEST; i++) test[i] = (double *) calloc(N_IN+1, sizeof(double));

    /*ALLOCAR ESPACIO PARA LAS MATRICES DEL ALGORITMO*/
    class_prior = (double *) calloc(N_Class, sizeof(double)); 
    class_mean  = (double **) calloc(N_Class, sizeof(double *));
    class_sdev  = (double **) calloc(N_Class, sizeof(double *));

    for (i=0; i<N_Class; i++) class_mean[i] = (double *) calloc(N_IN, sizeof(double));
    for (i=0; i<N_Class; i++) class_sdev[i] = (double *) calloc(N_IN, sizeof(double));
}

/* ------------------------------------------------------------------------- */
/* arquitec: Lee el archivo .nb e inicializa el algoritmo en funcion de los 
 * valores leidos filename es el nombre del archivo .nb (sin la extension)   */
/* ------------------------------------------------------------------------- */
void arquitec(char *filename) {
    FILE *b;
    time_t t;

    /* Paso 1: leer el archivo con la configuracion. */
    sprintf(filepat, "%s.nb", filename);
    if (!(b = fopen(filepat, "r"))) 
        ERROR("Error al abrir el archivo de parametros.\n");

    /* Dimensiones. */
    fscanf(b, "%d",  &N_IN);
    fscanf(b, "%d",  &N_Class);

    /* Archivo de patrones: datos para train y para validacion. */
    fscanf(b, "%d", &PTOT);
    fscanf(b, "%d", &PR);
    fscanf(b, "%d", &PTEST);

    /* Semilla para la funcion rand()*/
    fscanf(b, "%d", &SEED);

    /* Nivel de verbosity*/
    fscanf(b, "%d", &CONTROL);

    fclose(b);

    /*Paso 2: Definir matrices para datos y parametros (e inicializarlos*/
    define_matrix();

    /* Chequear semilla para la funcion rand(). */
    if (SEED == 0) SEED = time(&t);

    /* Imprimir control por pantalla. */
    printf("\nNaive Bayes con distribuciones normales:"
           "\nCantidad de entradas:%d", N_IN);
    printf("\nCantidad de clases:%d", N_Class);
    printf("\nArchivo de patrones: %s", filename);
    printf("\nCantidad total de patrones: %d", PTOT);
    printf("\nCantidad de patrones de entrenamiento: %d", PR);
    printf("\nCantidad de patrones de validacion: %d", PTOT-PR);
    printf("\nCantidad de patrones de test: %d", PTEST);
    printf("\nSemilla para la funcion rand(): %d\n", SEED); 
}

/* ------------------------------------------------------------------------- */
/* read_data: lee los datos de los archivos de entrenamiento (.data) y test 
 * (.test). filename es el nombre de los archivos (sin extension). La cantidad 
 * de datos y la estructura de los archivos fue leida en la funcion arquitec()
 * Los registros en el archivo pueden estar separados por blancos ( o tab ) o 
 * por comas.                                                                */
/* ------------------------------------------------------------------------- */
void read_data(char *filename) {

    FILE *fpat;
    double valor;
    int i, k, separador;

    /* Leer el archivo de datos. */
    sprintf(filepat, "%s.data", filename);
    if (!(fpat = fopen(filepat, "r"))) 
        ERROR("Error al abrir el archivo de datos.\n");

    if (CONTROL > 1) printf("\nDatos de entrenamiento:");
    for (k=0; k<PTOT; k++) {
        if (CONTROL > 1) printf("\nP %d:\t", k);
        for (i=0; i<N_IN+1; i++) {
            fscanf(fpat, "%lf", &valor);
            data[k][i] = valor;
            if (CONTROL > 1) printf("%lf\t", data[k][i]);
            separador = getc(fpat);
            if (separador != ',') ungetc(separador, fpat);
        }
    }
    if (CONTROL > 1) printf("\nFin de los patrones de entrenamiento.\n");
    
    fclose(fpat);

    /* Leer el archivo de prueba si hace falta. */
    if (!PTEST) return;

    sprintf(filepat, "%s.test", filename);
    if (!(fpat = fopen(filepat, "r"))) 
        ERROR("Error al abrir el archivo de test.\n");

    if (CONTROL>1) printf("\nDatos de test:");
    for (k=0; k<PTEST; k++) {
        if (CONTROL>1) printf("\nP %d:\t", k);
        for (i=0; i<N_IN+1; i++) {
            fscanf(fpat, "%lf", &valor);
            test[k][i] = valor;
            if (CONTROL>1) printf("%lf\t", test[k][i]);
            separador = getc(fpat);
            if (separador!=',') ungetc(separador, fpat);
        }
    }
    if (CONTROL > 1) printf("\nFin de los patrones de prueba.\n");
    
    fclose(fpat);
}

/* ------------------------------------------------------------------------- */
/* shuffle: mezcla el vector seq al azar. El vector seq es un indice para 
 * acceder a los patrones. Los patrones mezclados van desde seq[0] hasta 
 * seq[hasta-1].  Esto permite separar la parte de validacion de la de train */
/* ------------------------------------------------------------------------- */
void shuffle(int hasta) {
    double x;
    int tmp;
    int top, select;

    top = hasta - 1;
    while (top > 0) {
	    x = (double) rand();
	    x /= RAND_MAX;
	    x *= top + 1;
	    select = (int) x;
	    tmp = seq[top];
	    seq[top] = seq[select];
	    seq[select] = tmp;
	    top --;
    } 

    if(CONTROL>3) { printf("End shuffle.\n"); fflush(NULL); }
}

/* ------------------------------------------------------------------------- */
/* prob: Calcula la probabilidad de obtener el valor x para el input feature y 
 * la clase clase. Aproxima las probabilidades por distribuciones normales   */
/* ------------------------------------------------------------------------- */
double prob(double x, int feature, int clase) {
    double mean = class_mean[clase][feature];
    double var  = pow(class_sdev[clase][feature], 2);

    double factor = 1 / sqrt(2 * M_PI * var);
    double exponent = - pow(x - mean, 2) / (2 * var);

    return factor * exp(exponent);  
}

/* ------------------------------------------------------------------------- */
/* output: calcula la probabilidad de cada clase dado un vector de entrada 
 * input usa el log(p(x)) (sumado). Devuelve la de mayor probabilidad        */
/* ------------------------------------------------------------------------- */
int output(double *input) {
   	
    double prob_de_clase;
    double max_prob = -1e40;
    int i, k, clase_MAP;
  
    for (k=0; k<N_Class; k++) {
        prob_de_clase = 0.;

        /* Acumula la probabilidad de cada feature individual dada la clase. */
        for (i=0; i<N_IN; i++) prob_de_clase += log(prob(input[i], i, k));

        /* Agrega la probabilidad a priori de la clase. */
        prob_de_clase += log(class_prior[k]);

        /* Guarda la clase con prob maxima. */
        if (prob_de_clase >= max_prob) {
            max_prob = prob_de_clase;
            clase_MAP = k;
        }
    }
    
    return clase_MAP;
}

/* ------------------------------------------------------------------------- */
/* propagar: calcula las clases predichas para un conjunto de datos. La matriz 
 * S tiene que tener el formato adecuado (definido en arquitec()). pat_ini y 
 * pat_fin son los extremos a tomar en la matriz. usar_seq define si se accede
 * a los datos directamente o a travez del indice seq los resultados (las 
 * propagaciones) se guardan en la matriz seq.                               */
/* ------------------------------------------------------------------------- */
double propagar(double **S, int pat_ini, int pat_fin, int usar_seq) {

    double mse = 0.0;
    int nu;
    int patron;
  
    for (patron=pat_ini; patron<pat_fin; patron++) {

        /*nu tiene el numero del patron que se va a presentar*/
        nu = usar_seq ? seq[patron] : patron;

        /*clase MAP para el patron nu*/
        pred[nu] = output(S[nu]);

        /*actualizar error*/
        if (S[nu][N_IN] != (double) pred[nu]) mse+=1.;
    }
    
    mse /= (double) pat_fin-pat_ini;

    if (CONTROL > 3) { printf("End prop.\n"); fflush(NULL); }

    return mse;
}


/* ------------------------------------------------------------------------- */
/* train: ajusta los parametros del algoritmo a los datos de entrenamiento.
 * Guarda los parametros en un archivo de control. Calcula porcentaje de error
 * en ajuste y test.                                                         */
/* ------------------------------------------------------------------------- */
void train(char *filename) {
    int i, j, k, feature, clase;
    double sigma, me;
    double train_error, valid_error, test_error;
    FILE *salida, *fpredic;

    /* Asigno todos los patrones del .data como entrenamiento porque este 
     * metodo no requiere validacion. */
    N_TOTAL = PTOT;

    /* N_TOTAL = PR; si hay validacion. */
    /* inicializacion del indice de acceso a los datos. */
    for (k=0; k<PTOT; k++) seq[k] = k;

    /* Efectuar shuffle inicial de los datos de entrenamiento si 
     * SEED != -1 (y hay validacion). */
    if (SEED > -1 && N_TOTAL < PTOT) {
        srand((unsigned) SEED);    
        shuffle(PTOT);
    }

    /* Calcular probabilidad intrinseca de cada clase. */
    for (i=0; i<PTOT; i++) class_prior[get_class(i)]++;
    for (i=0; i<N_Class; i++) class_prior[i] /= PTOT;
    
    if (CONTROL > 1) { 
        printf("\nProbabilidades a priori de cada clase:\n");
        for (i=0; i<N_Class; i++) printf("Clase %d: %f\n", i, class_prior[i]);
    }

    /* Calcular media y desv.est. por clase y cada atributo. */
    for (k=0; k<N_IN; k++) {
        /*  Media */
        for (i=0; i<PTOT; i++) class_mean[get_class(i)][k] += data[i][k];
        for (i=0; i<N_Class; i++) class_mean[i][k] /= (PTOT * class_prior[i]);
        
        /*  Desviacion Estandar */
        for (i=0; i<PTOT; i++) class_sdev[get_class(i)][k] 
            += pow(data[i][k] - class_mean[get_class(i)][k], 2);
        for (i=0; i<N_Class; i++) class_sdev[i][k] 
            = sqrt(class_sdev[i][k] / (PTOT * class_prior[i]));
    } 

    if (CONTROL > 1) {
        printf("\nValor medio a priori de cada clase:\n");
        for (i=0; i<N_Class; i++) {
            printf("Clase %d: ", i);
            for (k=0; k<N_IN; k++) printf("%f\t", class_mean[i][k]);
            printf("\n");
        }
        
        printf("\nDesviacion Estandar a priori de cada clase:\n");
        for (i=0; i<N_Class; i++) {
            printf("Clase %d: ", i);
            for (k=0; k<N_IN; k++) printf("%f\t", class_sdev[i][k]);
            printf("\n");
        }
    }

    /* Calcular error de entrenamiento. */
    train_error = propagar(data, 0, PR, 1);
    
    /* Calcular error de validacion; si no hay, usar mse_train. */
    valid_error = PR == PTOT ? train_error : propagar(data, PR, PTOT, 1); 
    
    /* Calcular error de test (si hay). */
    test_error = PTEST ? propagar(test, 0, PTEST, 0) : 0.;  

    /* Mostrar errores. */
    printf("\nFin del entrenamiento.\n\n");
    printf("Errores:\nEntrenamiento:%f%%\n", train_error*100.);
    printf("Validacion:%f%%\nTest:%f%%\n", valid_error*100., test_error*100.);
    if (CONTROL) fflush(NULL);

    /* Guardar archivo de predicciones. */
    sprintf(filepat, "%s.predic", filename);
    if (!(fpredic = fopen(filepat, "w"))) 
        ERROR("Error al abrir archivo para guardar predicciones.\n");

    for (k=0; k < PTEST ; k++) {
        for(i=0; i< N_IN; i++) fprintf(fpredic, "%f\t", test[k][i]);
        fprintf(fpredic, "%d\n", pred[k]);
    }
    
    fclose(fpredic);

    return;
}

/* ------------------------------------------------------------------------- */
int main(int argc, char **argv) {

    if (argc != 2) {
        printf("Modo de uso: nb <filename>\n"
               "Donde filename es el nombre del archivo (sin extension)\n");
        return 0;
    }

    /* Defino la estructura. */
    arquitec(argv[1]);

    /* Leo los datos. */
    read_data(argv[1]);

    /* Ajusto los parametros y calcula errores en ajuste y test. */
    train(argv[1]);

    return 0;
}
