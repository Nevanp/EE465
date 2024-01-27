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
reg signed [17:0] mult_out[10:0];
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
for(i=0;i<=10;i=i+1)
mult_out[i] <= multout[i];

// collapse mult_out into sum level 2, since 0:10 is odd: add 0:9 and set 10
 always @ *
for(i=0;i<=4;i=i+1)
sum_level_2[i] <= mult_out[2*i] + mult_out[2*i+1];

always @ *
sum_level_2[5] <= mult_out[10];

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
casez(sum_level_1[0])
5'b10000: multout[0] <= -18'sd560;
5'b10101: multout[0] <= -18'sd373;
5'b01000: multout[0] <= -18'sd280;
5'bz1010: multout[0] <= -18'sd188;
5'b01101: multout[0] <= -18'sd93;
5'b00000: multout[0] <= 18'sd0;
5'b00010: multout[0] <= 18'sd92;
5'bz0100: multout[0] <= 18'sd187;
5'b00111: multout[0] <= 18'sd280;
5'b01001: multout[0] <= 18'sd372;
5'b01110: multout[0] <= 18'sd560;
default: multout[0] <= 18'sd0;
endcase

casez(sum_level_1[1])
5'b10000: multout[1] <= -18'sd2701;
5'b10101: multout[1] <= -18'sd1797;
5'b01000: multout[1] <= -18'sd1351;
5'bz1010: multout[1] <= -18'sd905;
5'b01101: multout[1] <= -18'sd446;
5'b00000: multout[1] <= 18'sd0;
5'b00010: multout[1] <= 18'sd445;
5'bz0100: multout[1] <= 18'sd904;
5'b00111: multout[1] <= 18'sd1350;
5'b01001: multout[1] <= 18'sd1796;
5'b01110: multout[1] <= 18'sd2701;
default: multout[1] <= 18'sd0;
endcase

casez(sum_level_1[2])
5'b10000: multout[2] <= -18'sd3264;
5'b10101: multout[2] <= -18'sd2171;
5'b01000: multout[2] <= -18'sd1632;
5'bz1010: multout[2] <= -18'sd1094;
5'b01101: multout[2] <= -18'sd539;
5'b00000: multout[2] <= 18'sd0;
5'b00010: multout[2] <= 18'sd538;
5'bz0100: multout[2] <= 18'sd1093;
5'b00111: multout[2] <= 18'sd1632;
5'b01001: multout[2] <= 18'sd2170;
5'b01110: multout[2] <= 18'sd3264;
default: multout[2] <= 18'sd0;
endcase

casez(sum_level_1[3])
5'b10000: multout[3] <= 18'sd774;
5'b10101: multout[3] <= 18'sd514;
5'b01000: multout[3] <= 18'sd387;
5'bz1010: multout[3] <= 18'sd259;
5'b01101: multout[3] <= 18'sd127;
5'b00000: multout[3] <= 18'sd0;
5'b00010: multout[3] <= -18'sd128;
5'bz0100: multout[3] <= -18'sd260;
5'b00111: multout[3] <= -18'sd387;
5'b01001: multout[3] <= -18'sd515;
5'b01110: multout[3] <= -18'sd774;
default: multout[3] <= 18'sd0;
endcase

casez(sum_level_1[4])
5'b10000: multout[4] <= 18'sd8933;
5'b10101: multout[4] <= 18'sd5940;
5'b01000: multout[4] <= 18'sd4466;
5'bz1010: multout[4] <= 18'sd2992;
5'b01101: multout[4] <= 18'sd1473;
5'b00000: multout[4] <= 18'sd0;
5'b00010: multout[4] <= -18'sd1474;
5'bz0100: multout[4] <= -18'sd2993;
5'b00111: multout[4] <= -18'sd4467;
5'b01001: multout[4] <= -18'sd5941;
5'b01110: multout[4] <= -18'sd8933;
default: multout[4] <= 18'sd0;
endcase

