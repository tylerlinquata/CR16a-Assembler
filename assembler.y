/*
 *  This file contains the bison declaration, which handles the parsing and grammer
 * portion of the assmebler. Built using the Flex & Bison guide found here
 * https://aquamentus.com/flex_bison.html#20
 * Authors: chris@aquamentus.com, Tyler Linquata
 */
%{
  #include <cstdio>
  #include <unordered_map>
  #include <vector>
  #include <iostream>
  #include <string.h>
  #include <fstream>
  #include "instruction.h"
  using namespace std;

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern int lineNum;

  // stores a map of all labels to their address
  unordered_map<string, int> jump_table;
  // stores a map of instructions that were called before their label
  unordered_map<string, int> unfilled_jumps;
  unordered_map<string, int> unfilled_branches;
  // stores a list of all parsed instructions
  vector<string> instruction_list;
  // file that machine code is written to
  ofstream writefile;
  // tracks the machine code line number
  int instruction_list_index;

  // various helper methods
  void write_instructions_to_file();
  void repair_labels();
  void label_instruction(string instruction, string label);
  void add_instruction(Instruction i);
  void process_label(string label);
  void yyerror(const char *s);
%}

// Bison fundamentally works by asking flex to get the next token, which it
// returns as an object of type "yystype".  Initially (by default), yystype
// is merely a typedef of "int", but for non-trivial projects, tokens could
// be of any arbitrary data type.  So, to deal with that, the idea is to
// override yystype's default typedef to be a C union instead.  Unions can
// hold all of the types of tokens that Flex could return, and this this means
// we can return ints or floats or strings cleanly.  Bison implements this
// mechanism with the %union directive:
%union {
  int ival;
  float fval;
  char *sval;
  char *regval;
  char *immval;
  char *relval;
  char *label;
  char *comment;
}

// define the constant string tokens:
%token CODEDUMPSTER TYPE
%token END ENDL

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> INSTR
%token <regval> REG
%token <immval> IMM;
%token <relval> REL;
%token <label> LABEL;
%token <comment> COMMENT;
%%

// the first rule defined is the highest-level rule, which in our
// case is just the concept of a whole assembly file:
assembler:
  header body_section footer {
      cout << "done with an asm file!" << endl;
  }
  ;
header:
  CODEDUMPSTER FLOAT ENDLS {
      cout << "reading a codedumpster file version " << $2 << endl;
  }
  ;
body_section:
  assembly_lines
  ;
assembly_lines  : assembly_lines reg_type_line
                | assembly_lines imm_type_line
                | assembly_lines single_reg_line
                | assembly_lines single_rel_line
                | assembly_lines rel_reg_line
                | assembly_lines reg_rel_line
                | assembly_lines rel_imm_line
                | assembly_lines imm_rel_line
                | assembly_lines jump_label
                | assembly_lines comment
                | assembly_lines branch_line
                | assembly_lines op_label_line
                | branch_line
                | reg_type_line
                | imm_type_line
                | single_reg_line
                | single_rel_line
                | rel_reg_line
                | reg_rel_line
                | rel_imm_line
                | imm_rel_line
                | jump_label
                | comment
                | op_label_line
                ;
branch_line:
  INSTR IMM ENDLS {
    cout << "op: " << $1 << " imm: " << $2 << endl;
    add_instruction(Instruction($1, $2));
    free($1);
    free($2);
    }
  ;
single_reg_line:
  INSTR REG ENDLS {
    cout << "op: " << $1 << " Rdst: " << " Rsrc: " << $2 << endl;
    add_instruction(Instruction($1, $2));
    free($1);
    free($2);
    }
  ;
reg_type_line:
    INSTR REG REG ENDLS {
      cout << "op: " << $1 << " Rdst: " << $3 << " Rsrc: " << $2 << endl;
      add_instruction(Instruction($1, $2, $3));
      free($1);
      free($2);
      free($3);
    }
  ;
imm_type_line:
    INSTR IMM REG ENDLS {
      cout << "op: " << $1 << " Rdst: " << $3 << " Imm: " << $2 << endl;
      add_instruction(Instruction($1, $2, $3));
      free($1);
      free($2);
      free($3);
    }
  ;
single_rel_line:
    INSTR REL ENDLS {
      cout << "op: " << $1 << " relative: " << $2 << endl;
      add_instruction(Instruction($1, $2));
      free($1);
      free($2);
    }
  ;
rel_reg_line:
    INSTR REL REG ENDLS {
      cout << "R-type op: " << $1 << " rel: " << $2 << " reg_1: " << $3 << endl;
      add_instruction(Instruction($1, $2, $3));
      free($1);
      free($2);
      free($3);
    }
  ;
reg_rel_line:
    INSTR REG REL ENDLS {
      cout << "R-type op: " << $1 << " reg: " << $2 << " rel: " << $3 << endl;
      add_instruction(Instruction($1, $2, $3));
      free($1);
      free($2);
      free($3);
    }
  ;
