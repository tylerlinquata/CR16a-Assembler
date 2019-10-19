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
  unordered_map<string, int> jump_table;
  vector<string> instruction_list;
  ofstream writefile;

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
                ;
branch_line: INSTR IMM ENDLS {
              cout << "op: " << $1 << " imm: " << $2 << endl;
              Instruction i = Instruction($1, $2);
              instruction_list.push_back(i.instruction);
              free($1);
              free($2);
           }
           ;
single_reg_line:
    INSTR REG ENDLS {
        cout << "op: " << $1 << " Rdst: " << " Rsrc: " << $2 << endl;
        Instruction i = Instruction($1, $2);
        instruction_list.push_back(i.instruction);
        free($1);
        free($2);
    }
  ;
reg_type_line:
    INSTR REG REG ENDLS {
      cout << "op: " << $1 << " Rdst: " << $3 << " Rsrc: " << $2 << endl;
      Instruction i = Instruction($1, $2, $3);
      instruction_list.push_back(i.instruction);
      free($1);
      free($2);
      free($3);
    }
  ;
imm_type_line:
    INSTR IMM REG ENDLS {
      cout << "op: " << $1 << " Rdst: " << $3 << " Imm: " << $2 << endl;
      Instruction i = Instruction($1, $2, $3);
      instruction_list.push_back(i.instruction);
      free($1);
      free($2);
      free($3);
    }
  ;
single_rel_line:
    INSTR REL ENDLS {
      cout << "op: " << $1 << " relative: " << $2 << endl;
      Instruction i = Instruction($1, $2);
      instruction_list.push_back(i.instruction);
      free($1);
      free($2);
    }
  ;
rel_reg_line:
    INSTR REL REG ENDLS {
      cout << "R-type op: " << $1 << " rel: " << $2 << " reg_1: " << $3 << endl;
      Instruction i = Instruction($1, $2, $3);
      instruction_list.push_back(i.instruction);
      free($1);
      free($2);
      free($3);
    }
  ;
reg_rel_line:
    INSTR REG REL ENDLS {
      cout << "R-type op: " << $1 << " reg: " << $2 << " rel: " << $3 << endl;
      Instruction i = Instruction($1, $2, $3);
      instruction_list.push_back(i.instruction);
      free($1);
      free($2);
      free($3);
    }
  ;
rel_imm_line:
    INSTR REL IMM ENDLS {
      cout << "I-type op: " << $1 << " rel: " << $2 << " imm: " << $3 << endl;
      Instruction i = Instruction($1, $2, $3);
      instruction_list.push_back(i.instruction);
      free($1);
      free($2);
      free($3);
    }
  ;
imm_rel_line:
    INSTR IMM REL ENDLS {
      cout << "I-type op: " << $1 << " imm: " << $2 << " rel: " << $3 << endl;
      Instruction i = Instruction($1, $2, $3);
      instruction_list.push_back(i.instruction);
      free($1);
      free($2);
      free($3);
    }
    ;
jump_label: LABEL ENDLS {
              cout << "this is a label: " << $1 << endl;
              free($1);
            }
            ;
comment: COMMENT ENDLS;
footer:
  END ENDLS {
    int i;
    for(i = 0; i < instruction_list.size(); i++) {
      writefile << instruction_list[i] << endl;
    }
  }
  ;
ENDLS:
  ENDLS ENDL
  | ENDL ;
%%

void process_label(string label) {
  // remove the leading .
  label = label.substr(1, label.size());

  // check if label already exists, return error if dup
  if(jump_table.find(label) != jump_table.end()) {
    yyerror("Duplicate label.");
  }
  // add to jump table
  else {
    jump_table[label] = lineNum;
  }
  cout << jump_table[label] << endl;
}

int main(int argc, char *argv[]) {

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
