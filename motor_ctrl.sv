module motor_ctrl (clk, LED);

input clk;
output LED;
logic out;

/*acc_count = start_frq - frq/acc*/
parameter [7:0] div = 8'd2;
logic clk_out = 0;
logic [27:0]frq = 28'd1000;
logic [27:0]dc = 28'd5000;
logic [27:0]acc = 28'd100;  /*tgt_frq/frq*/
logic [27:0]dec = 28'd100;  /*tgt_frq/frq*/
logic [27:0]cnt = 28'd10000; 
logic [27:0]acc_cnt = 28'd990;/*str_frq - frq/acc*/
logic [27:0]dec_cnt = 28'd10000 - 28'd990;/*cnt - acc_cnt*/
//TODO:str_frq = tgt_frq in PWM.sv file
logic [27:0]str_frq = 28'd100000;

/*function [27:0] get_start_cnt([27:0]acc_cnt, acc, frq);
begin
	get_start_cnt = acc_cnt * acc + frq;
end
endfunction*/
initial begin

/*acc_cnt = (str_frq - frq)/acc;
dec_cnt = cnt - acc_cnt;
*/
end

motor_clk clock (.clk(clk), .clk_out(clk_out), .div(div));
pwm axis (.clk(clk_out), .out(out), .frq(frq), .dc(dc), .cnt(cnt), .acc(acc), .dec(dec), .acc_cnt(acc_cnt),
 .dec_cnt(dec_cnt));

assign LED = out;

endmodule 

module pwm_testbench;

reg clk;
logic out;

blink DUT(.clk(clk), .LED(out));

initial begin

out = 0;
clk = 0;
forever #10 clk = ~clk;

end

endmodule