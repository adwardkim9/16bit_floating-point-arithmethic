`timescale 1ns / 10ps

module tb();

	reg CLK;

	initial begin
		CLK = 1'b0;
		forever #5 CLK = ~CLK;
	end


	reg [15:0] OP1_i, OP2_i;

	wire [15:0] MUL_o;

	FPMUL umul (OP1_i, OP2_i, MUL_o);


	initial begin

		$finish();
	end
	

	initial begin
		$dumpfile("fpmultest.dmp");
		$dumpvars;
	end

endmodule



