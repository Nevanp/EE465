
`timescale 1 ns / 1 ps
module deliverable_1_tb();
         
reg clk, clk25_4;
reg reset;
reg [1:0] clk_count;
reg [10:0] counter;
reg unsigned [5:0] casecounter;
reg signed [17:0] imp;
reg signed [17:0] x_in;
reg signed [17:0] x_input;
wire signed [17:0] y_out, y_down, y_out_tx,x_up;
initial #80000 $stop;
initial casecounter = 0;
initial clk <= 1'b1;
initial clk25_4 <= 1;
always #80 clk <=~clk;

always @ *
    case(clk_count)
	2'b00: clk25_4 <= 1;
    2'b11: clk25_4 <= 1;
    default: clk25_4 <= 0;
    endcase

always @ (posedge clk)
begin
    if (reset)
        clk_count <= 0;
    else
        clk_count = clk_count + 1'b1;
end



//always #320 clk25_4 <= ~clk25_4;
initial counter <= 0;
always @ (posedge clk25_4)
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

always @ (posedge clk25_4)
begin
if (counter > 25)
	if (casecounter < 21)
	casecounter <= casecounter + 1;
	else
	casecounter <= 1;
else
	casecounter <= 0;

end

//input data
// integer file_in;

// initial
// begin
//   file_in = $fopen("data.txt", "r");
// end
// // always @ *
// // if (x_in == 18'sd131071)
// // 	file_in <= $fopen("data.txt","r");

// always @ (posedge clk25_4)
//   if (reset)
//     x_in <= 18'sd0;
//   else
//     $fscanf(file_in, "%d\n", x_in);





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

always @ (posedge clk25_4)
	if (reset)
	x_input <= 0;
	else
	x_input <= x_in;


// Test Data Transfer



 /* *************************************
     INSTANTIATION SECTION                                          
    ************************************* */
up_sampler_4 UP(
	.clk(clk),
	.reset(reset),
	.x_in(x_input),
	.y(x_up)
);

 tx_filter_nomult SUT_1(
	.clk(clk),
	.reset(reset),
	.x_in(x_up),
	.y(y_out_tx)
	);
rx_filter SUT_2(.clk(clk),
	.reset(reset),
	.x_in(y_out_tx),
	.y(y_out));

down_sampler_4 DOWN(
	.clk(clk25_4),
	.reset(reset),
	.x_in(y_out),
	.y(y_down)
);

endmodule
