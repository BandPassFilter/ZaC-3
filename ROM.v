module ROM(clk, address, byte_mode, q);
	input clk;
	input [19:0] address;
	input byte_mode;
	output [15:0] q;
	
	reg [15:0] internal_q = 0;
	assign q[15:0] = internal_q[15:0];
	always @ (posedge clk) begin
		case(address)
			20'h0: internal_q = 16'h0100;
			20'h2: internal_q = 16'h0080;
			20'h4: internal_q = 16'hFAFF;
			20'h6: internal_q = 16'h393B;
			20'ha: internal_q = 16'h2038;
			20'hc: internal_q = 16'h0200;
			20'he: internal_q = 16'h3978;
			20'h12: internal_q = 16'h2038;
			20'h14: internal_q = 16'h0400;
			20'h16: internal_q = 16'h3978;
			20'h18: internal_q = 16'h0200;
			20'h1a: internal_q = 16'hF970;
			20'h1c: internal_q = 16'h0400;
			20'h1e: internal_q = 16'hC03B;
			20'h22: internal_q = 16'hA70B;
			20'h26: internal_q = 16'h3DC0;
			20'h2a: internal_q = 16'h6038;
			20'h2c: internal_q = 16'h0008;
			20'h2e: internal_q = 16'h2318;
			20'h30: internal_q = 16'h1000;
			20'h32: internal_q = 16'h0090;
			20'h34: internal_q = 16'h1F00;
			20'h36: internal_q = 16'h0088;
			20'h3a: internal_q = 16'h2038;
			20'h3c: internal_q = 16'h1200;
			20'h3e: internal_q = 16'h0080;
			20'h40: internal_q = 16'h0100;
			20'h42: internal_q = 16'h2038;
			20'h44: internal_q = 16'h1F00;
			20'h46: internal_q = 16'h0080;
			20'h48: internal_q = 16'h0200;
			20'h4a: internal_q = 16'hF970;
			20'h4c: internal_q = 16'h0400;
			20'h4e: internal_q = 16'hC03B;
			20'h52: internal_q = 16'hA70B;
			20'h56: internal_q = 16'h3DC0;
			20'h58: internal_q = 16'h0400;
			20'h5a: internal_q = 16'hF970;
			20'h5c: internal_q = 16'h1300;
			20'h5e: internal_q = 16'hC03B;
			20'h62: internal_q = 16'hA70B;
			20'h66: internal_q = 16'h3DC8;
			20'h68: internal_q = 16'h0200;
			20'h6a: internal_q = 16'h3970;
			20'h6c: internal_q = 16'h0100;
			20'h6e: internal_q = 16'h6038;
			20'h70: internal_q = 16'h0008;
			20'h72: internal_q = 16'h2310;
			20'h74: internal_q = 16'h0200;
			20'h76: internal_q = 16'h3978;
			20'h78: internal_q = 16'h0600;
			20'h7a: internal_q = 16'h0080;
			20'h7e: internal_q = 16'h00F8;
			20'h82: internal_q = 16'h00F8;
			20'h40000: internal_q = 16'h4865;
			20'h40002: internal_q = 16'h6C6C;
			20'h40004: internal_q = 16'h6F20;
			20'h40006: internal_q = 16'h776F;
			20'h40008: internal_q = 16'h726C;
			20'h4000a: internal_q = 16'h640D;
			20'h4000c: internal_q = 16'h0A00;
			default: internal_q = 16'b0;
		endcase
		if (byte_mode) begin
			if (address[0]) begin
				internal_q = {8'd0, internal_q[15:8]};
			end else begin
				internal_q = {8'd0, internal_q[7:0]};
			end
		end
	end
endmodule
