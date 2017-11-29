module shiftreg #(parameter N = 11) (input logic clk,
                input logic reset,
                input logic data,
                output logic [N-1:0] q);
    always_ff @ (posedge clk, reset)
      if(reset) q <= 0;
      else q <= {q[N-2:0], data};

endmodule

module PS2Decoder(input logic [10:0] data,
                  output logic [8:0] frequency);

    parameter C4 = 261; //C
    parameter D4 = 293; //D
    parameter E4 = 329; //E
    parameter F4 = 349; //F
    parameter G4 = 392; //G
    parameter A4 = 440; //A
    parameter B4 = 493; //B

    always_ff @ (*)
      begin
        case(data)
          default: frequency = 9'b000000000;
        endcase
      end
endmodule

module PS2KeyBoard (input logic clk,
                input logic raw_data,
                output logic [8:0] frequency);

      logic reset;
      logic [10:0] full_data;

      shiftreg key(.data(data),
                  .clk(clk),
                  .q(full_data),
                  .reset(reset) );

      always_ff @ (full_data)
        begin
          if(full_data[10] == 1)
            PS2Decoder(
                .data(full_data),
                .frequency(frequency) );
                full_data = 0;
        end

endmodule


module testBench();

  logic reset;
  logic raw_data;
  logic [10:0] full_data;
  logic clk;
  shiftreg sreg(.reset(reset),
              .data(raw_data),
              .q(full_data),
              .clk(clk) );

  initial begin

    clk = 1; raw_data = 1; #10;
    clk = 0; #10;
    raw_data = 0; clk = 1; #10;
    clk = 0; #10;
    raw_data = 1; clk = 1; #10;
    clk = 0;

  end
endmodule
