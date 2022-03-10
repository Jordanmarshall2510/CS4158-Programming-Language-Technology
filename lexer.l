/* Tokens */
%%
[\t ]+ ;		        //Ignore spaces
BEGINING                { printf("BEGINING\n"); }	        
BODY                    { printf("BODY\n"); }          
END                     { printf("END\n"); }          
MOVE                    { printf("MOVE\n"); }         
ADD                     { printf("ADD\n"); }  
TO	                    { printf("TO\n"); }      
INPUT                   { printf("INPUT\n"); }      
PRINT     		        { printf("PRINT\n"); }      
[Xx]+                   {  }
;                       {  }
\.                      {  }
[A-Za-z][A-Za-z0-9\-]*  {  }
\"(\\.|[^"\\])*\"       {  }
[0-9]+                  {  }
.                       {  }
%%

int main(int argc, char **argv)
{
    yylex();
}