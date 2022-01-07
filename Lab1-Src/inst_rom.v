`timescale 1ns / 1ps
//*************************************************************************
//   > 文件名: inst_rom.v
//   > 描述  ：异步指令存储器模块，采用寄存器搭建而成，类似寄存器堆
//   >         内嵌好指令，只读，异步读
//   > 作者  : LOONGSON
//   > 日期  : 2016-04-14
//*************************************************************************
module inst_rom(
    input      [4 :0] addr, // 指令地址
    output reg [31:0] inst       // 指令
    );

    wire [31:0] inst_rom[26:0];  // 指令存储器，字节地址7'b000_0000~7'b111_1111
    //------------- 指令编码 ---------|指令地址|--- 汇编指令 -----|- 指令结果 -----//
//    assign inst_rom[ 0] = 32'h00000821; // 00H: addu  $1 ,$0,$0   | $1 = 0000_0000H
//    assign inst_rom[ 1] = 32'h24210002; // 04H: addiu $1 ,$1,#2   | $1 = 0000_0010H
//    assign inst_rom[ 2] = 32'h24210004; // 08H: addiu $1 ,$1,#4   | $1 = 0000_0110H
//    assign inst_rom[ 3] = 32'h24210006; // 0CH: addiu $1 ,$1,#6   | $1 = 12
//    assign inst_rom[ 4] = 32'h24210008; // 10H: addiu $1 ,$1,#8   | $1 = 20
//    assign inst_rom[ 5] = 32'h2421000A; // 14H: addiu $1 ,$1,#10   | $1 = 30
//    assign inst_rom[ 6] = 32'h2421000C; // 18H: addiu $1 ,$1,#12   | $1 = 42
//    assign inst_rom[ 7] = 32'h2421000E; // 1CH: addiu $1 ,$1,#14   | $1 = 56
//    assign inst_rom[ 8] = 32'h24210010; // 20H: addiu $1 ,$1,#16   | $1 = 72
//    assign inst_rom[ 9] = 32'h24210012; // 24H: addiu $1 ,$1,#18   | $1 = 90
//    assign inst_rom[10] = 32'h24210014; // 28H: addiu $1 ,$1,#20   | $1 = 110
//    assign inst_rom[11] = 32'h24210016; // 2CH: addiu $1 ,$1,#22   | $1 = 132
//    assign inst_rom[12] = 32'h24210018; // 30H: addiu $1 ,$1,#24   | $1 = 156
//    assign inst_rom[13] = 32'h2421001A; // 34H: addiu $1 ,$1,#26   | $1 = 182
//    assign inst_rom[14] = 32'h2421001C; // 38H: addiu $1 ,$1,#28   | $1 = 210
//    assign inst_rom[15] = 32'h2421001E; // 3CH: addiu $1 ,$1,#30   | $1 = 240
//    assign inst_rom[16] = 32'h24210020; // 40H: addiu $1 ,$1,#32   | $1 = 272
//    assign inst_rom[17] = 32'h24210022; // 44H: addiu $1 ,$1,#34   | $1 = 306
//    assign inst_rom[18] = 32'h24210024; // 48H: addiu $1 ,$1,#36   | $1 = 342
//    assign inst_rom[19] = 32'h24210026; // 30H: addiu $1 ,$1,#38   | $1 = 380
//    assign inst_rom[20] = 32'h24210028; // 34H: addiu $1 ,$1,#40   | $1 = 420
//    assign inst_rom[21] = 32'h2421002A; // 38H: addiu $1 ,$1,#42   | $1 = 462
//    assign inst_rom[22] = 32'h2421002C; // 3CH: addiu $1 ,$1,#44   | $1 = 506
//    assign inst_rom[23] = 32'h2421002E; // 40H: addiu $1 ,$1,#46   | $1 = 552
//    assign inst_rom[24] = 32'h24210030; // 44H: addiu $1 ,$1,#48   | $1 = 600
//    assign inst_rom[25] = 32'h24210032; // 48H: addiu $1 ,$1,#50   | $1 = 650
    assign inst_rom[ 0] = 32'h24010001; // 00H: addiu $1, $0, #1  | [$1] = 1H
    assign inst_rom[ 1] = 32'h00011100; // 04H: sll   $2, $1, #4  | [$2] = 10H
    assign inst_rom[ 2] = 32'h00411821; // 08H:[$3] = 0000_0011H
    assign inst_rom[ 3] = 32'h00022082; // 0CH:[$4] = 0000_0004H
    assign inst_rom[ 4] = 32'h00642823; // 10H:[$5] = 0000_000DH
    assign inst_rom[ 5] = 32'hAC250013; // 14H:Mem[0000_0014H] =0000_000DH
    assign inst_rom[ 6] = 32'h00A23027; // 18H:[$6] = FFFF_FFE2H
    assign inst_rom[ 7] = 32'h00C33825; // 1CH:[$7] = FFFF_FFF3H
    assign inst_rom[ 8] = 32'h00E64026; // 20H:[$8] = 0000_0011H
    assign inst_rom[ 9] = 32'hAC08001C; // 24H:Mem[0000_001CH] =0000_0011H
    assign inst_rom[10] = 32'h00C7482A; // 28H:[$9] = 0000_0001H
    assign inst_rom[11] = 32'h11210002; // 2CH:跳转到指令34H
    assign inst_rom[12] = 32'h24010004; // 30H:不执行
    assign inst_rom[13] = 32'h8C2A0013; // 34H:[$10] = 0000_000DH
    assign inst_rom[14] = 32'h15450003; // 38H:不跳
    assign inst_rom[15] = 32'h00415824; // 3CH:[$11] = 0000_0000H
    assign inst_rom[16] = 32'hAC0B001C; // 40H:Men[0000_001CH] =0000_0000H
    assign inst_rom[17] = 32'hAC040010; // 44H:Mem[0000_0010H] =0000_0004H
    assign inst_rom[18] = 32'h3C0C000C; // 48H:[$12] = 000C_0000H
    assign inst_rom[19] = 32'h08000000; // 4CH:跳转指令00H
//    assign inst_rom[26] = 32'h08000000; // 4CH: j     00H         | 跳转指令00H

    //读指令,取4字节
    always @(*)
    begin
        case (addr)
            5'd0 : inst <= inst_rom[0 ];
            5'd1 : inst <= inst_rom[1 ];
            5'd2 : inst <= inst_rom[2 ];
            5'd3 : inst <= inst_rom[3 ];
            5'd4 : inst <= inst_rom[4 ];
            5'd5 : inst <= inst_rom[5 ];
            5'd6 : inst <= inst_rom[6 ];
            5'd7 : inst <= inst_rom[7 ];
            5'd8 : inst <= inst_rom[8 ];
            5'd9 : inst <= inst_rom[9 ];
            5'd10: inst <= inst_rom[10];
            5'd11: inst <= inst_rom[11];
            5'd12: inst <= inst_rom[12];
            5'd13: inst <= inst_rom[13];
            5'd14: inst <= inst_rom[14];
            5'd15: inst <= inst_rom[15];
            5'd16: inst <= inst_rom[16];
            5'd17: inst <= inst_rom[17];
            5'd18: inst <= inst_rom[18];
            5'd19: inst <= inst_rom[19];
            5'd20: inst <= inst_rom[20];
            5'd21: inst <= inst_rom[21];
            5'd22: inst <= inst_rom[22];
            5'd23: inst <= inst_rom[23];
            5'd24: inst <= inst_rom[24];
            5'd25: inst <= inst_rom[25];
            5'd26: inst <= inst_rom[26];
            default: inst <= 32'd0;
        endcase
    end
endmodule