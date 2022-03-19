flex lexer.l && 
bison -d parser.y &&
cc lex.yy.c parser.tab.c
cc lex.yy.o parser.tab.o -ll &&
./a.out < sample.jibuc