%{
    /* Limited sentence recogniser */
    #include<stdio.h>
%}

%union {int number; int size; char* id;}
%start start
%token <number> INTEGER
%token <size> INT_SIZE
%token <id> IDENTIFIER
%token BEGINING BODY END MOVE ADD TO INPUT PRINT STRING SEMICOLON TERMINATOR INVALID

%%
start:          BEGINING TERMINATOR {}
// end:            END TERMINATOR {}
%%

extern FILE *yyin;

int main()
{
	do{
        yyparse();
    }
	while(!feof(yyin));
}

void yyerror(char *s)
{   
	fprintf(stderr, "%s\n", s);
}
