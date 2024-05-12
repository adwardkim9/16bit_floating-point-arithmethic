module FPADD(opA_i, opB_i, ADD_o);
    input [15:0] opA_i;
    input [15:0] opB_i;
    ouput [15:0] ADD_o;
    
    reg sign; 
    reg [4:0] exp_A, exp_B;
    reg [4:0] exp;
    reg [9:0] fract;

    always @() begin
        exp_A <= opA_i[14:10] - 15;
        exp_B <= opB_i[14:10] - 15;

        sign <=  opA_i[15] ^ opB_i[15];
        exp <= exp_A + exp_B;
        fract <= (opA_i[9:0] | 10'h200) * (opB_i[9:0] | 10'h200);
    end

    always @() begin
        // Normalization
        if(fract[9]==1) begin
            fract = fract >> 1;
            exp = exp + 1;
        end
        else if(fract < 1) begin
            fract <= fract >> 1;
            exp = exp - 1;
        end
    end

    always @() begin
        if (exp ==0) ADD_o <= 0;
        else if (exp == 5'b11111) ADD_o <= 16'h7FFF;
        else ADD_o <= {sign, exp, fract}; 
    end

endmodule