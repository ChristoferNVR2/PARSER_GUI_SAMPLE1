%{
#include <cstdio>
#include <iostream>

extern int yylex();
extern int yylineno;
extern char* yytext;
void yyerror(const char* s);
%}

%token INTEGER FLOAT ID ASSIGN PLUS MINUS TIMES DIVIDE LPAREN RPAREN SEMICOLON OTHER
%token INT FLOAT_TYPE IF ELSE WHILE FOR RETURN VOID
%token LBRACE RBRACE COMMA INCREMENT DECREMENT LT GT

%type <str> ID
%type <num> INTEGER
%type <num> FLOAT

%union {
    int num;
    char* str;
}

%%

program:
    | program statement
    ;

statement:
    declaration SEMICOLON
    | assignment SEMICOLON
    | control_statement
    | function_definition
    | compound_statement
    ;

declaration:
    type ID
    | type ID ASSIGN expr
    ;

type:
    INT
    | FLOAT_TYPE
    | VOID
    ;

assignment:
    ID ASSIGN expr
    | ID INCREMENT
    | ID DECREMENT
    ;

expr:
    expr PLUS term
    | expr MINUS term
    | expr LT term
    | expr GT term
    | term
    ;

term:
    term TIMES factor
    | term DIVIDE factor
    | factor
    ;

factor:
    INTEGER
    | FLOAT
    | ID
    | LPAREN expr RPAREN
    ;

control_statement:
    if_statement
    | while_statement
    | for_statement
    | return_statement
    ;

if_statement:
    IF LPAREN expr RPAREN statement
    | IF LPAREN expr RPAREN statement ELSE statement
    ;

while_statement:
    WHILE LPAREN expr RPAREN statement
    ;

for_statement:
    FOR LPAREN declaration SEMICOLON expr SEMICOLON assignment RPAREN compound_statement
    | FOR LPAREN assignment SEMICOLON expr SEMICOLON assignment RPAREN compound_statement
    ;
return_statement:
    RETURN expr SEMICOLON
    ;

function_definition:
    type ID LPAREN parameter_list RPAREN compound_statement
    ;

parameter_list:
    | parameter_list COMMA parameter
    | parameter
    ;

parameter:
    type ID
    ;

compound_statement:
    LBRACE statement_list RBRACE
    ;

statement_list:
    | statement_list statement
    ;

%%

void yyerror(const char *s) {
    std::cerr << "Error: " << s << " > near '" << yytext << "' at line " << yylineno << std::endl;
}