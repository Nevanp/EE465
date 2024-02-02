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
5'b10000: multout[0] <= -18'sd60;
5'b10101: multout[0] <= -18'sd40;
5'b01000: multout[0] <= -18'sd30;
5'bz1010: multout[0] <= -18'sd21;
5'b01101: multout[0] <= -18'sd10;
5'b00000: multout[0] <= 18'sd0;
5'b00010: multout[0] <= 18'sd9;
5'bz0100: multout[0] <= 18'sd20;
5'b00111: multout[0] <= 18'sd30;
5'b01001: multout[0] <= 18'sd39;
5'b01110: multout[0] <= 18'sd60;
default: multout[0] <= 18'sd0;
endcase

casez(sum_level_1[1])
5'b10000: multout[1] <= -18'sd2381;
5'b10101: multout[1] <= -18'sd1584;
5'b01000: multout[1] <= -18'sd1191;
5'bz1010: multout[1] <= -18'sd798;
5'b01101: multout[1] <= -18'sd393;
5'b00000: multout[1] <= 18'sd0;
5'b00010: multout[1] <= 18'sd392;
5'bz0100: multout[1] <= 18'sd797;
5'b00111: multout[1] <= 18'sd1190;
5'b01001: multout[1] <= 18'sd1583;
5'b01110: multout[1] <= 18'sd2381;
default: multout[1] <= 18'sd0;
endcase

casez(sum_level_1[2])
5'b10000: multout[2] <= -18'sd3490;
5'b10101: multout[2] <= -18'sd2321;
5'b01000: multout[2] <= -18'sd1745;
5'bz1010: multout[2] <= -18'sd1170;
5'b01101: multout[2] <= -18'sd576;
5'b00000: multout[2] <= 18'sd0;
5'b00010: multout[2] <= 18'sd575;
5'bz0100: multout[2] <= 18'sd1169;
5'b00111: multout[2] <= 18'sd1745;
5'b01001: multout[2] <= 18'sd2320;
5'b01110: multout[2] <= 18'sd3490;
default: multout[2] <= 18'sd0;
endcase

casez(sum_level_1[3])
5'b10000: multout[3] <= 18'sd65;
5'b10101: multout[3] <= 18'sd43;
5'b01000: multout[3] <= 18'sd32;
5'bz1010: multout[3] <= 18'sd21;
5'b01101: multout[3] <= 18'sd10;
5'b00000: multout[3] <= 18'sd0;
5'b00010: multout[3] <= -18'sd11;
5'bz0100: multout[3] <= -18'sd22;
5'b00111: multout[3] <= -18'sd33;
5'b01001: multout[3] <= -18'sd44;
5'b01110: multout[3] <= -18'sd65;
default: multout[3] <= 18'sd0;
endcase

casez(sum_level_1[4])
5'b10000: multout[4] <= 18'sd8287;
5'b10101: multout[4] <= 18'sd5510;
5'b01000: multout[4] <= 18'sd4143;
5'bz1010: multout[4] <= 18'sd2776;
5'b01101: multout[4] <= 18'sd1367;
5'b00000: multout[4] <= 18'sd0;
5'b00010: multout[4] <= -18'sd1368;
5'bz0100: multout[4] <= -18'sd2777;
5'b00111: multout[4] <= -18'sd4144;
5'b01001: multout[4] <= -18'sd5511;
5'b01110: multout[4] <= -18'sd8287;
default: multout[4] <= 18'sd0;
endcase

casez(sum_level_1[5])
5'b10000: multout[5] <= 18'sd14640;
5'b10101: multout[5] <= 18'sd9735;
5'b01000: multout[5] <= 18'sd7320;
5'bz1010: multout[5] <= 18'sd4904;
5'b01101: multout[5] <= 18'sd2415;
5'b00000: multout[5] <= 18'sd0;
5'b00010: multout[5] <= -18'sd2416;
5'bz0100: multout[5] <= -18'sd4905;
5'b00111: multout[5] <= -18'sd7320;
5'b01001: multout[5] <= -18'sd9736;
5'b01110: multout[5] <= -18'sd14640;
default: multout[5] <= 18'sd0;
endcase

casez(sum_level_1[6])
5'b10000: multout[6] <= 18'sd8525;
5'b10101: multout[6] <= 18'sd5669;
5'b01000: multout[6] <= 18'sd4262;
5'bz1010: multout[6] <= 18'sd2855;
5'b01101: multout[6] <= 18'sd1406;
5'b00000: multout[6] <= 18'sd0;
5'b00010: multout[6] <= -18'sd1407;
5'bz0100: multout[6] <= -18'sd2856;
5'b00111: multout[6] <= -18'sd4263;
5'b01001: multout[6] <= -18'sd5670;
5'b01110: multout[6] <= -18'sd8525;
default: multout[6] <= 18'sd0;
endcase

casez(sum_level_1[7])
5'b10000: multout[7] <= -18'sd16653;
5'b10101: multout[7] <= -18'sd11075;
5'b01000: multout[7] <= -18'sd8327;
5'bz1010: multout[7] <= -18'sd5579;
5'b01101: multout[7] <= -18'sd2748;
5'b00000: multout[7] <= 18'sd0;
5'b00010: multout[7] <= 18'sd2747;
5'bz0100: multout[7] <= 18'sd5578;
5'b00111: multout[7] <= 18'sd8326;
5'b01001: multout[7] <= 18'sd11074;
5'b01110: multout[7] <= 18'sd16653;
default: multout[7] <= 18'sd0;
endcase

casez(sum_level_1[8])
5'b10000: multout[8] <= -18'sd55799;
5'b10101: multout[8] <= -18'sd37107;
5'b01000: multout[8] <= -18'sd27900;
5'bz1010: multout[8] <= -18'sd18693;
5'b01101: multout[8] <= -18'sd9207;
5'b00000: multout[8] <= 18'sd0;
5'b00010: multout[8] <= 18'sd9206;
5'bz0100: multout[8] <= 18'sd18692;
5'b00111: multout[8] <= 18'sd27899;
5'b01001: multout[8] <= 18'sd37106;
5'b01110: multout[8] <= 18'sd55799;
default: multout[8] <= 18'sd0;
endcase

casez(sum_level_1[9])
5'b10000: multout[9] <= -18'sd92183;
5'b10101: multout[9] <= -18'sd61302;
5'b01000: multout[9] <= -18'sd46092;
5'bz1010: multout[9] <= -18'sd30882;
5'b01101: multout[9] <= -18'sd15211;
5'b00000: multout[9] <= 18'sd0;
5'b00010: multout[9] <= 18'sd15210;
5'bz0100: multout[9] <= 18'sd30881;
5'b00111: multout[9] <= 18'sd46091;
5'b01001: multout[9] <= 18'sd61301;
5'b01110: multout[9] <= 18'sd92183;
default: multout[9] <= 18'sd0;
endcase

casez(sum_level_1[10])
5'b10000: multout[10] <= -18'sd107038;
5'b10101: multout[10] <= -18'sd71181;
5'b01000: multout[10] <= -18'sd53519;
5'bz1010: multout[10] <= -18'sd35858;
5'b01101: multout[10] <= -18'sd17662;
5'b00000: multout[10] <= 18'sd0;
5'b00010: multout[10] <= 18'sd17661;
5'bz0100: multout[10] <= 18'sd35857;
5'b00111: multout[10] <= 18'sd53519;
5'b01001: multout[10] <= 18'sd71180;
5'b01110: multout[10] <= 18'sd107038;
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