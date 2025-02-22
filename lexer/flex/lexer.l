%{
#include <iostream>
#include "Token.h"
#include "TokenConstant.h"

extern int yylineno;

using namespace std;

#define YY_DECL Token* yylex()  // Tell Flex that yylex() returns a Token*
%}

%option noyywrap

INT        [0-9]+
FLOAT      [0-9]+\.[0-9]+
ID         [a-zA-Z_][a-zA-Z0-9_]*
STRING     \"(\\.|[^\"])*\"
CHAR       \'(\\.|[^'])\'
COMMENT1   "//".*
COMMENT2   "/\*".*?"\*/"
WS         [ \t\r]+

%%

"int"          { return new Token(TokenConstant::TOKEN_INT, yytext); }
"float"        { return new Token(TokenConstant::TOKEN_FLOAT, yytext); }
"double"       { return new Token(TokenConstant::TOKEN_DOUBLE, yytext); }
"char"         { return new Token(TokenConstant::TOKEN_CHAR, yytext); }
"bool"         { return new Token(TokenConstant::TOKEN_BOOL, yytext); }
"true"         { return new Token(TokenConstant::TOKEN_TRUE, yytext); }
"false"        { return new Token(TokenConstant::TOKEN_FALSE, yytext); }
"void"         { return new Token(TokenConstant::TOKEN_VOID, yytext); }
"string"       { return new Token(TokenConstant::TOKEN_STRING, yytext); }
"if"           { return new Token(TokenConstant::TOKEN_IF, yytext); }
"else"         { return new Token(TokenConstant::TOKEN_ELSE, yytext); }
"for"          { return new Token(TokenConstant::TOKEN_FOR, yytext); }
"while"        { return new Token(TokenConstant::TOKEN_WHILE, yytext); }
"do"           { return new Token(TokenConstant::TOKEN_DO, yytext); }
"return"       { return new Token(TokenConstant::TOKEN_RETURN, yytext); }
"class"        { return new Token(TokenConstant::TOKEN_CLASS, yytext); }
"struct"       { return new Token(TokenConstant::TOKEN_STRUCT, yytext); }
"public"       { return new Token(TokenConstant::TOKEN_PUBLIC, yytext); }
"private"      { return new Token(TokenConstant::TOKEN_PRIVATE, yytext); }
"protected"    { return new Token(TokenConstant::TOKEN_PROTECTED, yytext); }
"namespace"    { return new Token(TokenConstant::TOKEN_NAMESPACE, yytext); }
"using"        { return new Token(TokenConstant::TOKEN_USING, yytext); }
"include"      { return new Token(TokenConstant::TOKEN_INCLUDE, yytext); }
"new"          { return new Token(TokenConstant::TOKEN_NEW, yytext); }
"delete"       { return new Token(TokenConstant::TOKEN_DELETE, yytext); }
"switch"       { return new Token(TokenConstant::TOKEN_SWITCH, yytext); }
"case"         { return new Token(TokenConstant::TOKEN_CASE, yytext); }
"break"        { return new Token(TokenConstant::TOKEN_BREAK, yytext); }
"continue"     { return new Token(TokenConstant::TOKEN_CONTINUE, yytext); }
"sizeof"       { return new Token(TokenConstant::TOKEN_SIZEOF, yytext); }
"typedef"      { return new Token(TokenConstant::TOKEN_TYPEDEF, yytext); }
"static"       { return new Token(TokenConstant::TOKEN_STATIC, yytext); }
"const"        { return new Token(TokenConstant::TOKEN_CONST, yytext); }
"cout"         { return new Token(TokenConstant::TOKEN_COUT, yytext); }
"cin"          { return new Token(TokenConstant::TOKEN_CIN, yytext); }
"cerr"         { return new Token(TokenConstant::TOKEN_CERR, yytext); }
"endl"         { return new Token(TokenConstant::TOKEN_ENDL, yytext); }
"try"          { return new Token(TokenConstant::TOKEN_TRY, yytext); }
"catch"        { return new Token(TokenConstant::TOKEN_CATCH, yytext); }
"throw"        { return new Token(TokenConstant::TOKEN_THROW, yytext); }
"template"     { return new Token(TokenConstant::TOKEN_TEMPLATE, yytext); }
"typename"     { return new Token(TokenConstant::TOKEN_TYPENAME, yytext); }
"operator"     { return new Token(TokenConstant::TOKEN_OPERATOR, yytext); }
"friend"       { return new Token(TokenConstant::TOKEN_FRIEND, yytext); }
"this"         { return new Token(TokenConstant::TOKEN_THIS, yytext); }
"virtual"      { return new Token(TokenConstant::TOKEN_VIRTUAL, yytext); }
"override"     { return new Token(TokenConstant::TOKEN_OVERRIDE, yytext); }
"final"        { return new Token(TokenConstant::TOKEN_FINAL, yytext); }
"nullptr"      { return new Token(TokenConstant::TOKEN_NULLPTR, yytext); }
"enum"         { return new Token(TokenConstant::TOKEN_ENUM, yytext); }
"union"        { return new Token(TokenConstant::TOKEN_UNION, yytext); }
"extern"       { return new Token(TokenConstant::TOKEN_EXTERN, yytext); }
"inline"       { return new Token(TokenConstant::TOKEN_INLINE, yytext); }
"constexpr"    { return new Token(TokenConstant::TOKEN_CONSTEXPR, yytext); }
"decltype"     { return new Token(TokenConstant::TOKEN_DECLTYPE, yytext); }
"static_cast"  { return new Token(TokenConstant::TOKEN_STATIC_CAST, yytext); }
"dynamic_cast" { return new Token(TokenConstant::TOKEN_DYNAMIC_CAST, yytext); }
"const_cast"   { return new Token(TokenConstant::TOKEN_CONST_CAST, yytext); }
"reinterpret_cast" { return new Token(TokenConstant::TOKEN_REINTERPRET_CAST, yytext); }

