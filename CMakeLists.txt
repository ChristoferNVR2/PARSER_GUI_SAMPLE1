cmake_minimum_required(VERSION 3.30)
project(PARSER_GUI_SAMPLE1)

set(CMAKE_CXX_STANDARD 20)

find_package(FLEX REQUIRED)
find_package(BISON REQUIRED)

set(SRC_DIR ${CMAKE_SOURCE_DIR}/src)
set(BISON_DIR ${CMAKE_SOURCE_DIR}/bison)
set(FLEX_DIR ${CMAKE_SOURCE_DIR}/flex)
set(GEN_DIR ${CMAKE_BINARY_DIR}/generated)

set(LEXER_DIR ${CMAKE_SOURCE_DIR}/lexer)

set(SRC_NEW_DIR ${LEXER_DIR}/src)
set(FLEX_NEW_DIR ${LEXER_DIR}/flex)
set(GEN_NEW_DIR ${CMAKE_BINARY_DIR}/lexGenerated)

file(MAKE_DIRECTORY ${GEN_DIR})

include_directories(${CMAKE_SOURCE_DIR}/src ${LEXER_DIR}/src)

BISON_TARGET(MyParser ${BISON_DIR}/parser.y ${GEN_DIR}/parser.cpp
        COMPILE_FLAGS "--defines=${GEN_DIR}/parser.hpp")
FLEX_TARGET(MyLexer ${FLEX_DIR}/lexer.l ${GEN_DIR}/lexer.cpp)

FLEX_TARGET(MyNewLexer ${FLEX_NEW_DIR}/lexer.l ${GEN_NEW_DIR}/newLexer.cpp)

ADD_FLEX_BISON_DEPENDENCY(MyLexer MyParser)

add_executable(PARSER_GUI_SAMPLE1 ${SRC_DIR}/main.cpp
        ${GEN_DIR}/parser.cpp
        ${GEN_DIR}/lexer.cpp)

add_executable(LEXER ${LEXER_DIR}/src/main.cpp
        ${GEN_NEW_DIR}/newLexer.cpp
        ${LEXER_DIR}/src/errorHandler.cpp
        ${LEXER_DIR}/src/TokenConstant.h
        ${LEXER_DIR}/src/Token.cpp
        ${LEXER_DIR}/src/Token.h
        ${LEXER_DIR}/src/TokenConstant.cpp)

include_directories(${GEN_DIR} ${GEN_NEW_DIR})

target_include_directories(PARSER_GUI_SAMPLE1 PRIVATE ${GEN_DIR} ${GEN_NEW_DIR})