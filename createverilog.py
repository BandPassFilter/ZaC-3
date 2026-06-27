def create_verilogROM(vfile, hfile):
    """
    create_verilogROM(file)
    creates a verilog ROM binary file to be used in FPGA RTL simulation testbenches.

    input: file = filename string for input binary file
    output: testROM.v
    """

    # initialise header block
    vfile.write("module ROM(clk, address, byte_mode, q);" + "\n")
    vfile.write("\t" + "input clk;" + "\n" + "\t" + "input [19:0] address;" + "\n" + "\t" + "input byte_mode;" + "\n" + "\t" + "output [15:0] q;" + "\n" + "\t" + "\n")
    vfile.write("\t" + "reg [15:0] internal_q = 0;" + "\n")
    vfile.write("\t" + "assign q[15:0] = internal_q[15:0];" + "\n")
    vfile.write("\t" + "always @ (posedge clk) begin" + "\n")
    #vfile.write("\t" + "\t" + "internal_q[15:0] = 0;" + "\n")
    vfile.write("\t" + "\t" + "case(address)" + "\n")

    # write main data loop
    hfile.seek(0)
    data = hfile.read()
    byte = 0
    line = ""
    address = 0

    if len(data) < 0x50000:
        max_address = len(data)
    else:
        max_address = 0x50000

    for i in range(0, max_address, 2):
        if (format(data[i], '02X') + format(data[i+1], '02X') == "0000"):
            line = ""
        else:
            line = "\t\t\t" + "20'h" + str(hex(address)[2:]) + ": internal_q = 16'h" + format(data[i], '02X') + format(data[i+1], '02X') + ";" + "\n"
        address += 2
        vfile.write(line)

    vfile.write("\t\t\t" + "default: internal_q = 16'b0;" + "\n")
    vfile.write("\t\t" + "endcase" + "\n")
    vfile.write("\t" + "\t" + "if (byte_mode) begin" + "\n")
    vfile.write("\t" + "\t" + "\t" +"if (address[0]) begin" + "\n")
    vfile.write("\t" + "\t" + "\t" + "\t" + "internal_q = {8'd0, internal_q[15:8]};" + "\n")
    vfile.write("\t" + "\t" + "\t" + "end else begin" + "\n")
    vfile.write("\t" + "\t" + "\t" + "\t" + "internal_q = {8'd0, internal_q[7:0]};" + "\n")
    vfile.write("\t" + "\t" + "\t" + "end" + "\n")
    vfile.write("\t" + "\t" + "end" + "\n")
    vfile.write("\t" + "end" + "\n")
    vfile.write("endmodule" + "\n")
    vfile.close()

hfile = open("program.bin", 'rb')
vfile = open("ROM.v", 'w')
create_verilogROM(vfile, hfile)