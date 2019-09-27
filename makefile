assembler.tab.c assembler.tab.h: assembler.y
	bison -d assembler.y

lex.yy.c: assembler.l assembler.tab.h
	flex assembler.l

assembler: lex.yy.c assembler.tab.c assembler.tab.h
	g++ assembler.tab.c lex.yy.c -o assembler
