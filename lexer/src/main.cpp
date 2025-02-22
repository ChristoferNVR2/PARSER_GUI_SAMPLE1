#include <iostream>
#include <fstream>

#include "Token.h"
#include "TokenConstant.h"

using namespace std;

extern FILE* yyin;          // Flex uses this file pointer as input
extern int yylineno;        // Ensure yylineno is declared


int main(const int argc, char *argv[]) {
    yylineno = 1; // Initialize line number

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            cerr << "Error: Could not open file " << argv[1] << endl;
            return 1;
        }
        cout << "Reading from file: " << argv[1] << endl;
    } else {
        cout << "Enter C++ code (Ctrl+D to end input):\n";
        yyin = stdin;
    }

    const Token* token = yylex();
    while (token->getTokenType() != TokenConstant::TOKEN_EOF) {
        cout << token->toString() << endl;
        token = yylex();
    }

    if (yyin != stdin) {
        fclose(yyin);
    }

    return 0;
}
