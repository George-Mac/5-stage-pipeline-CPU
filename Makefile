CPUFile: CPU.v test_CPU.v
	iverilog -o CPUFile CPU.v test_CPU.v
	vvp CPUFile