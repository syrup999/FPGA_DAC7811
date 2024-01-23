module dac_ctrl (
    output reg SYNC_N,
    output SCLK,
    output reg SDIN,
    output reg [10:0]address,
    input  CLK,
    input [11:0] data // 
);
reg [4:0] CYCLE;
reg SCLK_flag;
reg [11:0] data_locked;

initial 
begin
    SYNC_N <= 1'b1;
    SDIN <= 1'b1;
    CYCLE <= 5'b1_1111;
	 SCLK_flag <= 1'b0;
	 address <= 11'b0;
end

assign SCLK = SCLK_flag & CLK;

always @(posedge CLK) 
begin
    if (CYCLE >= 5'b0 && CYCLE < 'd19) 
    begin
        CYCLE <= CYCLE + 1'b1 ; 
    end
    else
    CYCLE <= 5'b0;
end

/*C15 C14 C13 C12 FUNCTION IMPLEMENTED
0 0 0 0 No operation (power-on default)
0 0 0 1 Load and update
0 0 1 0 Initiate readback
1 0 0 1 Daisy-chain disable
1 0 1 0 Clock data to shift register on rising edge
1 0 1 1 Clear DAC output to zero
1 1 0 0 Clear DAC output to midscale
 */
always @(posedge CLK) 
begin
    casex (CYCLE)
        'd0: begin
			  SYNC_N <= 1'b1;
				begin
					if(address == 'd1249)
					address <= 11'b0;
					else
					address <= address + 1'b1 ;
				end
		  end
        'd1: SYNC_N <= 1'b0;
        'd2: begin 
				SYNC_N <= 1'b0;
            data_locked <= data;
		  end
        'd3:begin 
                SCLK_flag <= 1'b1;
                SDIN <= 1'b0; // C3
            end 
        'd4: SDIN <= 1'b0;  //C2
        'd5: SDIN <= 1'b0;  //C1
        'd6: SDIN <= 1'b1;  //C0

        'd7: SDIN <= data_locked[11];  //DATA12
        'd8: SDIN <= data_locked[10];  //DATA11
        'd9: SDIN <= data_locked[9];  //DATA10
        'd10:SDIN <= data_locked[8];  //DATA9

        'd11:SDIN <= data_locked[7];  //DATA8
        'd12:SDIN <= data_locked[6];  //DATA7
        'd13:SDIN <= data_locked[5];  //DATA6
        'd14:SDIN <= data_locked[4];  //DATA5

        'd15:SDIN <= data_locked[3];  //DATA4
        'd16:SDIN <= data_locked[2];  //DATA3
        'd17:SDIN <= data_locked[1];  //DATA2
        'd18:SDIN <= data_locked[0];  //DATA1

        'd19:begin
                SCLK_flag <= 1'b0; 
                SDIN <= 1'b1;  
            end
		  
        default: SDIN <=SDIN;
    endcase    
end
endmodule