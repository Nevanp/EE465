module tx_filter_nomult(
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
reg signed [17:0] multout[10:0];
reg unsigned [4:0] sum_level_1[10:0];
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
b[0] <= 423;
b[1] <= 1470;
b[2] <= 1598;
b[3] <= -615;
b[4] <= -4766;
b[5] <= -7459;
b[6] <= -3713;
b[7] <= 9251;
b[8] <= 28642;
b[9] <= 46363;
b[10] <= 53546;
   end


always @ *
case(x_in)
   18'd

endcase


always @ (posedge clk)
x[0] <= x_in; 

always @ (posedge clk)
begin
for(i=1; i<21;i=i+1)
x[i] <= x[i-1];
end


always @ *
for(i=0;i<=9;i=i+1)
sum_level_1[i] <= x[i][17:14]+x[20-i][17:14];

always @ *
sum_level_1[10] <= x[10][17:14];


// always @ (posedge clk)
always @ (posedge clk)
mult_out[i] <= multout[i];

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


always @ (*)
begin
for(i=0;i<=10; i=i+1)
case(sum_level_1[0])
5'b10000: multout[0] <= 18'sd-846;
5'b10101: multout[0] <= 18'sd-562;
5'b01000: multout[0] <= 18'sd-423;
5'b11010: multout[0] <= 18'sd-283;
5'b01101: multout[0] <= 18'sd-139;
5'b00000: multout[0] <= 18'sd0;
5'b00010: multout[0] <= 18'sd139;
5'b00100: multout[0] <= 18'sd283;
5'b00111: multout[0] <= 18'sd423;
5'b01001: multout[0] <= 18'sd562;
5'b01110: multout[0] <= 18'sd846;
default: multout[0] <= 18'sd0;
endcase

case(sum_level_1[1])
5'b10000: multout[1] <= 18'sd-2940;
5'b10101: multout[1] <= 18'sd-1955;
5'b01000: multout[1] <= 18'sd-1470;
5'b11010: multout[1] <= 18'sd-984;
5'b01101: multout[1] <= 18'sd-485;
5'b00000: multout[1] <= 18'sd0;
5'b00010: multout[1] <= 18'sd485;
5'b00100: multout[1] <= 18'sd984;
5'b00111: multout[1] <= 18'sd1470;
5'b01001: multout[1] <= 18'sd1955;
5'b01110: multout[1] <= 18'sd2940;
default: multout[1] <= 18'sd0;
endcase

case(sum_level_1[2])
5'b10000: multout[2] <= 18'sd-3196;
5'b10101: multout[2] <= 18'sd-2125;
5'b01000: multout[2] <= 18'sd-1598;
5'b11010: multout[2] <= 18'sd-1070;
5'b01101: multout[2] <= 18'sd-527;
5'b00000: multout[2] <= 18'sd0;
5'b00010: multout[2] <= 18'sd527;
5'b00100: multout[2] <= 18'sd1070;
5'b00111: multout[2] <= 18'sd1598;
5'b01001: multout[2] <= 18'sd2125;
5'b01110: multout[2] <= 18'sd3196;
default: multout[2] <= 18'sd0;
endcase

case(sum_level_1[3])
5'b10000: multout[3] <= 18'sd1230;
5'b10101: multout[3] <= 18'sd817;
5'b01000: multout[3] <= 18'sd615;
5'b11010: multout[3] <= 18'sd412;
5'b01101: multout[3] <= 18'sd202;
5'b00000: multout[3] <= 18'sd0;
5'b00010: multout[3] <= 18'sd-202;
5'b00100: multout[3] <= 18'sd-412;
5'b00111: multout[3] <= 18'sd-615;
5'b01001: multout[3] <= 18'sd-817;
5'b01110: multout[3] <= 18'sd-1230;
default: multout[3] <= 18'sd0;
endcase

case(sum_level_1[4])
5'b10000: multout[4] <= 18'sd9532;
5'b10101: multout[4] <= 18'sd6338;
5'b01000: multout[4] <= 18'sd4766;
5'b11010: multout[4] <= 18'sd3193;
5'b01101: multout[4] <= 18'sd1572;
5'b00000: multout[4] <= 18'sd0;
5'b00010: multout[4] <= 18'sd-1572;
5'b00100: multout[4] <= 18'sd-3193;
5'b00111: multout[4] <= 18'sd-4766;
5'b01001: multout[4] <= 18'sd-6338;
5'b01110: multout[4] <= 18'sd-9532;
default: multout[4] <= 18'sd0;
endcase

case(sum_level_1[5])
5'b10000: multout[5] <= 18'sd14918;
5'b10101: multout[5] <= 18'sd9920;
5'b01000: multout[5] <= 18'sd7459;
5'b11010: multout[5] <= 18'sd4997;
5'b01101: multout[5] <= 18'sd2461;
5'b00000: multout[5] <= 18'sd0;
5'b00010: multout[5] <= 18'sd-2461;
5'b00100: multout[5] <= 18'sd-4997;
5'b00111: multout[5] <= 18'sd-7459;
5'b01001: multout[5] <= 18'sd-9920;
5'b01110: multout[5] <= 18'sd-14918;
default: multout[5] <= 18'sd0;
endcase

case(sum_level_1[6])
5'b10000: multout[6] <= 18'sd7426;
5'b10101: multout[6] <= 18'sd4938;
5'b01000: multout[6] <= 18'sd3713;
5'b11010: multout[6] <= 18'sd2487;
5'b01101: multout[6] <= 18'sd1225;
5'b00000: multout[6] <= 18'sd0;
5'b00010: multout[6] <= 18'sd-1225;
5'b00100: multout[6] <= 18'sd-2487;
5'b00111: multout[6] <= 18'sd-3713;
5'b01001: multout[6] <= 18'sd-4938;
5'b01110: multout[6] <= 18'sd-7426;
default: multout[6] <= 18'sd0;
endcase

case(sum_level_1[7])
5'b10000: multout[7] <= 18'sd-18502;
5'b10101: multout[7] <= 18'sd-12303;
5'b01000: multout[7] <= 18'sd-9251;
5'b11010: multout[7] <= 18'sd-6198;
5'b01101: multout[7] <= 18'sd-3052;
5'b00000: multout[7] <= 18'sd0;
5'b00010: multout[7] <= 18'sd3052;
5'b00100: multout[7] <= 18'sd6198;
5'b00111: multout[7] <= 18'sd9251;
5'b01001: multout[7] <= 18'sd12303;
5'b01110: multout[7] <= 18'sd18502;
default: multout[7] <= 18'sd0;
endcase

case(sum_level_1[8])
5'b10000: multout[8] <= 18'sd-57284;
5'b10101: multout[8] <= 18'sd-38093;
5'b01000: multout[8] <= 18'sd-28642;
5'b11010: multout[8] <= 18'sd-19190;
5'b01101: multout[8] <= 18'sd-9451;
5'b00000: multout[8] <= 18'sd0;
5'b00010: multout[8] <= 18'sd9451;
5'b00100: multout[8] <= 18'sd19190;
5'b00111: multout[8] <= 18'sd28642;
5'b01001: multout[8] <= 18'sd38093;
5'b01110: multout[8] <= 18'sd57284;
default: multout[8] <= 18'sd0;
endcase

case(sum_level_1[9])
5'b10000: multout[9] <= 18'sd-92726;
5'b10101: multout[9] <= 18'sd-61662;
5'b01000: multout[9] <= 18'sd-46363;
5'b11010: multout[9] <= 18'sd-31063;
5'b01101: multout[9] <= 18'sd-15299;
5'b00000: multout[9] <= 18'sd0;
5'b00010: multout[9] <= 18'sd15299;
5'b00100: multout[9] <= 18'sd31063;
5'b00111: multout[9] <= 18'sd46363;
5'b01001: multout[9] <= 18'sd61662;
5'b01110: multout[9] <= 18'sd92726;
default: multout[9] <= 18'sd0;
endcase

case(sum_level_1[10])
5'b10000: multout[10] <= 18'sd-107092;
5'b10101: multout[10] <= 18'sd-71216;
5'b01000: multout[10] <= 18'sd-53546;
5'b11010: multout[10] <= 18'sd-35875;
5'b01101: multout[10] <= 18'sd-17670;
5'b00000: multout[10] <= 18'sd0;
5'b00010: multout[10] <= 18'sd17670;
5'b00100: multout[10] <= 18'sd35875;
5'b00111: multout[10] <= 18'sd53546;
5'b01001: multout[10] <= 18'sd71216;
5'b01110: multout[10] <= 18'sd107092;
default: multout[10] <= 18'sd0;
endcase

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