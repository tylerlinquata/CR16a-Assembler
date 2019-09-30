%{
  #include <cstdio>
  #include <iostream>
  using namespace std;

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;
  extern int lineNum;

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
%%

// the first rule defined is the highest-level rule, which in our
// case is just the concept of a whole "snazzle file":
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
assembly_lines:
  assembly_lines reg_type_line | assembly_lines assembly_line
  | assembly_lines imm_type_line | assembly_lines single_reg_line | assembly_line | reg_type_line |
  imm_type_line | single_reg_line
  ;
assembly_line:
  INSTR ENDLS {
      cout << "instruction: " << $1 << endl;
      free($1);
    }
  ;
single_reg_line:
    INSTR REG ENDLS {
        cout << "instruction: " << $1 << " reg: " << $2 << endl;
        free($1);
        free($2);
    }
  ;
reg_type_line:
    INSTR REG REG ENDLS {
      cout << "R-type op: " << $1 << " reg_1: " << $2 << " reg_2: " << $3 << endl;
      free($1);
      free($2);
      free($3);
    }
  ;
imm_type_line:
    INSTR REG IMM ENDLS {
      cout << "I-Type op: " << $1 << " reg: " << $2 << " imm: " << $3 << endl;
      free($1);
      free($3);
    }
  ;
footer:
  END ENDLS
  ;
ENDLS:
  ENDLS ENDL
  | ENDL ;
%%

int main(int, char**) {
  // Open a file handle to a particular file:
  FILE *myfile = fopen("file.asm", "r");
  // Make sure it is valid:
  if (!myfile) {
    cout << "I can't open that file!" << endl;
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;

  // Parse through the input:
  yyparse();

}

void yyerror(const char *s) {
  cout << "EEK, parse error on line " << lineNum << "! Message: " << s << endl;
  // might as well halt now:
  exit(-1);
}
