assembler.tab.c assembler.tab.h: assembler.y instruction.h
	bison -d assembler.y

lex.yy.c: assembler.l assembler.tab.h
	flex assembler.l

assembler: lex.yy.c assembler.tab.c assembler.tab.h instruction.h
	g++ -std=c++11 assembler.tab.c lex.yy.c -o assembler
