MKOCTFILE ?= mkoctfile

.PHONY: all
all: __oct_time_binsearch__.oct

__oct_time_binsearch__.oct: __oct_time_binsearch__.cc
	$(MKOCTFILE) __oct_time_binsearch__.cc

.PHONY: clean
clean:
	$(RM) -r *.o core octave-core *.oct *~

.PHONY: distclean
distclean: clean