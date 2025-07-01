module display34segm #(
    parameter logic [10:0] SG_WD = 5, // Segment width
    parameter logic [10:0] DL = 100   // DISPLAY_LENGTH
)(
    input  logic [10:0] posx,       // Position X
    input  logic [10:0] posy,       // Position Y
    input  logic [33:0] segments,   // Segments vector
    input  logic [10:0] HCOUNT,     // Horizontal counter
    input  logic [10:0] VCOUNT,     // Vertical counter
    output logic PAINT              // Paint output
);

// Local constants
localparam logic [10:0] v_bar = (DL - 11'd5 * SG_WD) / 11'd4; // Vertical segment length
localparam logic [10:0] h_bar = v_bar + SG_WD;        // Horizontal segment length
localparam logic [10:0] DIAG_SZ = v_bar;              // Length of space for diagonals bars

// x-segments reference positions
logic [10:0] RX1, RX2, RX3, RX4, RX5, RX6;
// y-segments reference positions
logic [10:0] RY1, RY2, RY3, RY4, RY5, RY6, RY7, RY8, RY9, RY10;

// Initialize RX and RY values
always_comb begin
  RX1 = posx;
  RX2 = RX1 + SG_WD;
  RX3 = RX2 + h_bar;
  RX4 = RX3 + SG_WD;
  RX5 = RX4 + h_bar;
  RX6 = RX5 + SG_WD;

  RY1 = posy;
  RY2 = RY1 + SG_WD;
  RY3 = RY2 + v_bar;
  RY4 = RY3 + SG_WD;
  RY5 = RY4 + v_bar;
  RY6 = RY5 + SG_WD;
  RY7 = RY6 + v_bar;
  RY8 = RY7 + SG_WD;
  RY9 = RY8 + v_bar;
  RY10 = RY9 + SG_WD;
end

always_comb begin
    PAINT = 1'b0; // Valor por defecto

    // HORIZONTAL SEGMENTS
    if ((segments[33] && (HCOUNT >= RX2) && (HCOUNT <= RX3) && (VCOUNT > RY1) && (VCOUNT < RY2)) ||
        (segments[32] && (HCOUNT >= RX4) && (HCOUNT <= RX5) && (VCOUNT > RY1) && (VCOUNT < RY2)) ||
        (segments[31] && (HCOUNT >= RX2) && (HCOUNT <= RX3) && (VCOUNT > RY5) && (VCOUNT < RY6)) ||
        (segments[30] && (HCOUNT >= RX4) && (HCOUNT <= RX5) && (VCOUNT > RY5) && (VCOUNT < RY6)) ||
        (segments[29] && (HCOUNT >= RX2) && (HCOUNT <= RX3) && (VCOUNT > RY9) && (VCOUNT < RY10)) ||
        (segments[28] && (HCOUNT >= RX4) && (HCOUNT <= RX5) && (VCOUNT > RY9) && (VCOUNT < RY10))) begin
        PAINT = 1'b1;
    end
    // VERTICAL SEGMENTS
    else if ((segments[27] && (HCOUNT > RX1) && (HCOUNT < RX2) && (VCOUNT >= RY2) && (VCOUNT <= RY3)) ||
             (segments[26] && (HCOUNT > RX1) && (HCOUNT < RX2) && (VCOUNT >= RY4) && (VCOUNT <= RY5)) ||
             (segments[25] && (HCOUNT > RX1) && (HCOUNT < RX2) && (VCOUNT >= RY6) && (VCOUNT <= RY7)) ||
             (segments[24] && (HCOUNT > RX1) && (HCOUNT < RX2) && (VCOUNT >= RY8) && (VCOUNT <= RY9)) ||
             (segments[23] && (HCOUNT > RX3) && (HCOUNT < RX4) && (VCOUNT >= RY2) && (VCOUNT <= RY3)) ||
             (segments[22] && (HCOUNT > RX3) && (HCOUNT < RX4) && (VCOUNT >= RY4) && (VCOUNT <= RY5)) ||
             (segments[21] && (HCOUNT > RX3) && (HCOUNT < RX4) && (VCOUNT >= RY6) && (VCOUNT <= RY7)) ||
             (segments[20] && (HCOUNT > RX3) && (HCOUNT < RX4) && (VCOUNT >= RY8) && (VCOUNT <= RY9)) ||
             (segments[19] && (HCOUNT > RX5) && (HCOUNT < RX6) && (VCOUNT >= RY2) && (VCOUNT <= RY3)) ||
             (segments[18] && (HCOUNT > RX5) && (HCOUNT < RX6) && (VCOUNT >= RY4) && (VCOUNT <= RY5)) ||
             (segments[17] && (HCOUNT > RX5) && (HCOUNT < RX6) && (VCOUNT >= RY6) && (VCOUNT <= RY7)) ||
             (segments[16] && (HCOUNT > RX5) && (HCOUNT < RX6) && (VCOUNT >= RY8) && (VCOUNT <= RY9))) begin
        PAINT = 1'b1;
    end
    // DIAGONAL_1 SEGMENTS
    else if ((segments[15] && ((VCOUNT - RY2) <= (HCOUNT - RX2)) && ((VCOUNT - RY2) > ((HCOUNT - RX2) - SG_WD)) &&
              (HCOUNT > RX2) && (VCOUNT <= RY2 + DIAG_SZ) && (VCOUNT > RY2)) ||
             (segments[14] && ((VCOUNT - RY2) <= (HCOUNT - RX4)) && ((VCOUNT - RY2) > ((HCOUNT - RX4) - SG_WD)) &&
              (HCOUNT >= RX4) && (VCOUNT <= RY2 + DIAG_SZ) && (VCOUNT > RY2)) ||
             (segments[13] && ((VCOUNT - RY4) <= (HCOUNT - RX2)) && ((VCOUNT - RY4) > ((HCOUNT - RX2) - SG_WD)) &&
              (HCOUNT > RX2) && (VCOUNT < RY4 + DIAG_SZ) && (VCOUNT > RY4)) ||
             (segments[12] && ((VCOUNT - RY4) <= (HCOUNT - RX4)) && ((VCOUNT - RY4) > ((HCOUNT - RX4) - SG_WD)) &&
              (HCOUNT >= RX4) && (VCOUNT <= RY4 + DIAG_SZ) && (VCOUNT > RY4)) ||
             (segments[11] && ((VCOUNT - RY6) <= (HCOUNT - RX2)) && ((VCOUNT - RY6) > ((HCOUNT - RX2) - SG_WD)) &&
              (HCOUNT >= RX2) && (VCOUNT <= RY6 + DIAG_SZ) && (VCOUNT > RY6)) ||
             (segments[10] && ((VCOUNT - RY6) <= (HCOUNT - RX4)) && ((VCOUNT - RY6) > ((HCOUNT - RX4) - SG_WD)) &&
              (HCOUNT >= RX4) && (VCOUNT <= RY6 + DIAG_SZ) && (VCOUNT > RY6)) ||
             (segments[9] && ((VCOUNT - RY8) <= (HCOUNT - RX2)) && ((VCOUNT - RY8) > ((HCOUNT - RX2) - SG_WD)) &&
              (HCOUNT >= RX2) && (VCOUNT <= RY8 + DIAG_SZ) && (VCOUNT > RY8)) ||
             (segments[8] && ((VCOUNT - RY8) <= (HCOUNT - RX4)) && ((VCOUNT - RY8) > ((HCOUNT - RX4) - SG_WD)) &&
              (HCOUNT >= RX4) && (VCOUNT <= RY8 + DIAG_SZ) && (VCOUNT > RY8))) begin
        PAINT = 1'b1;
    end
    // DIAGONAL_2 SEGMENTS
    else if ((segments[7] && (((VCOUNT - RY2) - DIAG_SZ) >= -((HCOUNT - RX2))) &&
              (((VCOUNT - RY2) - DIAG_SZ - SG_WD) < -((HCOUNT - RX2))) && (VCOUNT > RY2) && (VCOUNT <= (RY2 + DIAG_SZ))) ||
             (segments[6] && (((VCOUNT - RY2) - DIAG_SZ) >= -((HCOUNT - RX4))) &&
              (((VCOUNT - RY2) - DIAG_SZ - SG_WD) < -((HCOUNT - RX4))) && (VCOUNT > RY2) && (VCOUNT <= (RY2 + DIAG_SZ))) ||
             (segments[5] && (((VCOUNT - RY4) - DIAG_SZ) >= -((HCOUNT - RX2))) &&
              (((VCOUNT - RY4) - DIAG_SZ - SG_WD) < -((HCOUNT - RX2))) && (VCOUNT > RY4) && (VCOUNT <= (RY4 + DIAG_SZ))) ||
             (segments[4] && (((VCOUNT - RY4) - DIAG_SZ) >= -((HCOUNT - RX4))) &&
              (((VCOUNT - RY4) - DIAG_SZ - SG_WD) < -((HCOUNT - RX4))) && (VCOUNT > RY4) && (VCOUNT <= (RY4 + DIAG_SZ))) ||
             (segments[3] && (((VCOUNT - RY6) - DIAG_SZ) >= -((HCOUNT - RX2))) &&
              (((VCOUNT - RY6) - DIAG_SZ - SG_WD) < -((HCOUNT - RX2))) && (VCOUNT > RY6) && (VCOUNT <= (RY6 + DIAG_SZ))) ||
             (segments[2] && (((VCOUNT - RY6) - DIAG_SZ) >= -((HCOUNT - RX4))) &&
              (((VCOUNT - RY6) - DIAG_SZ - SG_WD) < -((HCOUNT - RX4))) && (VCOUNT > RY6) && (VCOUNT <= (RY6 + DIAG_SZ))) ||
             (segments[1] && (((VCOUNT - RY8) - DIAG_SZ) >= -((HCOUNT - RX2))) &&
              (((VCOUNT - RY8) - DIAG_SZ - SG_WD) < -((HCOUNT - RX2))) && (VCOUNT > RY8) && (VCOUNT <= (RY8 + DIAG_SZ))) ||
             (segments[0] && (((VCOUNT - RY8) - DIAG_SZ) >= -((HCOUNT - RX4))) &&
              (((VCOUNT - RY8) - DIAG_SZ - SG_WD) < -((HCOUNT - RX4))) && (VCOUNT > RY8) && (VCOUNT <= (RY8 + DIAG_SZ)))) begin
        PAINT = 1'b1;
    end
end

endmodule
