%{
  #include <cstdio>
  #include <iostream>
  using namespace std;

  // Declare stuff from Flex that Bison needs to know about:
  extern int yylex();
  extern int yyparse();
  extern FILE *yyin;

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
}

// define the constant string tokens:
%token SNAZZLE TYPE
%token END

// Define the "terminal symbol" token types I'm going to use (in CAPS
// by convention), and associate each with a field of the %union:
%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING

%%
// This is the actual grammar that bison will parse, but for right now it's just
// something silly to echo to the screen what bison gets from flex.  We'll
// make a real one shortly:
// the first rule defined is the highest-level rule, which in our
// case is just the concept of a whole "snazzle file":
snazzle:
  header template body_section footer {
      cout << "done with a snazzle file!" << endl;
    }
  ;
header:
  SNAZZLE FLOAT {
      cout << "reading a snazzle file version " << $2 << endl;
    }
  ;
template:
  typelines
  ;
typelines:
  typelines typeline
  | typeline
  ;
typeline:
  TYPE STRING {
      cout << "new defined snazzle type: " << $2 << endl;
      free($2);
    }
  ;
body_section:
  body_lines
  ;
body_lines:
  body_lines body_line
  | body_line
  ;
body_line:
  INT INT INT INT STRING {
      cout << "new snazzle: " << $1 << $2 << $3 << $4 << $5 << endl;
      free($5);
    }
  ;
footer:
  END
  ;

%%

int main(int, char**) {
  // Open a file handle to a particular file:
  FILE *myfile = fopen("file.asm", "r");
  // Make sure it is valid:
  if (!myfile) {
    cout << "I can't open a.snazzle.file!" << endl;
    return -1;
  }
  // Set Flex to read from it instead of defaulting to STDIN:
  yyin = myfile;

  // Parse through the input:
  yyparse();

}

void yyerror(const char *s) {
  cout << "EEK, parse error!  Message: " << s << endl;
  // might as well halt now:
  exit(-1);
}