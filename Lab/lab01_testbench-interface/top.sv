/***********************************************************************
 * A SystemVerilog top-level netlist to connect testbench to DUT
 **********************************************************************/

module top;
  //timeunit 1ns/1ns;

  // user-defined types are defined in instr_register_pkg.sv
  import instr_register_pkg::*;

  // clock variables
  logic clk;
  logic test_clk;

	tb_ifc Laborator2Int (clk); //am importat interfata - am creat o instanta pentru interfata
  // interconnecting signals
  //logic          load_en;
  //logic          reset_n;
  //opcode_t       opcode;
  //operand_t      operand_a, operand_b;
  //address_t      write_pointer, read_pointer;
  //instruction_t  instruction_word;
  
//logic          load_en;
 // logic          reset_n;
  //opcode_t       opcode;
  //operand_t      operand_a, operand_b;
  //address_t      write_pointer, read_pointer;
  //instruction_t  instruction_word;

  // instantiate testbench and connect ports
  instr_register_test test (.Laborator2_new(Laborator2Int )); //.Laborator2_new -este firul pe care il folosim mai departe si care contine 
                                                     //semnalele care sunt 
   // .clk(test_clk),
    //.load_en(Laborator2Int.load_en),
    //.reset_n(Laborator2Int.reset_n),
    //.operand_a(Laborator2Int.operand_a),
    //.operand_b(Laborator2Int.operand_b),
    //.opcode(Laborator2Int.opcode),
    //.write_pointer(Laborator2Int.write_pointer),
    //.read_pointer(Laborator2Int.read_pointer),
    //.instruction_word(Laborator2Int.instruction_word)


  // instantiate design and connect ports
  instr_register dut (
    .clk(clk),
    .load_en(Laborator2Int.load_en),
    .reset_n(Laborator2Int.reset_n),
    .operand_a(Laborator2Int.operand_a),
    .operand_b(Laborator2Int.operand_b),
    //.result(Laborator2Int.result),
    .opcode(Laborator2Int.opcode),
    .write_pointer(Laborator2Int.write_pointer),
    .read_pointer(Laborator2Int.read_pointer),
    .instruction_word(Laborator2Int.instruction_word)
   );

  // clock oscillators
  initial begin
    clk <= 0;
    forever #5  clk = ~clk; //#5- odata la 5 unitati de timp clk se neaga
  end

  initial begin
    test_clk <=0;
    // offset test_clk edges from clk to prevent races between
    // the testbench and the design
    #4 forever begin //asteapta 4 unitati de timp inainte sa intre in forever 
      #2ns test_clk = 1'b1;
      #8ns test_clk = 1'b0;
    end
  end

endmodule: top
