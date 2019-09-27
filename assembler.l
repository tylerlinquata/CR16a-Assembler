%{
	#include <iostream>
	#include "assembler.tab.h"	// to get token types from Bison

	using namespace std;
	extern int yylex();
	int lineNum = 1;
%}
%option noyywrap
%%
[ \t]						;
sNaZZle        	{ return SNAZZLE; }
type           	{ return TYPE; }
end            	{ return END; }
[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); 	return FLOAT; }
[0-9]+          { yylval.ival = atoi(yytext); 	return INT; }
[a-zA-Z0-9]+    { yylval.sval = strdup(yytext); return STRING; }
\n 							{ ++lineNum; return ENDL; }
,								;
%%
