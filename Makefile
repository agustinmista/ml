all: 
	cd gen && $(MAKE)
	cd dtree && $(MAKE)

clean:
	cd gen && $(MAKE) clean
	cd dtree && $(MAKE) clean


