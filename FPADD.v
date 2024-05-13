module FPADD(opA_i, opB_i, ADD_o);
    input [15:0] opA_i;
    input [15:0] opB_i;
    output [15:0] ADD_o;
    
    reg sign_A, sign_B; 
    reg sign;
    reg carry;
    reg [4:0] exp_A, exp_B;
    reg [4:0] exp;
    reg [10:0] fractA, fractB;
    reg [10:0] fract_temp;
    reg [9:0] fract;

    always @() begin
        sign_A <= opA_i[15];
        sign_B <= opB_i[15];
        exp_A <= opA_i[14:10] - 15;
        exp_B <= opB_i[14:10] - 15;
        fractA <= {1'b1, opA_i[9:0]};
        fractB <= {1'b1, opB_i[9:0]};

        if(exp_A != exp_B) begin // Compare Exponents
            // If exponents are not equal, shift the fraction with the smaller exponents right
            if(exp_A > exp_B) begin 
                exp_B <= exp_A;
                exp <= exp_A;
                fractB <= fractB >> (exp_A - exp_B);
                sign <= sign_A;
            end
            else if (exp_A < exp_B) begin
                exp_A <= exp_B;
                exp <= exp_B;
                fractA <= fractA >> (exp_B - exp_A);
                sign <= sign_B;
            end
            sign <= sign_A;
        end

        if(sign_A==sign_B) {carry, fract_temp} <= fractA + fractB;
        else if(fractA > fractB) {carry, fract_temp} <= fractA - fractB;
        else if(fractA < fractB) {carry, fract_temp} <= fractB - fractA;
    end

    always @() begin // Normalization
        if(carry) begin
            fract_temp <= fract_temp >>1;
            exp <= exp + 1;
        end
        else begin
            while(!fract_temp[10]) begin
                fract_temp <= fract_temp <<1;
                exp <= exp-1;     
            end
        end
        fract <= fract_temp[9:0];
        
    end

    always @() begin
        if (exp ==0) ADD_o <= 0;
        else if (exp == 5'b11111) ADD_o <= 16'h7FFF;
        else ADD_o <= {sign, exp, fract}; 
    end

endmodule