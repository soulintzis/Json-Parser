%option noyywrap
%{ 
    //C libraries
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>

    #include "JsonBison.tab.h"  

    //Declare functions and variables that Flex and Bison that is going to be used later
    void yyerror(const char* msg); //this function take as input a string and return an error message at the point in which the error accures
    
    extern int yylex();
    extern int yyparse();

    //yyin is a variable responible to read the input file
    extern FILE *yyin;   

    int lineNumber = 1;
%}

ACCEPTABLE_CHARS [^"\\] 
ESCAPE_CHAR \\["\\\/bfnrtu]
CHAR {ESCAPE_CHAR}|{ACCEPTABLE_CHARS}
CHARS {CHAR}+
DOUBLE_QUOTE \"

%%
[-+]?[0-9]+ { /*Rule that recognize integers and reterns them to the bison parser*/
    yylval.ival = atoi(yytext);
    return INTEGER; 
}

[-+]?[0-9]*\.?[0-9]*([eE][-+]?[0-9]+)? { /*Rule that recognize floating point numbers and reterns them to the bison parser*/
    yylval.fval = atof(yytext); //converts stings to integes and returns them to parser
    return FLOAT; 
}

{DOUBLE_QUOTE}{DOUBLE_QUOTE}|{DOUBLE_QUOTE}{CHARS}{DOUBLE_QUOTE} {  //Recognizes the empty string or a string based on the grammar that we have made at the start of the program
    yylval.sval = strdup(yytext);
    return STRING;
}

{DOUBLE_QUOTE} { //recognize quote symbol
    return QUOTE;
}

":" { //recognize colon symbol
    return COLON;
}

"{" {
    return OBJECT_BEGIN;
}

"}" {
    return OBJECT_END;
}

\[ {
    return ARRAY_BEGIN;
}

\] {
    return ARRAY_END;
}

true {
    return TRUE_V;
}

false {
    return FALSE_V;
}

null {
    return NULL_V;
}

"," {
    return COMMA;
}

[ \t] {}

\n {
    lineNumber++; //we count the number of lines in order to tell in which line an error occurs
}

. return yytext[0];
%%