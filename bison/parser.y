%{
#include <cstdio>
#include <iostream>

extern int yylex();
extern int yylineno;
extern char* yytext;
void yyerror(const char* s);
%}

%token INTEGER FLOAT ID ASSIGN PLUS MINUS TIMES DIVIDE LPAREN RPAREN SEMICOLON OTHER

%type <str> ID
%type <num> INTEGER
%type <num> FLOAT


%union {
    int num;
    char* str;
}

%%

assignment: ID ASSIGN expr SEMICOLON
    | ID ASSIGN expr SEMICOLON assignment
    ;

expr: expr PLUS term
    | expr MINUS term
    | term
    ;

term: term TIMES factor
    | term DIVIDE factor
    | factor
    ;

factor: INTEGER
    | FLOAT
    | ID
    | LPAREN expr RPAREN
    ;

%%

void yyerror(const char *s) {
    std::cerr << "Error: " << s << " > near '" << yytext << "' at line " << yylineno << std::endl;
}
