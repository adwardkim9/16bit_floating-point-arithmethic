module FPMUL(opA_i, opB_i, MUL_o);
    input [15:0] opA_i;
    input [15:0] opB_i;
    output [15:0] MUL_o;
    
    reg sign; 
    reg [4:0] exp_A, exp_B;
    reg [4:0] exp;
    reg [10:0] fractA, fractB;
    reg [21:0] fract_temp;
    reg [9:0] fract;

    always @(*) begin    
        exp_A <= opA_i[14:10] - 15;
        exp_B <= opB_i[14:10] - 15;
        fractA <= {1'b1, opA_i[9:0]};
        fractB <= {1'b1, opB_i[9:0]};

        sign <= opA_i[15] ^ opB_i[15];
        exp <= exp_A + exp_B; // add two exponents
        fract_temp <= fractA * fractB; // multiply two fractions
    end
    
    // Normalization
    always @(*) begin
        if(fract_temp[21]) begin
            fract <= fract_temp[20:11];
            exp <= exp + 1;
        end
        else fract <= fract_temp[19:10];
    end

    always @(*) begin
        if (exp == 0) MUL_o <= 0;
        else if (exp == 5'b11111) MUL_o <= 16'h7FFF;
        else MUL_o = {sign, exp, fract}; 
    end

endmodule
		