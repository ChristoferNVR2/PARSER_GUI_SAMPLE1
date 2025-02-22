//
// Created by chrisvega on 2/6/25.
//

#ifndef TOKEN_H
#define TOKEN_H
#include <string>
#include "TokenConstant.h"

extern int yylineno;
void yyerror(const char *s, const char *token);

class Token {
public:
    Token(TokenConstant tokenType, std::string  lexeme);
    [[nodiscard]] TokenConstant getTokenType() const;
    void setTokenType(TokenConstant tokenType);
    [[nodiscard]] std::string getLexeme() const;
    void setLexeme(const std::string& lexeme);
    [[nodiscard]] std::string toString() const;

private:
    TokenConstant tokenType;
    std::string lexeme;
};

Token* yylex();


#endif //TOKEN_H
