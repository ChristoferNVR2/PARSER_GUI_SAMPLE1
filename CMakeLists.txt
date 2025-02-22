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

set(FLEX_NEW_DIR ${LEXER_DIR}/flex)
set(SRC_NEW_DIR ${LEXER_DIR}/src)

file(MAKE_DIRECTORY ${GEN_DIR})

include_directories(${CMAKE_SOURCE_DIR}/src ${LEXER_DIR}/src)

BISON_TARGET(MyParser ${BISON_DIR}/parser.y ${GEN_DIR}/parser.cpp
        COMPILE_FLAGS "--defines=${GEN_DIR}/parser.hpp")
FLEX_TARGET(MyLexer ${FLEX_DIR}/lexer.l ${GEN_DIR}/lexer.cpp)
FLEX_TARGET(MyNewLexer ${FLEX_NEW_DIR}/lexer.l ${GEN_DIR}/newLexer.cpp)

ADD_FLEX_BISON_DEPENDENCY(MyLexer MyParser)

add_executable(PARSER_GUI_SAMPLE1 ${SRC_DIR}/main.cpp
        ${GEN_DIR}/parser.cpp
        ${GEN_DIR}/lexer.cpp
        ${GEN_DIR}/newLexer.cpp
        ${SRC_NEW_DIR}/errorHandler.cpp
        ${SRC_NEW_DIR}/TokenConstant.h
        ${SRC_NEW_DIR}/Token.cpp
        ${SRC_NEW_DIR}/Token.h
        ${SRC_NEW_DIR}/TokenConstant.cpp)

include_directories(${GEN_DIR})

target_include_directories(PARSER_GUI_SAMPLE1 PRIVATE ${GEN_DIR})