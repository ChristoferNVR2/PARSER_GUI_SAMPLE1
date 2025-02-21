#include <iostream>
#include <fstream>
#include <cstdlib>

// External functions from Flex & Bison
extern int yyparse();
extern FILE* yyin;

int main(int argc, char* argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            std::cerr << "Error: Could not open file " << argv[1] << std::endl;
            return 1;
        }
        std::cout << "Reading from file: " << argv[1] << std::endl;
    } else {
        std::cout << "Enter C++ code (Ctrl+D to end input):\n";
        yyin = stdin;
    }

    int parseResult = yyparse();

    if (yyin != stdin) {
        fclose(yyin);
    }

    if (parseResult == 0) {
        std::cout << "File is OK" << std::endl;
    } else {
        std::cout << "File has errors" << std::endl;
    }

    return parseResult;
}
