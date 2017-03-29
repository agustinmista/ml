all:
	gcc -Wall -std=gnu99 -D_GNU_SOURCE random.c diag.c -o diag -lm
	gcc -Wall -std=gnu99 -D_GNU_SOURCE random.c vert.c -o vert -lm
	gcc -Wall -std=gnu99 -D_GNU_SOURCE random.c spiral.c -o spiral -lm
	chmod +x plot.R
	chmod +x run_tests.sh
