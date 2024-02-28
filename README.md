# mini_c
MiniC for compiler course

program := int main ( ) { declaration* statement* }
declaration := type identifier ([ integer ])? ;
type := int | bool | float | char
statement := assignment | if_statement | while_statement
assignment := identifier ([ expression ])? = expression ;
if_statement := if ( expression ) { statement* } else_statement?
else_statement := else { statement* }
while_statement := while ( expression ) { statement* }
expression := conjunction (|| conjunction )*
conjunction := equality (&& equality )*
equop := == | !=
equality := relation ( equop relation)?
relation := addition (relop addition)?
relop := < | <= | > | >=
addition := term ( addop term)*
addop := + | -
term := factor (mulop factor )*
mulop := * | / | %
factor := unaryop? primary
unaryop := - | !
primary := identifier ([ expression ]) ? | literal|parenth
parenth := ( expression )
