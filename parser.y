%{
    /* Limited sentence recogniser */
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include<stdbool.h>  
    
	extern int yylex();
	extern int yyparse();
    extern int yylineno;
    extern FILE *yyin;

    // Declarations
    void yyerror(char *s);
    void trimVariable(char *variable);
    void createVariable(int variableSize, char *variableName);
    bool checkVariable(char *variable);
    void moveIntegerToVariable(int integer, char *variable);
    void moveVariableToVariable(char *variableOne, char *variableTwo);

    // Tables
	#define MAX_VARIABLES 100
	char variableArray[MAX_VARIABLES][32];
	int variableSizes[MAX_VARIABLES];
	int numberOfVariables = 0;

%}

%union {
    int number;
    int size;
    char* id;
}
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
	fprintf(stderr, "Error (Line %d): %s\n", yylineno, s);
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
    trimVariable(variableName);
    
    // If variable does not exit
    if(checkVariable(variableName) == false)
    {
        strcpy(variableArray[numberOfVariables], variableName);
        variableSizes[numberOfVariables] = variableSize;
        numberOfVariables++;

        for(int j = 0; j < numberOfVariables; j++) {
            printf("%s ", variableArray[j]);
        }
        printf("\n");
    }
    else
    {
        printf("Warning (L%d): Identifier %s already initialised.\n", yylineno, variableName); 
    }
}

// Check if variable is already initialised
bool checkVariable(char *variable)
{
    for (int i = 0; i < numberOfVariables; i++) {
        if (strcmp(variable, variableArray[i]) == 0) {
            return 1;
        }
    }
    return false;
}

// Assigns an integer to variable
void moveIntegerToVariable(int integer, char *variable)
{

}

// Assigns a variable to a variable
void moveVariableToVariable(char *variableOne, char *variableTwo)
{

}