"="            { return new Token(TokenConstant::TOKEN_ASSIGN, yytext); }
"+"            { return new Token(TokenConstant::TOKEN_PLUS, yytext); }
"-"            { return new Token(TokenConstant::TOKEN_MINUS, yytext); }
"*"            { return new Token(TokenConstant::TOKEN_MULTIPLY, yytext); }
"/"            { return new Token(TokenConstant::TOKEN_DIVIDE, yytext); }
"%"            { return new Token(TokenConstant::TOKEN_MODULO, yytext); }
"=="           { return new Token(TokenConstant::TOKEN_EQUAL, yytext); }
"!="           { return new Token(TokenConstant::TOKEN_NOT_EQUAL, yytext); }
"<"            { return new Token(TokenConstant::TOKEN_LESS, yytext); }
">"            { return new Token(TokenConstant::TOKEN_GREATER, yytext); }
"<="           { return new Token(TokenConstant::TOKEN_LESS_EQUAL, yytext); }
">="           { return new Token(TokenConstant::TOKEN_GREATER_EQUAL, yytext); }
"&&"           { return new Token(TokenConstant::TOKEN_AND, yytext); }
"||"           { return new Token(TokenConstant::TOKEN_OR, yytext); }
"!"            { return new Token(TokenConstant::TOKEN_NOT, yytext); }
"++"           { return new Token(TokenConstant::TOKEN_INCREMENT, yytext); }
"--"           { return new Token(TokenConstant::TOKEN_DECREMENT, yytext); }
"<<"           { return new Token(TokenConstant::TOKEN_LEFT_SHIFT, yytext); }
">>"           { return new Token(TokenConstant::TOKEN_RIGHT_SHIFT, yytext); }
"->"           { return new Token(TokenConstant::TOKEN_ARROW, yytext); }
".*"           { return new Token(TokenConstant::TOKEN_DOT_STAR, yytext); }
"->*"          { return new Token(TokenConstant::TOKEN_ARROW_STAR, yytext); }
"::"           { return new Token(TokenConstant::TOKEN_SCOPE, yytext); }
"..."          { return new Token(TokenConstant::TOKEN_ELLIPSIS, yytext); }
"#"            { return new Token(TokenConstant::TOKEN_HASH, yytext); }
"&"            { return new Token(TokenConstant::TOKEN_AMPERSAND, yytext); }
"|"            { return new Token(TokenConstant::TOKEN_PIPE, yytext); }

";"            { return new Token(TokenConstant::TOKEN_SEMICOLON, yytext); }
":"            { return new Token(TokenConstant::TOKEN_COLON, yytext); }
","            { return new Token(TokenConstant::TOKEN_COMMA, yytext); }
"."            { return new Token(TokenConstant::TOKEN_DOT, yytext); }
"{"            { return new Token(TokenConstant::TOKEN_LBRACE, yytext); }
"}"            { return new Token(TokenConstant::TOKEN_RBRACE, yytext); }
"("            { return new Token(TokenConstant::TOKEN_LPAREN, yytext); }
")"            { return new Token(TokenConstant::TOKEN_RPAREN, yytext); }
"["            { return new Token(TokenConstant::TOKEN_LBRACKET, yytext); }
"]"            { return new Token(TokenConstant::TOKEN_RBRACKET, yytext); }

{FLOAT}        { return new Token(TokenConstant::TOKEN_FLOAT_LITERAL, yytext); }
{INT}          { return new Token(TokenConstant::TOKEN_INT_LITERAL, yytext); }
{STRING}       { return new Token(TokenConstant::TOKEN_STRING_LITERAL, yytext); }
{CHAR}         { return new Token(TokenConstant::TOKEN_CHAR_LITERAL, yytext); }

{ID}           { return new Token(TokenConstant::TOKEN_IDENTIFIER, yytext); }

{COMMENT1}     { return new Token(TokenConstant::TOKEN_COMMENT_SINGLE_LINE, yytext); }
{COMMENT2}     { return new Token(TokenConstant::TOKEN_COMMENT_MULTI_LINE, yytext); }

\n             { yylineno++; }

{WS}           { /* Ignore */ }

.              { yyerror("Unknown Token", yytext); return new Token(TokenConstant::UNKNOWN, yytext); }

%%