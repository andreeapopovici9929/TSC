/***********************************************************************
 * A SystemVerilog testbench for an instruction register.
 * The course labs will convert this to an object-oriented testbench
 * with constrained random test generation, functional coverage, and
 * a scoreboard for self-verification.
 **********************************************************************/

//interfata : virtual tb_ifc.TB Laborator2_new
import instr_register_pkg::*;

class First_test;
  virtual tb_ifc.TB Laborator2_new; // declararea interfatei in clasa#
  function new( virtual tb_ifc.TB interfata_functie );
    Laborator2_new=interfata_functie; // constructorului ii dam interfata
    //interfata_functiei- este parametrul iar Laborator2_new este interfata noastra 
  endfunction: new
  //int seed = 555; //valoare initiala cu care se incepe randomiazrea
  
  //initial begin //block unde lucram cu semnalele - e un task (initial-begin)
  task run();
    $display("\n\n***********************************************************");
    $display(    "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(    "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(    "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(    "************************FIRST HEADER***********************");
    $display(    "***********************************************************");

    $display("\nReseting the instruction register...");
    Laborator2_new.cb.write_pointer  <= 5'h00;         // initialize write pointer
    Laborator2_new.cb.read_pointer   <= 5'h1F;         // initialize read pointer
    Laborator2_new.cb.load_en        <= 1'b0;          // initialize load control line
    Laborator2_new.cb.reset_n        <= 1'b0;          // assert reset_n (active low)
    repeat (2) @(posedge Laborator2_new.cb) ;     // hold in reset for 2 clock cycles
    Laborator2_new.cb.reset_n        <= 1'b1;          // deassert reset_n (active low)

    $display("\nWriting values to register stack...");
    @(posedge Laborator2_new.cb) Laborator2_new.cb.load_en <= 1'b1;  // enable writing to register
    //repeat (7) begin
      repeat (10) begin
      @(posedge Laborator2_new.cb) randomize_transaction;
      @(negedge Laborator2_new.cb) print_transaction;
    end
    @(posedge Laborator2_new.cb) Laborator2_new.cb.load_en <= 1'b0;  // turn-off writing to register

    // read back and display same three register locations
    $display("\nReading back the same register locations written...");
    //for (int i=0; i<=2; i++) begin
    //  // later labs will replace this loop with iterating through a
    //  // scoreboard to determine which addresses were written and
    //  // the expected values to be read back
    //  @(posedge Laborator2_new.cb.clk) Laborator2_new.cb.read_pointer <= i;
    //  @(negedge Laborator2_new.cb.clk) print_results;
    //end
       for (int i=0; i<=9; i++) begin
      // later labs will replace this loop with iterating through a
      // scoreboard to determine which addresses were written and
      // the expected values to be read back
      @(posedge Laborator2_new.cb) Laborator2_new.cb.read_pointer <= i;
      @(negedge Laborator2_new.cb) print_results;
      end

    @(posedge Laborator2_new.cb) ;
    $display("\n***********************************************************");
    $display(  "***  THIS IS NOT A SELF-CHECKING TESTBENCH (YET).  YOU  ***");
    $display(  "***  NEED TO VISUALLY VERIFY THAT THE OUTPUT VALUES     ***");
    $display(  "***  MATCH THE INPUT VALUES FOR EACH REGISTER LOCATION  ***");
    $display(  "***********************************************************\n");
    $finish;
  //end
  endtask

  function void randomize_transaction; //FUNCTIA ARE TIMP DE SIMULARE0 - TASK POATE CONTINE TIMP DE SIMULARE  (IN TASK POTI PUNE INSTRUCTIUNI CARE CONSUMA TIMP)
    // A later lab will replace this function with SystemVerilog
    // constrained random values
    //
    // The stactic temp variable is required in order to write to fixed
    // addresses of 0, 1 and 2.  This will be replaceed with randomizeed
    // write_pointer values in a later lab
    //
    static int temp = 0;
   //Laborator2_new.cb.operand_a     <= $random(seed)%16;                 // between -15 and 15
   //Laborator2_new.cb.operand_b     <= $unsigned($random)%16;            // between 0 and 15
   //Laborator2_new.cb.opcode        <= opcode_t'($unsigned($random)%8);  // between 0 and 7, cast to opcode_t type //CAST-TRECE DIN INDEX IN STRING
    Laborator2_new.cb.operand_a     <= $urandom%16;                 // between -15 and 15
    Laborator2_new.cb.operand_b     <= $unsigned($urandom)%16;            // between 0 and 15
    Laborator2_new.cb.opcode        <= opcode_t'($unsigned($urandom)%8);  // between 0 and 7, cast to opcode_t type //CAST-TRECE DIN IND
    Laborator2_new.cb.write_pointer <= temp++;
  endfunction: randomize_transaction

  function void print_transaction; //FUNCTIA PRINTEAZA IN TRANSCRIPT VALORILE 
    $display("Writing to register location %0d: ", Laborator2_new.cb.write_pointer);
    $display("  opcode = %0d (%s)", Laborator2_new.cb.opcode, Laborator2_new.cb.opcode.name);
    $display("  operand_a = %0d",   Laborator2_new.cb.operand_a);
    $display("  operand_b = %0d\n", Laborator2_new.cb.operand_b);
    //$display("  result = %0d\n", Laborator2_new.cb.result);
    $display("  Time = %dns", $time());
  endfunction: print_transaction

  function void print_results;
    $display("Read from register location %0d: ", Laborator2_new.cb.read_pointer);
    $display("  opcode = %0d (%s)", Laborator2_new.cb.instruction_word.opc, Laborator2_new.cb.instruction_word.opc.name);
    $display("  operand_a = %0d",   Laborator2_new.cb.instruction_word.op_a);
    $display("  operand_b = %0d\n", Laborator2_new.cb.instruction_word.op_b);
    $display("  Result = %0d\n", Laborator2_new.cb.instruction_word.result);
    $display("  Time =  %dns", $time());
    //adaug result
  endfunction: print_results
endclass 

module instr_register_test(  tb_ifc.TB Laborator2_new);
    // user-defined types are defined in instr_register_pkg.sv
  
 // input  logic          clk,
 //  output logic          load_en,
 //  output logic          reset_n,
 //  output operand_t      operand_a,
 //  output operand_t      operand_b,
 //  output operand_r      result,
 //  output opcode_t       opcode,
 //  output address_t      write_pointer,
 //  output address_t      read_pointer,
 //  input  instruction_t  instruction_word
 
  //timeunit 1ns/1ns;

  initial begin
    First_test fs_test;
    fs_test=new(Laborator2_new); //adaugam interfata si o apelam  de aici direct, fara sa mai facem inca o linie suplimentara :fs_test.Laborator2_new=Laborator2_new;
    //fs_test.Laborator2_new=Laborator2_new;
    fs_test.run(); // apelarea task-ului creat mai jos
  end

endmodule: instr_register_test




//clasa - tot in afar de initial-begin intra intr-o clasa : functii, task-uri, interfata si variabile interne ( ex seed)