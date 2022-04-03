%{
    /* Limited sentence recogniser */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    
	extern int yylex();
	extern int yyparse();
    extern FILE *yyin;

    // Declarations
    void yyerror(char *s);
    void trimVariable(char *variable);
    void createVariable(int variableSize, char *variableName);
    void checkVariable(char *variable);
    void moveIntegerToVariable(int integer, char *variable);
    void moveVariableToVariable(char *variableOne, char *variableTwo);
%}

%union {int number; int size; char* id;}
%start start
%token <number> INTEGER
%token <size> INT_SIZE
%token <id> IDENTIFIER
%token BEGINING BODY END MOVE ADD TO INPUT PRINT STRING SEMICOLON TERMINATOR INVALID

%%
start:          BEGINING TERMINATOR declarations {}
declarations:   declaration declarations {}
                | body {}
declaration:    INT_SIZE IDENTIFIER TERMINATOR { createVariable($1, $2); }
body:           BODY TERMINATOR code {}
code:           line code {}
                | end {}
line:           print | input | move | add {}
print:          PRINT printStmt {}
printStmt:      STRING SEMICOLON printStmt {}
                | IDENTIFIER SEMICOLON printStmt { checkVariable($1); }
                | STRING TERMINATOR {}
                | IDENTIFIER TERMINATOR { checkVariable($1); }
input:          INPUT inputStmt {}
inputStmt:      IDENTIFIER TERMINATOR { checkVariable($1); }
                | IDENTIFIER SEMICOLON inputStmt { checkVariable($1); }
move:           MOVE INTEGER TO IDENTIFIER TERMINATOR { moveIntegerToVariable($2, $4); }
                | MOVE IDENTIFIER TO IDENTIFIER TERMINATOR { moveVariableToVariable($2, $4); }
add:            ADD INTEGER TO IDENTIFIER TERMINATOR { moveIntegerToVariable($2, $4); }
                | ADD IDENTIFIER TO IDENTIFIER TERMINATOR { moveVariableToVariable($2, $4); }
end:            END TERMINATOR { exit(EXIT_SUCCESS); }
%%

int main(int argc, char *argv[])
{
	do{
        yyparse();
    }
	while(!feof(yyin));
}

// Error handling
void yyerror(char *s)
{   
	fprintf(stderr, "%s\n", s);
}

// Trim variable
void trimVariable(char *variable)
{
    int lastCharIndex = strlen(variable)-1;
    if (variable[lastCharIndex] == '.') 
    {
        variable[lastCharIndex] = 0;
    }
}

// Creates a variable
void createVariable(int variableSize, char *variableName)
{

}

// Check if variable is initialised
void checkVariable(char *variable)
{

}

// Assigns an integer to variable
void moveIntegerToVariable(int integer, char *variable)
{

}

// Assigns a variable to a variable
void moveVariableToVariable(char *variableOne, char *variableTwo)
{

}
