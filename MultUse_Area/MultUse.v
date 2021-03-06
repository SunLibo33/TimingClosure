module MultUse(
input wire              Ex_Clock,   //The System input clock frequency was 20MHz
input wire              Ex_Rst_n,

input wire signed[7:0]  Mult_In_A,
input wire signed[7:0]  Mult_In_B,
output reg signed[15:0] Result,

input wire signed[7:0]  Mult_In_A1,
input wire signed[7:0]  Mult_In_B1,
output reg signed[15:0] Result1,

input wire signed[7:0]  Mult_In_A2,
input wire signed[7:0]  Mult_In_B2,
output reg signed[15:0] Result2,

input wire signed[7:0]  Mult_In_A3,
input wire signed[7:0]  Mult_In_B3,
output reg signed[15:0] Result3

);

reg [7:0]Rst_n_Reg;
wire     Rst_n;  

wire Clock_20M;
wire Clock_80M;
wire locked;

reg  signed[7:0]   Mult_In_A_Reg;
reg  signed[7:0]   Mult_In_B_Reg;
wire signed[15:0]  Result_Wire;

reg[1:0]Channel_Count;

reg signed[15:0] OR_Result;
reg signed[15:0] OR_Result1;
reg signed[15:0] OR_Result2;
reg signed[15:0] OR_Result3;

reg signed[15:0] CH0_Result;
reg signed[15:0] CH1_Result;
reg signed[15:0] CH2_Result;
reg signed[15:0] CH3_Result;

reg signed[15:0] Result_Reg0;
reg signed[15:0] Result_Reg1;
reg signed[15:0] Result1_Reg0;

reg signed[15:0] Result_20M  ;
reg signed[15:0] Result1_20M ;
reg signed[15:0] Result2_20M ;
reg signed[15:0] Result3_20M ;



MyPLL	MyPLL_inst (
	.inclk0 ( Ex_Clock   ),
	.c0     ( Clock_20M  ),
	.c1     ( Clock_80M  ),
	.locked ( locked )
	);

always @(posedge Clock_20M or negedge Ex_Rst_n or negedge locked)
begin
  if( (Ex_Rst_n==1'b0)||(locked==1'b0) )
    Rst_n_Reg <= 8'h00;
  else
    Rst_n_Reg <= {Rst_n_Reg[6:0],1'b1};  
end

assign Rst_n = Rst_n_Reg[7];

always @(posedge Clock_80M)
begin
  if(Rst_n==1'b0)
    begin
      Channel_Count<=2'b00;
	 end
  else
    begin
      Channel_Count<=Channel_Count+2'b01;
	 end  
end

always @(posedge Clock_80M)
begin
  if(Rst_n==1'b0)
    begin
	   Mult_In_A_Reg <=8'h00;
		Mult_In_B_Reg <=8'h00;	
	 end
  else
    begin
	   case(Channel_Count)
		  2'b00:
		    begin
			 	Mult_In_A_Reg<=Mult_In_A;
		      Mult_In_B_Reg<=Mult_In_B;	
			 end
		  2'b01:
		    begin
			 	Mult_In_A_Reg<=Mult_In_A1;
		      Mult_In_B_Reg<=Mult_In_B1;	
			 end
		  2'b10:
		    begin
			 	Mult_In_A_Reg<=Mult_In_A2;
		      Mult_In_B_Reg<=Mult_In_B2;	
			 end
		  2'b11:
		    begin
			 	Mult_In_A_Reg<=Mult_In_A3;
		      Mult_In_B_Reg<=Mult_In_B3;	
			 end	
	     default:
		    begin
			 	Mult_In_A_Reg<=Mult_In_A_Reg;
		      Mult_In_B_Reg<=Mult_In_B_Reg;	
			 end		
		endcase
	 end  
end

Mult_7x7	Mult_7x7_inst (
	.dataa ( Mult_In_A_Reg ),
	.datab ( Mult_In_B_Reg ),
	.result ( Result_Wire )
	);

always @(posedge Clock_80M)
begin
  if(Rst_n==1'b0)
    begin
	   OR_Result<=16'h0000;
		OR_Result1<=16'h0000;
		OR_Result2<=16'h0000;
		OR_Result3<=16'h0000;
	 end
  else
    begin
	   case(Channel_Count)
		  2'b00:OR_Result3<=Result_Wire;
		  2'b01:OR_Result <=Result_Wire;
		  2'b10:OR_Result1<=Result_Wire;
		  2'b11:OR_Result2<=Result_Wire;	
	     default:
	       begin
				OR_Result<=Result;
				OR_Result1<=Result1;
				OR_Result2<=Result2;
				OR_Result3<=Result3;			 
	       end		 
		endcase
	 end  
end

always @(posedge Clock_80M)
begin
  if(Rst_n==1'b0)
    begin
	   Result_Reg0<=16'h0000;
		Result_Reg1<=16'h0000;
		Result1_Reg0<=16'h0000;
	 end
  else
    begin
	   Result_Reg0<=OR_Result;
		Result_Reg1<=Result_Reg0;
		Result1_Reg0<=OR_Result1;
	 end  
end



always @(posedge Clock_20M)
begin
  if(Rst_n==1'b0)
    begin
      Result_20M<=16'h0000;
		Result1_20M<=16'h0000;
		Result2_20M<=16'h0000;
		Result3_20M<=16'h0000;
	 end
  else
    begin
      Result_20M<=Result_Reg1;
		Result1_20M<=Result1_Reg0;
		Result2_20M<=OR_Result2;
		Result3_20M<=OR_Result3;
	 end  
end

always @(posedge Clock_20M)
begin
  if(Rst_n==1'b0)
    begin
      Result <=16'h0000;
		Result1<=16'h0000;
		Result2<=16'h0000;
		Result3<=16'h0000;
	 end
  else
    begin
      Result <=Result_20M ;
		Result1<=Result1_20M;
		Result2<=Result2_20M;
		Result3<=Result3_20M;
	 end  
end


endmodule 