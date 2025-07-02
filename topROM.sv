module topROM #(FPGAFREQ = 50_000_000)(
    input logic CLK,
    input logic nRST,
    input logic nPBTON,
    output logic HS,
    output logic VS,
    output logic [11:0] RGB
);

    // Señales de control
    logic RST;
    logic PBTON;

    assign RST = ~nRST;
    assign PBTON = ~nPBTON;
	 
    // Señales de temporización
    logic clkdiv0;
    logic [9:0] counter;
    logic [3:0] units, tens, hundreds;

    // Señales VGA
    logic [11:0] rgb_aux;
    logic [10:0] hcount, vcount;
    logic blank;

    // Señales de pintura
    logic PAINTU, PAINTD, PAINTC,PAINTS, PAINT34SEG,PAINT134SEG, PAINT234SEG,PAINT334SEG,paintImg1,paintImg2,paintImg3,paintImg4;

    ///////// Generación de clock dividido /////////
    cntdiv_n #(FPGAFREQ) cntDiv0(CLK, RST, clkdiv0);

    ///////// Controlador VGA /////////
    vga_ctrl_640x480_60Hz vga_ctrl_inst (
        .rst(RST),
        .clk(CLK),
        .rgb_in(rgb_aux), // aqui en es donde utilizamos rgb_aux que es la variable que guarda la señal el color de la imagen, en esta parte se entrelaza rgb_aux y rgb_int en el modulo controlador de la pantalla
        .HS(HS),
        .VS(VS),
        .hcount(hcount),
        .vcount(vcount),
        .rgb_out(RGB),
        .blank(blank)
    );

    ///////// Displays /////////
    display #(5, 30, 40, 10, 5) displayU(hcount, vcount, units, PAINTU);
    display #(5, 30, 40, 50, 5)  displayD(hcount, vcount, tens, PAINTD);
    display #(5, 30, 40, 550, 5) displayC(hcount, vcount, hundreds, PAINTC);
	 display #(5, 30, 40, 600, 5) displayS(hcount, vcount, hundreds, PAINTS);
	 
    display34segm #(4, 80) display134(60, 10, 34'hFFFFFFFFF, hcount, vcount, PAINT134SEG);
	 display34segm #(4, 80) display234(140, 5, 34'hFFFFFFFFF, hcount, vcount, PAINT234SEG);
	 display34segm #(4, 80) display334(400, 5, 34'hFFFFFFFFF, hcount, vcount, PAINT334SEG);
	 display34segm #(4, 80) display434(480, 5, 34'hFFFFFFFFF, hcount, vcount, PAINT434SEG);

    ///////// Imagen ROM /////////
    image #(.POSX(300), .POSY(100)) drawImg1 (
        .pix_x(hcount),
        .pix_y(vcount),
        .paint(paintImg1)
    );
	 imageROM1 #(.POSX(300), .POSY(50)) drawImg2 (
        .pix_x(hcount),
        .pix_y(vcount),
        .paint(paintImg2)
    );
	 imageROM2 #(.POSX(300), .POSY(20)) drawImg3 (
        .pix_x(hcount),
        .pix_y(vcount),
        .paint(paintImg3)
    );
	 imageROM3 #(.POSX(300), .POSY(10)) drawImg4 (
        .pix_x(hcount),
        .pix_y(vcount),
        .paint(paintImg4)
    );
//.	
    ///////// Lógica de color /////////
	 
	 //rgb aux es la señal que guarda el color que se muestra en la pantalla
	 
    always_comb begin
        rgb_aux = 12'h020; // color por defecto (fondo)
		  
        if (PAINTC)
            rgb_aux = 12'hFF0; // amarillo
        else if (PAINTD)
            rgb_aux = 12'h00F; // azul
		  else if (PAINTS)
            rgb_aux = 12'h00F; // azul
        else if (PAINTU)
            rgb_aux = 12'hF00; // rojo
        else if (PAINT134SEG)
            rgb_aux = 12'h00F; // verde claro
		  else if (PAINT234SEG)
            rgb_aux = 12'h00F; // verde claro
		  else if (PAINT334SEG)
            rgb_aux = 12'h00F; // verde claro
		  else if (PAINT434SEG)
            rgb_aux = 12'h00F; // verde claro
        else if (paintImg1)
            rgb_aux = 12'hB4A; // imagen
		  else if (paintImg2)
            rgb_aux = 12'hB4A; // imagen
		  else if (paintImg3)
            rgb_aux = 12'hB4A; // imagen
		  else if (paintImg4)
            rgb_aux = 12'hB4A; // imagen
    end
	 
	 
	 

    ///////// Contador /////////
    always_ff @(posedge clkdiv0, posedge RST) begin
        if (RST)
            counter <= 0;
        else if (PBTON)
            counter <= (counter == 999) ? 0 : counter + 1;
    end

    ///////// Conversión a unidades, decenas y centenas /////////
    always_comb begin
        units    = 4'(counter % 10);
        tens     = 4'((counter / 10) % 10);
        hundreds = 4'(counter / 100);
    end

endmodule
