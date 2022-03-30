This project was to parse the language instances of the JUBIC programming language using Flex and Bison.

To build the flex file we first must run flex lexer.l.
This will then generate a C file called lex.yy.c.
We then run bison -d bison.y
Then we compile it using gcc -c lex.yy.c bison.tab.c and gcc -o executable lex.yy.o bison.tab.o.
We can then run executable < hello.txt and this will then start the parser. This was carried out on windows using anaconda.
