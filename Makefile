CC=vcs
FLAGS=-full64 -debug_access+r -sverilog
DEPS = $(wildcard *.sv)

all: com

com: $(DEPS) 
	@echo "Compiling" $^
	$(CC) $(DEPS) $(FLAGS) 

sim:
	./simv -gui &

clean:
	rm inter.vpd 
	rm -rf DVEfiles
	rm -rf simv.daidir
