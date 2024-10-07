CC=vcs
FLAGS=-full64 -debug_access+r -sverilog
DEPS = pc.sv imem.sv mux_a.sv mux_b.sv
com: $(DEPS) 
	$(CC) $(DEPS) $(FLAGS) 

sim:
	./simv -gui &
