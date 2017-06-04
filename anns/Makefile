all: bp

bp:
	gcc -Wall -std=gnu99 -D_GNU_SOURCE bp.c -o bp -lm
	gcc -Wall -std=gnu99 -D_GNU_SOURCE bp.c -o bp-ranged -lm -DRANGE01
	gcc -Wall -std=gnu99 -D_GNU_SOURCE discretiza.c -o discretiza -lm 
	gcc -Wall -std=gnu99 -D_GNU_SOURCE bp-weight-decay.c -o bp-wd -lm 

clean:
	rm bp

