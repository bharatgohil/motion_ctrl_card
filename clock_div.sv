module motor_clk (input clk, output reg clk_out, input div);

parameter [27:0] base_clk = 28'd50;
logic[27:0] counter = 28'd0;

initial
begin
clk_out <= 0;
end

always @ (posedge clk)
begin
	counter = counter + 1;
	if (counter >= base_clk)
	begin
		clk_out <= ~clk_out;
		counter <=0;
	end
end

endmodule