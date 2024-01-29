MKOCTFILE ?= mkoctfile

.PHONY: all
all: __tblish_time_binsearch__.oct

__tblish_time_binsearch__.oct: __tblish_time_binsearch__.cc
	$(MKOCTFILE) __tblish_time_binsearch__.cc

.PHONY: clean
clean:
	$(RM) -r *.o core octave-core *.oct *~

.PHONY: distclean
distclean: clean