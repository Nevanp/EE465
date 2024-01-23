
`timescale 1 ns / 1 ps
module deliverable_1_tb();
         
reg clk;
reg reset;
reg [10:0] counter;
reg unsigned [5:0] casecounter;
reg signed [17:0] imp;
reg signed [17:0] x_in;
reg signed [17:0] x_input;
wire signed [17:0] y_out;
initial #20000 $stop;
initial casecounter = 0;
initial clk <= 1'b0;
always #80 clk <=~clk;

initial counter <= 0;
always @ (posedge clk)
begin
if(reset)
	counter <= 0;
else
	counter <= counter + 1;
end

initial	reset <= 1;
initial #160	reset <= 0;

initial imp <= 18'sd0;
//initial y_out = 0;
always @ (*)
begin
if(counter == 18'sd0)
	imp <= 18'sd131071;
else
	imp <= 18'sd0;

end

always @ (posedge clk)
begin
if (counter > 25)
	if (casecounter < 21)
	casecounter <= casecounter + 1;
	else
	casecounter <= 1;
else
	casecounter <= 0;

end

always @ (*)
case (casecounter)
	5'd1: x_in <= 18'sd131071;
	5'd2: x_in <= 18'sd131071;
	5'd3: x_in <= 18'sd131071;
	5'd4: x_in <= -18'sd131072;
	5'd5: x_in <= -18'sd131072;
	5'd6: x_in <= -18'sd131072;
	5'd7: x_in <= -18'sd131072;
	5'd8: x_in <= 18'sd131071;
	5'd9: x_in <= 18'sd131071;
	5'd10: x_in <= 18'sd131071;
	5'd11: x_in <= 18'sd131071;
	5'd12: x_in <= 18'sd131071;
	5'd13: x_in <= 18'sd131071;
	5'd14: x_in <= 18'sd131071;
	5'd15: x_in <= -18'sd131072;
	5'd16: x_in <= -18'sd131072;
	5'd17: x_in <= -18'sd131072;
	5'd18: x_in <= -18'sd131072;
	5'd19: x_in <= 18'sd131071;
	5'd20: x_in <= 18'sd131071;
	5'd21: x_in <= 18'sd131071;
	default: x_in <= imp;
	endcase

always @ (posedge clk)
	if (reset)
	x_input <= 0;
	else
	x_input <= x_in;



 /* *************************************
     INSTANTIATION SECTION                                          
    ************************************* */
 sin_filt SUT_1(
	.clk(clk),
	.reset(reset),
	.x_in(x_input),
	.y(y_out)
	);


endmodule
