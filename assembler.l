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
end            	{ return END; }
[$][-]?[0-9]+		{ yylval.immval = strdup(yytext); return IMM; }
[R][0-9]+				{ yylval.regval = strdup(yytext); return REG; }
[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); 	return FLOAT; }
[0-9]+          { yylval.ival = atoi(yytext); 	return INT; }
[A-Z]{2,5}   		{ yylval.sval = strdup(yytext); return INSTR; }
[-]?[0-9]+[(][R][0-9]+[)] { yylval.relval = strdup(yytext); return REL; }
[\/\/].*				{ yylval.comment = strdup(yytext); return COMMENT; }
[.][a-zA-Z0-9]+	{ yylval.label = strdup(yytext); return LABEL; }
\n 							{ ++lineNum; return ENDL; }
,								;
%%
