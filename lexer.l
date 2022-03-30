%{
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include "bison.tab.h"
%}

/* For case insensitivity */
%option noyywrap
%option caseless
%option yylineno

/* Tokens */
%%
"BEGINNING" {return BEGINNING;}
"END" {return END;}
"BODY" {return BODY;}
"MOVE" {return MOVE;}
"TO" {return TO;}
"ADD" {return ADD;}
"INPUT" {return INPUT;}
"PRINT" {return PRINT;}
"." {return EOL;}
";" {return DELIMITER;}
[X]+ {yylval.integer = strlen(yytext); return IDENTIFIERSIZE;}
[\"][^\"]*[\"] {return STRING;}
[a-zA-Z][a-zA-Z0-9-]* {yylval.chars = yytext; return IDENTIFIER;}
[-+]?[0-9]+ {yylval.integer = atoi(yytext); return INTEGER;}
[\n\t ]+ /* Ignore */
. {exit(0);}
%%
