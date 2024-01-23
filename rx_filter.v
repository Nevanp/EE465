module rx_filter(
          input clk,
		input reset,
		   input signed [17:0] x_in,
		   output reg signed [17:0] y   );
			
/*
reg signed [17:0] b0, b1, b2, b3, b4, b5, b6, b7,
                  b8, b9, b10, b11, b12, b13, b14, b15;
reg signed [17:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9,
                  x10, x11, x12, x13, x14, x15, x16, x17,
						x18, x19, 
						X20, X21, X2, X2, X2, X2, X2, 
						X2, X2, X2, 
*/
integer i;	
reg signed [17:0]	b[10:0];				 
reg signed [17:0]	x[20:0];	
reg signed [36:0] mult_out[10:0];
reg signed [18:0] sum_level_1[10:0];
reg signed [18:0] sum_level_2[5:0];
reg signed [18:0] sum_level_3[2:0];
reg signed [18:0] sum_level_4[1:0];
reg signed [18:0] sum_level_5;

always @ (reset)
begin
for(i=0; i<20;i=i+1)
x[i] <= 0;
end
always @ (reset)
begin
for(i=0; i<10;i=i+1)
mult_out[i] <= 0;
end
always @ (reset)
begin
for(i=0; i<10;i=i+1)
sum_level_1[i] <= 0;
end
always @ (reset)
begin
for(i=0; i<5;i=i+1)
sum_level_2[i] <= 0;
end
always @ (reset)
begin
for(i=0; i<2;i=i+1)
sum_level_3[i] <= 0;
end
always @ (reset)
begin
for(i=0; i<1;i=i+1)
sum_level_4[i] <= 0;
end
always @ (reset)
sum_level_5 <= 0;


// no head room gain of 1
// always @ (posedge reset)
//  begin
//    b[0] =  18'sd4095;
//    b[1] =  18'sd5901;
//    b[2] =  18'sd3327;
//    b[3] =  -18'sd3449;
//    b[4] =  -18'sd10679;
//    b[5] =  -18'sd12461;
//    b[6] =  -18'sd4028;
//    b[7] =  18'sd14916;
//    b[8] =  18'sd38992;
//    b[9] =  18'sd59145;
//    b[10] = 18'sd66992;
//    end

// with head room managed for worst case
   always @ (reset)
 begin
   b[0] <=  18'sd2818;
   b[1] <=  18'sd4061;
   b[2] <=  18'sd2290;
   b[3] <=  -18'sd2372;
   b[4] <=  -18'sd7348;
   b[5] <=  -18'sd8574;
   b[6] <=  -18'sd2771;
   b[7] <=  18'sd10264;
   b[8] <=  18'sd26830;
   b[9] <=  18'sd40697;
   b[10] <= 18'sd46097;
   end

always @ (posedge clk)
x[0] <= x_in; 

always @ (posedge clk)
begin
for(i=1; i<21;i=i+1)
x[i] <= x[i-1];
end


always @ *
for(i=0;i<=9;i=i+1)
sum_level_1[i] <= x[i]+x[20-i];

always @ *
sum_level_1[10] <= x[10];


// always @ (posedge clk)
always @ (posedge clk)
for(i=0;i<=10; i=i+1)
mult_out[i] <= sum_level_1[i] * b[i];

// collapse mult_out into sum level 2, since 0:10 is odd: add 0:9 and set 10
 always @ *
for(i=0;i<=4;i=i+1)
sum_level_2[i] <= mult_out[2*i][36:18] + mult_out[2*i+1][36:18];

always @ *
sum_level_2[5] <= mult_out[10][36:18];

// simular to prev but even so can straight sum
always @ *
for(i=0;i<=2;i=i+1)
sum_level_3[i] <= sum_level_2[2*i] + sum_level_2[2*i+1];
			


always @ *
sum_level_4[0] <= sum_level_3[0] + sum_level_3[1];

always @ *
sum_level_4[1] <= sum_level_3[2];

always @ *
sum_level_5 <= sum_level_4[0] + sum_level_4[1];

always @ (posedge clk)
y <= sum_level_5[17:0];


// always @ * // 1s17 format
//    begin
//    b[0] =  18'sd4095;
//    b[1] =  18'sd5901;
//    b[2] =  18'sd3327;
//    b[3] =  -18'sd3449;
//    b[4] =  -18'sd10679;
//    b[5] =  -18'sd12461;
//    b[6] =  -18'sd4028;
//    b[7] =  18'sd14916;
//    b[8] =  18'sd38992;
//    b[9] =  18'sd59145;
//    b[10] = 18'sd66992;
//    end

always @ *
begin
   b[0] <=  18'sd2817;
   b[1] <=  18'sd4060;
   b[2] <=  18'sd2289;
   b[3] <=  -18'sd2373;
   b[4] <=  -18'sd7348;
   b[5] <=  -18'sd8574;
   b[6] <=  -18'sd2772;
   b[7] <=  18'sd10263;
   b[8] <=  18'sd26830;
   b[9] <=  18'sd40696;
   b[10] <= 18'sd46096;
   end




/* for debugging
always@ *
for (i=0; i<=15; i=i+1)
if (i==15) % center coefficient
b[i] = 18'sd 131071; % almost 1 i.e. 1-2^(17)
else b[i] =18'sd0; % other than center coefficient
*/

/* for debugging
always@ *
for (i=0; i<=15; i=i+1)
 b[i] =18'sd 8192; % value of 1/16
*/
endmodule