module MultUse(
input wire              Ex_Clock,   //The System input clock frequency was 20MHz
input wire              Ex_Rst_n,
input wire signed[7:0]  Mult_In_A,
input wire signed[7:0]  Mult_In_B,
output reg signed[15:0] Result
);

reg [7:0]Rst_n_Reg;
wire     Rst_n;  

wire Clock_20M;
wire Clock_80M;
wire locked;

reg  signed[7:0]   Mult_In_A_Reg;
reg  signed[7:0]   Mult_In_B_Reg;
wire signed[15:0]  Result_Wire;

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

always @(posedge Clock_20M)
begin
  if(Rst_n==1'b0)
    begin
	   Mult_In_A_Reg<=8'h00;
		Mult_In_B_Reg<=8'h00;
	 end
  else
    begin
	   Mult_In_A_Reg<=Mult_In_A;
		Mult_In_B_Reg<=Mult_In_B;	 
	 end  
end

Mult_7x7	Mult_7x7_inst (
	.dataa ( Mult_In_A_Reg ),
	.datab ( Mult_In_B_Reg ),
	.result ( Result_Wire )
	);

always @(posedge Clock_20M)
begin
  if(Rst_n==1'b0)
    begin
	   Result<=16'h0000;
	 end
  else
    begin
	   Result<=Result_Wire;
	 end  
end

endmodule 