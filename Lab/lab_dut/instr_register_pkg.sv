/***********************************************************************
 * A SystemVerilog RTL model of an instruction regisgter:
 * User-defined type definitions
 **********************************************************************/
package instr_register_pkg; //
  //timeunit 1ns;1ns;

  typedef enum logic [3:0] { //typedef- definesti tipul de date - logic e pe cati biti
  	ZERO,
    PASSA, //ia val lui A
    PASSB, // ia val lui B
    ADD, //aduna valoarile
    SUB, //scadere
    MULT, // inmultire
    DIV, //divizare
    MOD
  } opcode_t; //opcode_t -tip de date custom definit de noi

  typedef logic signed [31:0] operand_t; // operand_t e tipul de date ( signed-e cu semn)
  typedef logic signed [63:0] result_t;
  
  typedef logic [4:0] address_t; //address_t-tip de date
  
 //urmeaza structura cu tipurile de date declarate mai sus
  typedef struct {
    opcode_t  opc; // ne spune ce operatie vom face
    operand_t op_a; // op_a, op_b,result -
    operand_t op_b; //op_b variabila
    result_t result;

  } instruction_t; // instruction_t-UN package 
   // insturction_t e tot un fel de tip de date, un package care are 4 valori diferite ( opc,_op_a,op_b,result)

endpackage: instr_register_pkg
