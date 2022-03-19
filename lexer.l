%{
	// C code here
	#include <stdlib.h>
	#include <string.h>
	#include "parser.tab.h"
%}

%option noyywrap
%option caseless
%option yylineno

/* Tokens */
%%
[\t\n]+ ;		        //Ignore spaces and newline
BEGINING                { return BEGINING; }	        
BODY                    { return BODY; }          
END                     { return END; }          
MOVE                    { return MOVE; }         
ADD                     { return ADD; }  
TO	                    { return TO; }      
INPUT                   { return INPUT; }      
PRINT     		        { return PRINT; }
\.                      { return TERMINATOR; }
\"(\\.|[^"\\])*\"       { return STRING; } 
;                       { return SEMICOLON; }
.                       { return 0; }     
[Xx]+                   { yylval.size=strlen(yytext); return INT_SIZE; }
[A-Za-z][A-Za-z0-9\-]*  { yylval.id = yytext; return IDENTIFIER; }
(\-?|\+)[0-9]+          { yylval.number=atoi(yytext); return INTEGER; }
%%

int main(int argc, char **argv)
{
    yylex ();
}