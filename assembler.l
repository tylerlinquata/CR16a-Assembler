%{
	#include <iostream>
	#include "assembler.tab.h"	// to get token types from Bison

	using namespace std;
	extern int yylex();
	int linenum;
%}
%option noyywrap
%%
[ \t]		;
sNaZZle        	{ return SNAZZLE; }
type           	{ return TYPE; }
end            	{ return END; }
[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+          { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9]+    {
  // We have to strdup yytext because Flex will change it for the next token.
  // Note that this memory must be freed somewhere, so that's why we call
  // free() above in the Bison section.  (Aside: we use free() instead of
  // delete because strdup is a C function that uses malloc, not a C++
  // function that uses new.)
  yylval.sval = strdup(yytext);
  return STRING;
}
,		;
\n		{ cout << ++linenum << endl; }
%%
