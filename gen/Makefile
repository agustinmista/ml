all:
	gcc -Wall -std=gnu99 -D_GNU_SOURCE random.c diagonal.c -o diagonal -lm
	gcc -Wall -std=gnu99 -D_GNU_SOURCE random.c parallel.c -o parallel -lm
	gcc -Wall -std=gnu99 -D_GNU_SOURCE random.c spiral.c -o spiral -lm
	chmod +x plot.R
	chmod +x run_tests.sh
