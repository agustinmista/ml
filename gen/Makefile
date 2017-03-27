all:
	gcc -Wall -lm -std=gnu99 -D_GNU_SOURCE random.c diag.c -o diag
	gcc -Wall -lm -std=gnu99 -D_GNU_SOURCE random.c vert.c -o vert
	gcc -Wall -lm -std=gnu99 -D_GNU_SOURCE random.c spiral.c -o spiral
	chmod +x plot.R
	chmod +x run_tests.sh
