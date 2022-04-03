# Generates lex.yy.c
flex lexer.l

# Generates y.tab.c and y.tab.h
bison -d parser.y

# Compiles C files
gcc -c lex.yy.c parser.tab.c
gcc -o output lex.yy.o parser.tab.o -lfl

# Execute output
./output < sample.jibuc