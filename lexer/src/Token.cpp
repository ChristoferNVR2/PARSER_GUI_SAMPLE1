//
// Created by chrisvega on 2/6/25.
//

#include "Token.h"

#include <utility>
#include <iomanip>
#include <sstream>

Token::Token(const TokenConstant tokenType, std::string  lexeme)
    : tokenType(tokenType), lexeme(std::move(lexeme)) {}

TokenConstant Token::getTokenType() const {
    return tokenType;
}

void Token::setTokenType(const TokenConstant tokenType) {
    this->tokenType = tokenType;
}

std::string Token::getLexeme() const {
    return lexeme;
}

void Token::setLexeme(const std::string& lexeme) {
    this->lexeme = lexeme;
}

// std::string Token::toString() const {
//     return "Token{tokenType=" + std::to_string(static_cast<int>(tokenType)) + ", lexeme='" + lexeme + "'}";
// }

std::string Token::toString() const {
    std::ostringstream oss;
    oss << "Token{index=" << std::left << std::setw(2) << static_cast<int>(tokenType)
        << ", name=" << std::left << std::setw(26) << TokenConstantToString(tokenType)
        << ", lexeme='" << lexeme << "'}";
    return oss.str();
}