%{ 
    //C libraries
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include <malloc.h> 

    //Declare functions and variables that Flex and Bison need to know
    void yyerror(const char* msg); //this function takes as input a string and prints an error message
    extern int yylex();
    extern int yyparse();


    //yyin is a variable responible to read the input file
    extern FILE *yyin; 
%}

%union {
    long long ival;
    double fval;
    char *sval;
}

//Define the tokens that are going to be used:
%token OBJECT_BEGIN 
%token OBJECT_END
%token ARRAY_BEGIN 
%token ARRAY_END
%token TRUE_V 
%token FALSE_V
%token NULL_V
%token COMMA 
%token COLON
%token QUOTE
%token INTEGER 
%token FLOAT
%token STRING

//Define the type of the above tokens
%type <ival> INTEGER
%type <fval> FLOAT
%type <sval> STRING

//Indicate the initial rule:
%start init

%%
init: object | array;

object: OBJECT_BEGIN OBJECT_END
| OBJECT_BEGIN content OBJECT_END
;

array: ARRAY_BEGIN ARRAY_END 
| ARRAY_BEGIN items ARRAY_END 
;

content: pair 
| pair COMMA content
;

pair:  value 
| STRING COLON value
;

items: value 
| value COMMA items
;

value: STRING
| INTEGER  
| FLOAT 
| object 
| array 
| TRUE_V 
| FALSE_V 
| NULL_V 
;

%%
int main(int argc, char *argv[]){  

    yyin = fopen(argv[1], "r");

    //The program will exit if it can't open the file 
     if (yyin == NULL) {
        printf("Error opening file!\n");
        exit(1);
	}
    
    // Parse through the input:
    yyparse();
  
    //Closing the files that we open earlier
    fclose(yyin);  
    printf("Your Json file has been passed succesfully\n");
    return 0;
}

//Function that print the error messege whenever it occurs while the program is running
//The program  exit if an error occurs
extern int lineNumber;
void yyerror(const char *msg) {
    printf(" [line %d]: %s\n", lineNumber, msg);
	exit(1); 
}