rel_imm_line:
    INSTR REL IMM ENDLS {
      cout << "I-type op: " << $1 << " rel: " << $2 << " imm: " << $3 << endl;
      add_instruction(Instruction($1, $2, $3));
      free($1);
      free($2);
      free($3);
    }
  ;
imm_rel_line:
    INSTR IMM REL ENDLS {
      cout << "I-type op: " << $1 << " imm: " << $2 << " rel: " << $3 << endl;
      add_instruction(Instruction($1, $2, $3));
      free($1);
      free($2);
      free($3);
    }
    ;
jump_label:
    LABEL ENDLS {
      cout << "this is a label: " << $1 << endl;
      process_label($1);
      free($1);
    }
    ;
op_label_line:
    INSTR LABEL ENDLS {
      label_instruction($1, $2);
      free($1);
      free($2);
    }
    ;
comment: COMMENT ENDLS;
footer:
  END ENDLS {
    repair_labels();
    write_instructions_to_file();
  }
  ;
ENDLS:
  ENDLS ENDL
  | ENDL ;
%%

// writes all instructions in the instruction list to the specified file
void write_instructions_to_file() {
  int i;
  for(i = 0; i < instruction_list.size(); i++) {
    writefile << instruction_list[i] << endl;
  }
}

// fixed instructions that were written with undeclared labels
void repair_labels() {
  int replace_line;
  string replacement_string;
  // iterate over each instruction that needs to be fixed
  for(auto const& it: unfilled_jumps) {
    replace_line = it.second - 1;
    // replace empty moves with correct label address
    Instruction i = Instruction("MOVI", "$" + to_string(jump_table[it.first]), "R15");
    instruction_list[replace_line] = i.instruction;
  }
  for(auto const& it: unfilled_branches) {
    replace_line = it.second - 1;
    // get binary string for displacement by trimming off first 8 characters
    Instruction i = Instruction("BNE", "$" + to_string(jump_table[it.first] - replace_line));
    // trim off first 8 values as we only care about last 8
    replacement_string = i.instruction.substr(8, i.instruction.size());
    instruction_list[replace_line] = instruction_list[replace_line].replace(8, 8,
      replacement_string);
  }
}

// processes an instruction called with a label
void label_instruction(string op, string label) {
  // if the operation is jump
  if(op[0] == 'J') {
    if(jump_table.find(label) != jump_table.end()) {
      cout << "op: MOVI, imm: " + to_string(jump_table[label]) + " reg: R15"<< endl;
      // put the address into R15
      add_instruction(Instruction("MOVI", "$" + to_string(jump_table[label]), "R15"));
    }
    else {
      // because we don't know where the label is yet we fill with zeroes
      cout << "op: MOVI, imm: $" + to_string(0) + " reg: R15" << endl;
      add_instruction(Instruction("MOVI", "$0", "R15"));
      // save this instruction to a list of instructions to be filled at EOF
      unfilled_jumps[label] = instruction_list_index;
    }

    cout << "op: " << op << " reg: R15" << endl;
    // branch or jump to value in R15
    add_instruction(Instruction(op, "R15"));
  }
  // if the operation is a branch
  if(op[0] == 'B') {
    if(jump_table.find(label) != jump_table.end()) {
      cout << "op: B, imm: $" << (jump_table[label] - instruction_list_index - 1) << endl;
      // put the address into R15
      add_instruction(Instruction(op, "$" + to_string(jump_table[label] - instruction_list_index - 1)));
      cout << label << endl;
    }
    else {
      // make an empty instruction
      add_instruction(Instruction(op, "$0"));
      // save the line that needs to be changed later
      unfilled_branches[label] = instruction_list_index;
    }
  }
}

// adds a label to the jump table
void process_label(string label) {
  // check if label already exists, return error if dup
  if(jump_table.find(label) != jump_table.end()) {
    yyerror("Duplicate label.");
  }
  // add to jump table
  else {
    jump_table[label] = instruction_list_index + 1;
  }
}

// adds an instruction to the instruction list
void add_instruction(Instruction i) {
  instruction_list.push_back(i.instruction);
  instruction_list_index++;
}

int main(int argc, char *argv[]) {
  instruction_list_index = 0;

  // Open a file handle to a particular file:
  if(argc == 1) {
    cout << "Missing command line arguments." << endl;
    exit(-1);
  }
  else if(argc == 2) {
    cout << "Missing write file" << endl;
  }
  else if(argc == 3){
    FILE *readfile = fopen(argv[1], "r");

    writefile.open(argv[2], ios::trunc);

    // Make sure it is valid:
    if (!readfile) {
      cout << "I can't open that read file!" << endl;
      return -1;
    }

    // Make sure it is valid:
    if (!writefile) {
      cout << "I can't open that write file!" << endl;
      return -1;
    }

    // Set Flex to read from it instead of defaulting to STDIN:
    yyin = readfile;

    // Parse through the input:
    yyparse();
  }
  else {
    cout << "Too many arguments" << endl;
  }
}

void yyerror(const char *s) {
  cout << "EEK, parse error on line " << lineNum << "! Message: " << s << endl;
  // might as well halt now:
  exit(-1);
}