casez(sum_level_1[5])
5'b10000: multout[5] <= 18'sd14618;
5'b10101: multout[5] <= 18'sd9720;
5'b01000: multout[5] <= 18'sd7309;
5'bz1010: multout[5] <= 18'sd4897;
5'b01101: multout[5] <= 18'sd2411;
5'b00000: multout[5] <= 18'sd0;
5'b00010: multout[5] <= -18'sd2412;
5'bz0100: multout[5] <= -18'sd4898;
5'b00111: multout[5] <= -18'sd7309;
5'b01001: multout[5] <= -18'sd9721;
5'b01110: multout[5] <= -18'sd14618;
default: multout[5] <= 18'sd0;
endcase

casez(sum_level_1[6])
5'b10000: multout[6] <= 18'sd7754;
5'b10101: multout[6] <= 18'sd5156;
5'b01000: multout[6] <= 18'sd3877;
5'bz1010: multout[6] <= 18'sd2597;
5'b01101: multout[6] <= 18'sd1279;
5'b00000: multout[6] <= 18'sd0;
5'b00010: multout[6] <= -18'sd1280;
5'bz0100: multout[6] <= -18'sd2598;
5'b00111: multout[6] <= -18'sd3877;
5'b01001: multout[6] <= -18'sd5157;
5'b01110: multout[6] <= -18'sd7754;
default: multout[6] <= 18'sd0;
endcase

casez(sum_level_1[7])
5'b10000: multout[7] <= -18'sd17568;
5'b10101: multout[7] <= -18'sd11683;
5'b01000: multout[7] <= -18'sd8784;
5'bz1010: multout[7] <= -18'sd5886;
5'b01101: multout[7] <= -18'sd2899;
5'b00000: multout[7] <= 18'sd0;
5'b00010: multout[7] <= 18'sd2898;
5'bz0100: multout[7] <= 18'sd5885;
5'b00111: multout[7] <= 18'sd8784;
5'b01001: multout[7] <= 18'sd11682;
5'b01110: multout[7] <= 18'sd17568;
default: multout[7] <= 18'sd0;
endcase

casez(sum_level_1[8])
5'b10000: multout[8] <= -18'sd56039;
5'b10101: multout[8] <= -18'sd37266;
5'b01000: multout[8] <= -18'sd28020;
5'bz1010: multout[8] <= -18'sd18774;
5'b01101: multout[8] <= -18'sd9247;
5'b00000: multout[8] <= 18'sd0;
5'b00010: multout[8] <= 18'sd9246;
5'bz0100: multout[8] <= 18'sd18773;
5'b00111: multout[8] <= 18'sd28019;
5'b01001: multout[8] <= 18'sd37265;
5'b01110: multout[8] <= 18'sd56039;
default: multout[8] <= 18'sd0;
endcase

casez(sum_level_1[9])
5'b10000: multout[9] <= -18'sd91444;
5'b10101: multout[9] <= -18'sd60811;
5'b01000: multout[9] <= -18'sd45722;
5'bz1010: multout[9] <= -18'sd30634;
5'b01101: multout[9] <= -18'sd15089;
5'b00000: multout[9] <= 18'sd0;
5'b00010: multout[9] <= 18'sd15088;
5'bz0100: multout[9] <= 18'sd30633;
5'b00111: multout[9] <= 18'sd45722;
5'b01001: multout[9] <= 18'sd60810;
5'b01110: multout[9] <= 18'sd91444;
default: multout[9] <= 18'sd0;
endcase

casez(sum_level_1[10])
5'b10000: multout[10] <= -18'sd105840;
5'b10101: multout[10] <= -18'sd70384;
5'b01000: multout[10] <= -18'sd52920;
5'bz1010: multout[10] <= -18'sd35457;
5'b01101: multout[10] <= -18'sd17464;
5'b00000: multout[10] <= 18'sd0;
5'b00010: multout[10] <= 18'sd17463;
5'bz0100: multout[10] <= 18'sd35456;
5'b00111: multout[10] <= 18'sd52920;
5'b01001: multout[10] <= 18'sd70383;
5'b01110: multout[10] <= 18'sd105840;
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