module mac_pipe #(
  parameter int A_W   = 8,
  parameter int B_W   = 8,
  parameter int ACC_W = 24,   // accumulator/output width
  parameter bit SIGNED = 0    // 1 = signed math, 0 = unsigned
) (
  input  logic                   clk,
  input  logic                   rst,        // synchronous reset

  input  logic                   in_valid,
  input  logic [A_W-1:0]         a,
  input  logic [B_W-1:0]         b,
  input  logic [ACC_W-1:0]       acc_in,

  output logic                   out_valid,
  output logic [ACC_W-1:0]       y
);

    logic [A_W-1:0] a_reg;
    logic [B_W-1:0] b_reg;
    logic [ACC_W-1:0] acc_in_reg;
    logic mult_valid;
    logic mult_valid_d;
    
    always_ff @(posedge clk) begin
        if (rst) begin
        a_reg <= '0;
        b_reg <= '0;
        acc_in_reg <= '0;
        mult_valid <= 0;
        end else if (in_valid) begin
        a_reg <= a;
        b_reg <= b;
        acc_in_reg <= acc_in;
        mult_valid <= 1;
        end else begin
        mult_valid <= 0;
        end
    end
    logic [ACC_W-1:0] acc_in_d;
        //Stage 2: Multiply
    logic [ACC_W-1:0] mult_result;
    always_ff @(posedge clk) begin
        if (rst) begin
        mult_result <= '0;
        mult_valid_d <= 0;
        end
        else
        begin
            mult_valid_d <= mult_valid;
            acc_in_d <= acc_in_reg;
    
            if (mult_valid) begin
                if (SIGNED) begin
                mult_result <= $signed(a_reg) * $signed(b_reg);
                end 
                else begin
                mult_result <= a_reg * b_reg;
                end
            end
        end
    end
    
    // Stage 3: Accumulate
    logic [ACC_W-1:0] acc_result;
    logic acc_valid;
    
    always_ff @(posedge clk) begin
        if (rst) begin
        acc_result <= '0;
        acc_valid <= 0;
        end else if (mult_valid_d) begin
        acc_result <= acc_in_d + mult_result;
        acc_valid <= 1;
        end else begin
        acc_valid <= 0;
        end
    end
    
    // Output assignment
    assign out_valid = acc_valid;
    assign y = acc_result;
endmodule
