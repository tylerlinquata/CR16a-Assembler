%{
	#include <iostream>
	using namespace std;
	extern int yylex();
	int linenum;
%}
%option noyywrap
%%
[ \t]		;
[a-zA-Z]+	{ cout << "Found an operation:" << yytext << endl; }
[R][0-9]+	{ cout << "Found a register:" << yytext << endl; }
[$][0-9]+	{ cout << "Found an immediate:" << yytext << endl; }
,		;
\n		{ cout << ++linenum << endl; }
%%
int main(int, char**) {
	// lex through the input:
	while(yylex());
}
