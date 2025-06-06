module dm_controller(
    input mem_w,
    input [31:0] Addr_in,
    input [31:0] Data_write,
    input [2:0] dm_ctrl,
    input [31:0] Data_read_from_dm,
    output [31:0] Data_read,
    output [31:0] Data_write_to_dm,
    output [3:0] wea_mem
    );

    reg [31:0] t_Data_read;
    reg [31:0] t_Data_write_to_dm;
    reg [3:0]  t_wea_mem;

    //read
    always @(*) begin
        case (dm_ctrl)
            3'b000: t_Data_read = Data_read_from_dm; //word
            3'b001:begin //signed halfword
                case(Addr_in[1])
                    1'b0: t_Data_read = {{16{Data_read_from_dm[15]}}, Data_read_from_dm[15:0]};
                    1'b1: t_Data_read = {{16{Data_read_from_dm[31]}}, Data_read_from_dm[31:16]};
                endcase
            end
            3'b010:begin //unsigned halfword
                case(Addr_in[1])
                    1'b0: t_Data_read = {16'b0, Data_read_from_dm[15:0]};
                    1'b1: t_Data_read = {16'b0, Data_read_from_dm[31:16]};
                endcase
            end
            3'b011:begin //signed byte
                case(Addr_in[1:0])
                    2'b00: t_Data_read = {{24{Data_read_from_dm[7]}}, Data_read_from_dm[7:0]};
                    2'b01: t_Data_read = {{24{Data_read_from_dm[15]}}, Data_read_from_dm[15:8]};
                    2'b10: t_Data_read = {{24{Data_read_from_dm[23]}}, Data_read_from_dm[23:16]};
                    2'b11: t_Data_read = {{24{Data_read_from_dm[31]}}, Data_read_from_dm[31:24]};
                endcase
            end
            3'b100:begin //unsigned byte
                case(Addr_in[1:0])
                    2'b00: t_Data_read = {24'b0, Data_read_from_dm[7:0]};
                    2'b01: t_Data_read = {24'b0, Data_read_from_dm[15:8]};
                    2'b10: t_Data_read = {24'b0, Data_read_from_dm[23:16]};
                    2'b11: t_Data_read = {24'b0, Data_read_from_dm[31:24]};
                endcase
            end           
            default: t_Data_read = 32'h00000000;
        endcase
    end

    //write
    always @(*) begin
        if (mem_w == 1'b0) begin
            t_wea_mem = 4'b0000;
            t_Data_write_to_dm = 32'h00000000;
        end
        else begin
            case (dm_ctrl)
                3'b000:begin //word
                    t_wea_mem = 4'b1111;
                    t_Data_write_to_dm = Data_write;
                end
                3'b001, 3'b010:begin //halfword
                    case(Addr_in[1])
                        1'b0:begin
                            t_wea_mem = 4'b0011;
                            t_Data_write_to_dm = {16'b0, Data_write[15:0]};
                        end
                        1'b1:begin
                            t_wea_mem = 4'b1100;
                            t_Data_write_to_dm = {Data_write[15:0], 16'b0};
                        end
                    endcase
                end
                3'b011, 3'b100:begin //byte
                    case(Addr_in[1:0])
                        2'b00:begin
                            t_wea_mem = 4'b0001;
                            t_Data_write_to_dm = {24'b0, Data_write[7:0]};
                        end
                        2'b01:begin
                            t_wea_mem = 4'b0010;
                            t_Data_write_to_dm = {16'b0, Data_write[7:0], 8'b0};                    
                        end
                        2'b10:begin
                            t_wea_mem = 4'b0100;
                            t_Data_write_to_dm = {8'b0, Data_write[7:0], 16'b0};                        
                        end
                        2'b11:begin
                            t_wea_mem = 4'b1000;
                            t_Data_write_to_dm = {Data_write[7:0], 24'b0};                        
                        end
                    endcase
                end
                
                default:begin
                    t_wea_mem = 4'b0000;
                    t_Data_write_to_dm = 32'h00000000;
                end
            endcase
        end   
    end

    assign Data_read = t_Data_read;
    assign Data_write_to_dm = t_Data_write_to_dm;
    assign wea_mem = t_wea_mem;

endmodule
