//
// Created by chrisvega on 2/5/25.
//

#include <iostream>
#include "Token.h"

extern int yylineno;

void yyerror(const char *s, const char *token) {
    std::cerr << "Error at line " << yylineno << ": " << s << " (" << token << ")" << std::endl;
}