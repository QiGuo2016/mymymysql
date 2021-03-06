%{
#include "Exception/Exception.hpp"
#include <vector>
#include <string>
#include "Parser.h"
#include "ParserDef.h"
std::vector<char> sb;
Lex curLex;

#define BuildOpX(X, str) do {curLex.type = X; curLex.raw = str; return 1;} while(0)
#define BuildLex(X) do {\
BuildOpX(X, new std::string(yytext));\
}while(0)
#define BuildOp(X) do {\
BuildOpX(X, nullptr);\
}while(0)
#define BuildStr(X) do {\
BuildOpX(X, new std::string(sb.begin(), sb.end()));\
}while(0)
%}

DIGIT                ([0-9])
INTEGER              ({DIGIT}+)
IDENTIFIER           ([_A-Za-z][_0-9A-Za-z]*)
WHITESPACE           ([ \t\n\r]+)

%option outfile="Lexer.cpp" HEADER-FILE="Lexer.h"
%option c++
%x S
%x S2

%%
{WHITESPACE}                    {}

"+"                             {BuildOp(PLUS);}
"-"                             {BuildOp(MINUS);}
"*"                             {BuildOp(STAR);}
","                             {BuildOp(COMMA);}
">"                             {BuildOp(GT);}
"<"                             {BuildOp(LT);}
">="                            {BuildOp(GE);}
"<="                            {BuildOp(LE);}
"="                             {BuildOp(EQ);}
"<>"                            {BuildOp(NE);}
"("                             {BuildOp(LLC);}
")"                             {BuildOp(RLC);}
"."                             {BuildOp(DOT);}
(?i:not)                        {BuildOp(NOT);}
(?i:and)                        {BuildOp(AND);}
(?i:or)                         {BuildOp(OR);}
(?i:select)                     {BuildOp(SELECT);}
(?i:from)                       {BuildOp(FROM);}
(?i:where)                      {BuildOp(WHERE);}
(?i:sum)                        {BuildOp(SUM);}
(?i:avg)                        {BuildOp(AVG);}
(?i:min)                        {BuildOp(MIN);}
(?i:max)                        {BuildOp(MAX);}
(?i:group)                      {BuildOp(GROUP);}
(?i:by)                         {BuildOp(BY);}
(?i:insert)                     {BuildOp(INSERT);}
(?i:into)                       {BuildOp(INTO);}
(?i:values)                     {BuildOp(VALUES);}
(?i:update)                     {BuildOp(UPDATE);}
(?i:set)                        {BuildOp(SET);}
(?i:delete)                     {BuildOp(DELETE);}
(?i:null)                       {BuildOp(NULL_);}
(?i:int)                        {BuildOp(INT);}
(?i:varchar)                    {BuildOp(VARCHAR);}
(?i:create)                     {BuildOp(CREATE);}
(?i:table)                      {BuildOp(TABLE);}
(?i:primary)                    {BuildOp(PRIMARY);}
(?i:key)                        {BuildOp(KEY);}
(?i:drop)                       {BuildOp(DROP);}
(?i:show)                       {BuildOp(SHOW);}
(?i:tables)                     {BuildOp(TABLES);}
(?i:database)                   {BuildOp(DATABASE);}
(?i:use)                        {BuildOp(USE);}
(?i:foreign)                    {BuildOp(FOREIGN);}
(?i:references)                 {BuildOp(REFERENCES);}
(?i:desc)                       {BuildOp(DESC);}
(?i:is)                         {BuildOp(IS);}
(?i:like)                       {BuildOp(LIKE);}

{INTEGER}                       {BuildLex(INTEGER);}

<INITIAL>\"                     {BEGIN S; sb.clear();}
<S><<EOF>>                      {throw "Syntax Error";}
<S>\"                           {BEGIN INITIAL; BuildStr(STRING);}
<S>"\\n"                        {sb.push_back('\n');}
<S>"\\t"                        {sb.push_back('\t');}
<S>"\\\""                       {sb.push_back('\"');}
<S>"\\\\"                       {sb.push_back('\\');}
<S>.                            {sb.push_back(YYText()[0]);}

<INITIAL>'                       {BEGIN S2; sb.clear();}
<S2><<EOF>>                      {throw "Syntax Error";}
<S2>'                            {BEGIN INITIAL; BuildStr(STRING);}
<S2>"\\n"                        {sb.push_back('\n');}
<S2>"\\t"                        {sb.push_back('\t');}
<S2>"\\'"                        {sb.push_back('\'');}
<S2>"\\\\"                       {sb.push_back('\\');}
<S2>.                            {sb.push_back(YYText()[0]);}

{IDENTIFIER}                     {BuildLex(IDENTIFIER);}

<<EOF>>                          {return 0;}
.                                {throw "Syntax Error";}
%%

int yyFlexLexer::yywrap() { return 1; }
