%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
extern int yylex();
extern int yyparse();
extern int yylineno;
extern FILE *yyin;

void yyerror(char* s);
void check_unique_identifier(char* chars, int identifierSize);
void check_does_exist(char* chars);
void moveIntegerTo(int integer, char* chars);
void moveIdentifierTo(char* chars, char* chars2);

char identifiers[1000][255];
int identifiersSizes[1000];
int identifierIteration = 0;

%}
%union {char* chars; int integer;}
%token BEGINNING BODY END PRINT MOVE INPUT ADD TO
%token DELIMITER EOL STRING
%token <integer> IDENTIFIERSIZE INTEGER
%token <chars>  IDENTIFIER 

%%
sentence: beginning declarations body statements end {printf("Is a valid program!\n");}
beginning: BEGINNING EOL
declarations: declaration | declaration declarations 
declaration : IDENTIFIERSIZE IDENTIFIER EOL {check_unique_identifier($2, $1);}
body: BODY EOL
statements: statement | statement statements
statement: print | input | move | add
print: PRINT string
string: STRING EOL | IDENTIFIER EOL {check_does_exist($1);} | STRING DELIMITER string | IDENTIFIER DELIMITER string {check_does_exist($1);}
input: INPUT identifierList EOL
identifierList: identifier | identifier identifierList
identifier: IDENTIFIER DELIMITER {check_does_exist($1);} | IDENTIFIER {check_does_exist($1);}
move: MOVE moveTo EOL
moveTo: INTEGER TO IDENTIFIER {moveIntegerTo($1, $3);} | IDENTIFIER TO IDENTIFIER {moveIdentifierTo($1, $3);}
add: ADD addTo EOL
addTo: INTEGER TO IDENTIFIER {moveIntegerTo($1, $3);} | IDENTIFIER TO IDENTIFIER {moveIdentifierTo($1, $3);}
end: END EOL
%%


int main()
{
	do	yyparse();
		while(!feof(yyin));
	return 0;
}

void yyerror(char *s)
{
	fprintf(stderr, "%s , on line number %d\n", s, yylineno);
	exit(0);
}


void check_unique_identifier(char* chars, int identifierSize) {
	int len = sizeof(identifiers)/sizeof(identifiers[0]);
	if (chars[strlen(chars)-1] == '.') chars[strlen(chars)-1] = 0;
	int doesExist = 1;

	for(int i = 0; i < len; ++i)
	{
		if(strcmp(identifiers[i], chars) == 0)
		{
			yyerror("Identifier already exists");
			exit(0);
		}
		else {
			doesExist = 0;
		}
	}

	if(doesExist == 0)
	{
		strcpy(identifiers[identifierIteration], chars);
		identifiersSizes[identifierIteration] = identifierSize;
		identifierIteration++;
		return;
	}

}

void check_does_exist(char* chars) {
	int len = sizeof(identifiers)/sizeof(identifiers[0]);

	for(int i = 0; i < strlen(chars); i++) {
		char c = chars[i];
		if(c == '.' || c == ';' || c ==' ') {
			chars[i] = 0;
		}
	} 

	for(int i = 0; i < len; ++i)
	{
		if(strcmp(identifiers[i], chars) == 0)
		{
			return;
			
		}
	}
	yyerror("Identifier doesn't exist");
	exit(0);
}


void moveIntegerTo(int integer, char* chars) {
	check_does_exist(chars);
	int len = sizeof(identifiers)/sizeof(identifiers[0]);
	for(int i = 0; i < len; ++i)
	{
		if(strcmp(identifiers[i], chars) == 0)
		{
			int identifierSize = identifiersSizes[i];
			int count=(integer==0)?1:log10(integer)+1;
			if (count <= identifierSize) {
				return;
			}
			else {
				yyerror("Integer doesn't fit in Identifier");
				exit(0);
			}
		}
	}
}

void moveIdentifierTo(char* chars, char* chars2) {
	check_does_exist(chars);
	check_does_exist(chars2);

	int len = sizeof(identifiers)/sizeof(identifiers[0]);
	int charsSize = 0;
	int chars2Size = 0;
	for(int i = 0; i < len; ++i)
	{
		if(strcmp(identifiers[i], chars) == 0)
		{
			charsSize = identifiersSizes[i];
		}
		if(strcmp(identifiers[i], chars2) == 0)
		{
			chars2Size = identifiersSizes[i];
		}
	}
	if (charsSize <= chars2Size) {
		return;
	}
	yyerror("Identifier doesn't fit in Identifier");
	exit(0);
}