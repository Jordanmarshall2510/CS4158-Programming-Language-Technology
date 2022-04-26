%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <stdbool.h> 
    
	extern int yylex();
	extern int yyparse();
    extern int yylineno;
    extern FILE *yyin;

    // Declarations
    void yyerror(char *s);
    void trimVariable(char *variable);
    void createVariable(int variableSize, char *variableName);
    void checkVariable(char *variable);
    bool isVariable(char *variable);
    int getVariableSizeFromArray(char *variable);
    void getFirstVariable(char *variable);
    void moveIntegerToVariable(int integer, char *variable);
    void moveVariableToVariable(char *variableOne, char *variableTwo);
    int getNumberOfDigitsInInteger(int integer);

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
%token BEGINING BODY END MOVE ADD INPUT PRINT TO SEMICOLON TERMINATOR STRING

%%
start:          BEGINING TERMINATOR declarations {}
                ;
declarations:   declaration declarations {}
                | body {}
                ;
declaration:    INT_SIZE IDENTIFIER TERMINATOR { createVariable($1, $2); }
                ;
body:           BODY TERMINATOR code {}
                ;
code:           line code {}
                | end {}
                ;
line:           print 
                | input {}
                | move {}
                | add {}
                ;
print:          PRINT printStatement {}
                ;
printStatement: STRING SEMICOLON printStatement {}
                | IDENTIFIER SEMICOLON printStatement { checkVariable($1); }
                | STRING TERMINATOR {}
                | IDENTIFIER TERMINATOR { checkVariable($1); }
                ;
input:          INPUT inputStatement {}
                ;
inputStatement: IDENTIFIER TERMINATOR { checkVariable($1); }
                | IDENTIFIER SEMICOLON inputStatement { checkVariable($1); }
                ;
move:           MOVE INTEGER TO IDENTIFIER TERMINATOR { moveIntegerToVariable($2, $4); }
                | MOVE IDENTIFIER TO IDENTIFIER TERMINATOR { moveVariableToVariable($2, $4); }
                ;
add:            ADD INTEGER TO IDENTIFIER TERMINATOR { moveIntegerToVariable($2, $4); }
                | ADD IDENTIFIER TO IDENTIFIER TERMINATOR { moveVariableToVariable($2, $4); }
                ;
end:            END TERMINATOR {exit(EXIT_SUCCESS);}
                ;
%%

// Main function
int main(int argc, char *argv[])
{
	do
    {
        yyparse();
    }
	while(!feof(yyin));
}

// Error handling
void yyerror(char *s)
{   
	fprintf(stderr, "Error [Line %d]: %s.\n", yylineno, s);
}

// Trim variable by removing terminator
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
    
    // If variable does not exist
    if(isVariable(variableName) == false)
    {
        strcpy(variableArray[numberOfVariables], variableName);
        variableSizes[numberOfVariables] = variableSize;
        numberOfVariables++;
    }
    else
    {
        fprintf(stderr, "Warning [Line %d]: Variable %s is already initialised.\n", yylineno, variableName); 
    }
}

// Check if variable is already initialised
void checkVariable(char *variable)
{
    trimVariable(variable);
    if (isVariable(variable) == false) 
    {
        fprintf(stderr, "Warning [Line %d]: Variable %s is not initialised.\n", yylineno, variable);
    }
}

// Check variable is declared
bool isVariable(char *variable)
{
    if (strstr(variable, ";") != NULL) 
    {
        getFirstVariable(variable);
    }

    for (int i = 0; i < numberOfVariables; i++) 
    {
        if (strcmp(variable, variableArray[i]) == 0) 
        {
            return true;
        }
    }
    return false;
}

// Gets variable size from table array
int getVariableSizeFromArray(char *variable) 
{
    for (int i = 0; i < numberOfVariables; i++) 
    {
        if (strcmp(variable, variableArray[i]) == 0) 
        {
            return variableSizes[i];
        }
    }
    return -1;
}

// Gets first variable from statement using ; delimiter.
void getFirstVariable(char *variable) 
{
    for (int i = 0; i < strlen(variable); i++) 
    {
        if (variable[i] == ';' || variable[i] == ' ') 
        {
            variable[i] = '\0';
            break;
        }
    }
}

// Assigns an integer to variable
void moveIntegerToVariable(int integer, char *variable)
{
    trimVariable(variable);
    int size = getVariableSizeFromArray(variable);

    if (size > -1) 
    {
        int inputDigits = getNumberOfDigitsInInteger(integer);

        if (inputDigits > size) 
        {
           fprintf(stderr, "Warning [Line %d]: Integer is too large. Expected %d digits or less, is %d.\n", yylineno, size, inputDigits);
        }
    } 
    else 
    {
       fprintf(stderr, "Warning [Line %d]: Variable %s is not initialised. Integer cannot be assigned.\n", yylineno, variable);
    }
}

// Assigns a variable to a variable
void moveVariableToVariable(char *variableOne, char *variableTwo)
{
    getFirstVariable(variableOne);
    trimVariable(variableTwo);

    if (isVariable(variableOne)) 
    {
        if (isVariable(variableTwo)) 
        {
            int size1 = getVariableSizeFromArray(variableOne);
            int size2 = getVariableSizeFromArray(variableTwo);

            if (size2 < size1) 
            {
               fprintf(stderr, "Warning [Line %d]: Integer overflow while moving %s (%d digits) to %s (%d digits).\n", yylineno, variableOne, size1, variableTwo, size2);
            }
        } 
        else 
        {
           fprintf(stderr, "Warning (Line %d): Variable %s is not initialised.\n", yylineno, variableTwo);
        }
    } 
    else 
    {
       fprintf(stderr, "Warning (Line %d): Variable %s is not initialised.\n", yylineno, variableOne);
    }
}

// Get number of digits of integer.
int getNumberOfDigitsInInteger(int integer)
{
    int i=0;
    for(i=0; integer!=0; i++)  
    {  
        integer=integer/10;   
    } 
    return i;  
}
