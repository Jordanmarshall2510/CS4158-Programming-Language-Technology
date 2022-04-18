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
[\t\n\r ]+ 				{} //Ignore spaces and newline
BEGINING                { return BEGINING; }	        
BODY                    { return BODY; }          
END                     { return END; }          
MOVE                    { return MOVE; }         
ADD                     { return ADD; }
INPUT                   { return INPUT; }  
PRINT     		        { return PRINT; } 
TO	                    { return TO; }         
;                       { return SEMICOLON; }
(\-?|\+)[0-9]+          { yylval.number=atoi(yytext); return INTEGER; }
[Xx]+                   { yylval.size=strlen(yytext); return INT_SIZE; }
\.                      { return TERMINATOR; }
[A-Za-z][A-Za-z0-9\-]*  { yylval.id = yytext; return IDENTIFIER; }
\"(\\.|[^"\\])*\"       { return STRING; } 
.                       { return 0; }     
%%