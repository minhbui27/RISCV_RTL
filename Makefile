CC=vcs
FLAGS=-full64 -debug_access+r -sverilog
DEPS = pc.sv
com: $(DEPS) 
	$(CC) $(DEPS) $(FLAGS) 

sim:
	./simv -gui &
