all: c45 graphs 

c45:
	cd c4.5-src/Src && $(MAKE)
	ln -sf c4.5-src/Src/c4.5 ./

graphs:
	./run_all.sh
	cd doc && pdflatex informe.tex


clean:
	cd c4.5-src/Src && $(MAKE) clean


