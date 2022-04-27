%{
	#include <stdlib.h>
	#include <string.h>
	#include "parser.tab.h"
%}

/* Read only one input file */ 
%option noyywrap

/* Case will be ignored*/
%option caseless

/* Gets line number*/
%option yylineno

/* Tokens */
%%
[\t\n\r ]+ 				{}
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
[A-Za-z][A-Za-z0-9\-]*  { yylval.identifier = yytext; return IDENTIFIER; }
\"(\\.|[^"\\])*\"       { return STRING; } 
.                       { return 0; }     
%%