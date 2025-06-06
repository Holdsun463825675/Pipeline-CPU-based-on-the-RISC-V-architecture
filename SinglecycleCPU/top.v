module top(
    input rstn,
    input [4:0] btn_i,
    input [15:0] sw_i,
    input clk,
    output [7:0] disp_an_o,
    output [7:0] disp_seg_o,
    output [15:0] led_o
    );

    //clk,reset
    wire clkn = ~clk;
    wire rst = ~rstn;

    //define wires
    //U1
    wire U1_clk, U1_reset, U1_MIO_ready, U1_mem_w, U1_CPU_MIO, U1_INT;
    wire [31:0] U1_inst_in, U1_Data_in, U1_PC_out, U1_Addr_out, U1_Data_out;
    wire [2:0] U1_dm_ctrl;
    //U2
    wire [9:0] U2_a;
    wire [31:0] U2_spo;
    //U3
    wire U3_mem_w;
    wire [31:0] U3_Addr_in, U3_Data_write, U3_Data_read_from_dm, U3_Data_read, U3_Data_write_to_dm;
    wire [2:0] U3_dm_ctrl;
    wire [3:0] U3_wea_mem;
    //U4_RAM_B
    wire [9:0] U4_addra;
    wire U4_clka;
    wire [31:0] U4_dina, U4_douta;
    wire [3:0] U4_wea;
    //U4_MIO_BUSb
    wire U4_clk, U4_rst, U4_mem_w, U4_counter0_out, U4_counter1_out, U4_counter2_out, U4_data_ram_we, U4_GPIOf0000000_we, U4_GPIOe0000000_we, U4_counter_we;
    wire [4:0] U4_BTN;
    wire [15:0] U4_SW, U4_led_out;
    wire [31:0] U4_PC, U4_Cpu_data2bus, U4_addr_bus, U4_ram_data_out, U4_counter_out, U4_Cpu_data4bus, U4_ram_data_in, U4_Peripheral_in;
    wire [9:0] U4_ram_addr;
    //U5
    wire U5_clk, U5_rst, U5_EN;
    wire [2:0] U5_Switch;
    wire [63:0] U5_point_in, U5_LES;
    wire [31:0] U5_data0, U5_data1, U5_data2, U5_data3, U5_data4, U5_data5, U5_data6, U5_data7, U5_Disp_num;
    wire [7:0] U5_point_out, U5_LE_out;
    //U6
    wire U6_clk, U6_rst, U6_SW0, U6_flash;
    wire [31:0] U6_Hexs;
    wire [7:0] U6_point, U6_LES, U6_seg_an, U6_seg_sout;
    //U7
    wire U7_clk, U7_rst, U7_EN;
    wire [31:0] U7_P_Data;
    wire [1:0] U7_counter_set;
    wire [15:0] U7_LED_out, U7_led;
    wire [13:0] U7_GPIOf0;
    //U8
    wire U8_clk, U8_rst, U8_SW2, U8_Clk_CPU;
    wire [31:0] U8_clkdiv;
    //U9
    wire U9_clk, U9_rst, U9_clk0, U9_clk1, U9_clk2, U9_counter_we, U9_counter0_OUT, U9_counter1_OUT, U9_counter2_OUT;
    wire [31:0] U9_counter_val, U9_counter_out;
    wire [1:0] U9_counter_ch;
    //U10
    wire U10_clk;
    wire [4:0] U10_BTN, U10_BTN_out;
    wire [15:0] U10_SW, U10_SW_out;

    //clk,reset
    wire U8_Clkn_CPU = ~U8_Clk_CPU;

    //connect wires
    //U1
    assign U1_clk = U8_Clk_CPU;
    assign U1_reset = rst;
    assign U1_MIO_ready = U1_CPU_MIO;
    assign U1_inst_in = U2_spo;
    assign U1_Data_in = U3_Data_read;
    assign U1_INT = U9_counter0_OUT;
    //U2
    assign U2_a = U1_PC_out[11:2];
    //U3
    assign U3_mem_w = U1_mem_w;
    assign U3_Addr_in = U1_Addr_out;
    assign U3_Data_write = U4_ram_data_in;
    assign U3_dm_ctrl = U1_dm_ctrl;
    assign U3_Data_read_from_dm = U4_Cpu_data4bus;
    //U4_RAM_B 
    assign U4_addra = U4_ram_addr;
    assign U4_clka = clkn;
    assign U4_dina = U3_Data_write_to_dm;
    assign U4_wea = U3_wea_mem;
    //U4_MIO_BUS
    assign U4_clk = clk;
    assign U4_rst = rst;
    assign U4_BTN = U10_BTN_out;
    assign U4_SW = U10_SW_out;
    assign U4_mem_w = U1_mem_w;
    assign U4_Cpu_data2bus = U1_Data_out;
    assign U4_addr_bus = U1_Addr_out;
    assign U4_ram_data_out = U4_douta;
    assign U4_led_out = U7_LED_out;
    assign U4_counter_out = 32'h00000000;
    assign U4_counter0_out = U9_counter0_OUT;
    assign U4_counter1_out = U9_counter1_OUT;
    assign U4_counter2_out = U9_counter2_OUT;
    //U5
    assign U5_clk = U8_Clkn_CPU;
    assign U5_rst = rst;
    assign U5_EN = U4_GPIOe0000000_we;
    assign U5_Switch = U10_SW_out[7:5];
    assign U5_point_in = {U8_clkdiv[31:0],U8_clkdiv[31:0]};
    assign U5_LES = ~64'h00000000;
    assign U5_data0 = U4_Peripheral_in;
    assign U5_data1 = {1'b0,1'b0,U1_PC_out[31:2]};
    assign U5_data2 = U2_spo;
    assign U5_data3 = 32'h00000000;
    assign U5_data4 = U1_Addr_out;
    assign U5_data5 = U1_Data_out;
    assign U5_data6 = U4_Cpu_data4bus;
    assign U5_data7 = U1_PC_out;
    //U6
    assign U6_clk = clk;
    assign U6_rst = rst;
    assign U6_SW0 = U10_SW_out[0];
    assign U6_flash = U8_clkdiv[10];
    assign U6_Hexs = U5_Disp_num;
    assign U6_point = U5_point_out;
    assign U6_LES = U5_LE_out;
    //U7
    assign U7_clk = U8_Clkn_CPU;
    assign U7_rst = rst;
    assign U7_EN = U4_GPIOf0000000_we;
    assign U7_P_Data = U4_Peripheral_in;
    //U8
    assign U8_clk = clk;
    assign U8_rst = rst;
    assign U8_SW2 = U10_SW_out[2];
    //U9
    assign U9_clk = U8_Clkn_CPU;
    assign U9_rst = rst;
    assign U9_clk0 = U8_clkdiv[6];
    assign U9_clk1 = U8_clkdiv[9];
    assign U9_clk2 = U8_clkdiv[11];
    assign U9_counter_we = U4_counter_we;
    assign U9_counter_val = U4_Peripheral_in;
    assign U9_counter_ch = U7_counter_set;
    //U10
    assign U10_clk = clk;
    assign U10_BTN = btn_i;
    assign U10_SW = sw_i;

    //module instantiation
    singlecyclecpu U1_singlecyclecpu (
        .clk(U1_clk),
        .reset(U1_reset),
        .MIO_ready(U1_MIO_ready),
        .inst_in(U1_inst_in),
        .Data_in(U1_Data_in),
        .mem_w(U1_mem_w),
        .PC_out(U1_PC_out),
        .Addr_out(U1_Addr_out),
        .Data_out(U1_Data_out),
        .dm_ctrl(U1_dm_ctrl),
        .CPU_MIO(U1_CPU_MIO),
        .INT(U1_INT)
    );

    ROM_D U2_ROMD (
        .a(U2_a),
        .spo(U2_spo)
    );

    dm_controller U3_dm_controller (
        .mem_w(U3_mem_w),
        .Addr_in(U3_Addr_in),
        .Data_write(U3_Data_write),
        .dm_ctrl(U3_dm_ctrl),
        .Data_read_from_dm(U3_Data_read_from_dm),
        .Data_read(U3_Data_read),
        .Data_write_to_dm(U3_Data_write_to_dm),
        .wea_mem(U3_wea_mem)
    );

    RAM_B U4_RAM_B (
        .clka(U4_clka),
        .wea(U4_wea),
        .addra(U4_addra),
        .dina(U4_dina),
        .douta(U4_douta)
    );

    MIO_BUS U4_MIO_BUS (
        .clk(U4_clk),
        .rst(U4_rst),
        .BTN(U4_BTN),
        .SW(U4_SW),
        .PC(U4_PC),
        .mem_w(U4_mem_w),
        .Cpu_data2bus(U4_Cpu_data2bus),
        .addr_bus(U4_addr_bus),
        .ram_data_out(U4_ram_data_out),
        .led_out(U4_led_out),
        .counter_out(U4_counter_out),
        .counter0_out(U4_counter0_out),
        .counter1_out(U4_counter1_out),
        .counter2_out(U4_counter2_out),
        .Cpu_data4bus(U4_Cpu_data4bus),
        .ram_data_in(U4_ram_data_in),
        .ram_addr(U4_ram_addr),
        .data_ram_we(U4_data_ram_we),
        .GPIOf0000000_we(U4_GPIOf0000000_we),
        .GPIOe0000000_we(U4_GPIOe0000000_we),
        .counter_we(U4_counter_we),
        .Peripheral_in(U4_Peripheral_in)
    );

    Multi_8CH32 U5_Multi_8CH32 (
        .clk(U5_clk),
        .rst(U5_rst),
        .EN(U5_EN),
        .Switch(U5_Switch),
        .point_in(U5_point_in),
        .LES(U5_LES),
        .data0(U5_data0),
        .data1(U5_data1),
        .data2(U5_data2),
        .data3(U5_data3),
        .data4(U5_data4),
        .data5(U5_data5),
        .data6(U5_data6),
        .data7(U5_data7),
        .point_out(U5_point_out),
        .LE_out(U5_LE_out),
        .Disp_num(U5_Disp_num)
    );

    SSeg7 U6_SSeg7 (
        .clk(U6_clk),
        .rst(U6_rst),
        .SW0(U6_SW0),
        .flash(U6_flash),
        .Hexs(U6_Hexs),
        .point(U6_point),
        .LES(U6_LES),
        .seg_an(U6_seg_an),
        .seg_sout(U6_seg_sout)
    );

    SPIO U7_SPIO (
        .clk(U7_clk),
        .rst(U7_rst),
        .EN(U7_EN),
        .P_Data(U7_P_Data),
        .counter_set(U7_counter_set),
        .LED_out(U7_LED_out),
        .led(U7_led),
        .GPIOf0(U7_GPIOf0)
    );

    clk_div U8_clk_div (
        .clk(U8_clk),
        .rst(U8_rst),
        .SW2(U8_SW2),
        .clkdiv(U8_clkdiv),
        .Clk_CPU(U8_Clk_CPU)
    );

    Counter_x U9_Counter_x (
        .clk(U9_clk),
        .rst(U9_rst),
        .clk0(U9_clk0),
        .clk1(U9_clk1),
        .clk2(U9_clk2),
        .counter_we(U9_counter_we),
        .counter_val(U9_counter_val),
        .counter_ch(U9_counter_ch),
        .counter0_OUT(U9_counter0_OUT),
        .counter1_OUT(U9_counter1_OUT),
        .counter2_OUT(U9_counter2_OUT),
        .counter_out(U9_counter_out)
    );

    Enter U10_Enter (
        .clk(U10_clk),
        .BTN(U10_BTN),
        .SW(U10_SW),
        .BTN_out(U10_BTN_out),
        .SW_out(U10_SW_out)
    );

    //output
    assign disp_an_o = U6_seg_an;
    assign disp_seg_o = U6_seg_sout;
    assign led_o = U7_led;

endmodule