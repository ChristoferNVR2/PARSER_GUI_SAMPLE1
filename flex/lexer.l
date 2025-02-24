%{
#include <iostream>
#include <cstdio>
#include <string.h>
#include "parser.hpp"

void showError(const char* s);
%}

%option noyywrap

digit   [0-9]
letter  [a-zA-Z]
id      {letter}({letter}|{digit})*
int     {digit}+
float   {digit}+"."{digit}+
whitespace [ \t\r]

%%

"int"       { return INT; }
"float"     { return FLOAT_TYPE; }
"void"      { return VOID; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }
"return"    { return RETURN; }

"++"        { return INCREMENT; }
"--"        { return DECREMENT; }
"<"         { return LT; }
">"         { return GT; }

{int}       { yylval.num = atoi(yytext); return INTEGER; }
{float}     { yylval.num = atof(yytext); return FLOAT; }
{id}        { yylval.str = strdup(yytext); return ID; }
"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return TIMES; }
"/"         { return DIVIDE; }
"("         { return LPAREN; }
")"         { return RPAREN; }
";"         { return SEMICOLON; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
","         { return COMMA; }

{whitespace}+    ;  // Ignore whitespace

"\n"        { yylineno++; }

.           { showError("lexical error"); exit(1); }

%%

void showError(const char* s) {
    std::cerr << "Error: " << s << " > Invalid character '" << yytext << "' at line " << yylineno << std::endl;
}