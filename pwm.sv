module pwm (clk, out, frq, dc, cnt, acc, dec, acc_cnt, dec_cnt);
input [27:0] frq;
input [27:0] dc;
input [27:0] cnt;
input clk;
output reg out;
input [27:0] acc;
input [27:0] dec;
input [27:0] acc_cnt;
input [27:0] dec_cnt;
logic [27:0] str_frq;
logic [27:0] frq_cnt;
logic [27:0] dc_cnt;
logic [27:0] tmp_cnt;
logic [27:0] tgt_dc;

logic [27:0]tgt_frq = 28'd100000;

typedef enum {START_PULSE, CONT_PULSE} pulse_state;
pulse_state pulse_progress;

initial begin
	frq_cnt <= 0;
	dc_cnt <= 0;
	tmp_cnt <= 0;
	tgt_dc <= 0;
	pulse_progress <= START_PULSE;
end

always @ (posedge clk)
begin
	do begin
	case(pulse_progress)
	START_PULSE : begin
		if(cnt >= tmp_cnt) begin
			if((acc_cnt > tmp_cnt) && (tgt_frq > frq)) begin
				tgt_frq <= tgt_frq - acc;
			end
			else if(dec_cnt < tmp_cnt) begin
				tgt_frq <= tgt_frq + dec;
			end
			else begin
				tgt_frq <= frq;
			end
			/*if(tgt_frq > frq) begin
				tgt_frq <= tgt_frq - acc;
			end
			else if(tgt_frq <= frq) begin
				tgt_frq <= frq;
			end
			else begin
				tgt_frq <= tgt_frq + dec;
			end*/
			
			tgt_dc <= tgt_frq >> 1;
			pulse_progress <= CONT_PULSE;
			continue;
		end
	end
	CONT_PULSE : begin
		if(tgt_frq == frq_cnt) begin
			if(tmp_cnt != cnt) begin
				frq_cnt <= 0;
				out <= 1;
				tmp_cnt++;
				pulse_progress <= START_PULSE;
			end
		end
		else begin
			if (tgt_dc == frq_cnt) begin
				out <= 0;
			end
		frq_cnt++;
		end
	end
	endcase
	end while(0);
end
endmodule