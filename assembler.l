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
codedumpster   	{ return CODEDUMPSTER; }
type           	{ return TYPE; }
end            	{ return END; }
[R][0-9]+				{ yylval.regval = strdup(yytext); cout << "R"; return REG; }
[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); 	return FLOAT; }
[0-9]+          { yylval.ival = atoi(yytext); 	return INT; }
[A-Z]{2,4}   		{ yylval.sval = strdup(yytext); return INSTR; }
\n 							{ ++lineNum; return ENDL; }
,								;
%%
