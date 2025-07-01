module display #(
    parameter logic [10:0] LW = 10,
    parameter logic [10:0] DW = 50,
    parameter logic [10:0] DL = 100,
    parameter logic [10:0] POSX = 0,
    parameter logic [10:0] POSY = 0
)(
    input logic [10:0] HCOUNT,
    input logic [10:0] VCOUNT,
    input logic [3:0] VALUE,
    output logic PAINT
);

// Segmentos del display
logic [7:0] segments;

// Constantes geométricas del display
// Segmentos horizaontales
localparam logic [10:0] SHX1 = POSX;
localparam logic [10:0] SHX2 = POSX + DW;
localparam logic [10:0] SHY1 = POSY;
localparam logic [10:0] SHY2 = POSY + LW;
localparam logic [10:0] SHY3 = POSY + DL / 11'd2 - LW / 11'd2;
localparam logic [10:0] SHY4 = POSY + DL / 11'd2 + LW / 11'd2;
localparam logic [10:0] SHY5 = POSY + DL - LW;
localparam logic [10:0] SHY6 = POSY + DL;
// Segmentos Verticales
localparam logic [10:0] SVY1 = POSY;
localparam logic [10:0] SVY2 = POSY + DL / 11'd2 + LW / 11'd2;
localparam logic [10:0] SVY3 = POSY + DL / 11'd2 - LW / 11'd2;
localparam logic [10:0] SVY4 = POSY + DL;
localparam logic [10:0] SVX1 = POSX;
localparam logic [10:0] SVX2 = POSX + LW;
localparam logic [10:0] SVX3 = POSX + DW - LW;
localparam logic [10:0] SVX4 = POSX + DW;

// Decodificación del valor en segmentos del display
always_comb begin
  case (VALUE)					//abcdefgp  
		4'b0000: segments = 8'b11111100;
		4'b0001: segments = 8'b01100000;
		4'b0010: segments = 8'b11011010;
		4'b0011: segments = 8'b11110010;
		4'b0100: segments = 8'b01100110;
		4'b0101: segments = 8'b10110110;
		4'b0110: segments = 8'b10111110;
		4'b0111: segments = 8'b11100000;
		4'b1000: segments = 8'b11111110;
		4'b1001: segments = 8'b11100110;
		4'b1010: segments = 8'b11101110;
		4'b1011: segments = 8'b00111100;
		4'b1100: segments = 8'b10011100;
		4'b1101: segments = 8'b01111100;
		4'b1110: segments = 8'b10011110;
		4'b1111: segments = 8'b10001110;
		default: segments = 8'b00000000;
  endcase
end

// Lógica de activación del display
always_comb begin
  PAINT = 1'b0;
  // Segmento a
  if (segments[7] == 1'b1 && HCOUNT >= SHX1 && HCOUNT <= SHX2 && VCOUNT >= SHY1 && VCOUNT <= SHY2)
		PAINT = 1'b1;
  // Segmento g
  else if (segments[1] == 1'b1 && HCOUNT >= SHX1 && HCOUNT <= SHX2 && VCOUNT >= SHY3 && VCOUNT <= SHY4)
		PAINT = 1'b1;
  // Segmento d
  else if (segments[4] == 1'b1 && HCOUNT >= SHX1 && HCOUNT <= SHX2 && VCOUNT >= SHY5 && VCOUNT <= SHY6)
		PAINT = 1'b1;
  // Segmento b
  else if (segments[6] == 1'b1 && HCOUNT >= SVX3 && HCOUNT <= SVX4 && VCOUNT >= SVY1 && VCOUNT <= SVY2)
		PAINT = 1'b1;
  // Segmento c
  else if (segments[5] == 1'b1 && HCOUNT >= SVX3 && HCOUNT <= SVX4 && VCOUNT >= SVY3 && VCOUNT <= SVY4)
		PAINT = 1'b1;
  // Segmento f
  else if (segments[2] == 1'b1 && HCOUNT >= SVX1 && HCOUNT <= SVX2 && VCOUNT >= SVY1 && VCOUNT <= SVY2)
		PAINT = 1'b1;
  // Segmento e
  else if (segments[3] == 1'b1 && HCOUNT >= SVX1 && HCOUNT <= SVX2 && VCOUNT >= SVY3 && VCOUNT <= SVY4)
		PAINT = 1'b1;
end

endmodule
