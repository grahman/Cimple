(* XOR EQUALS NOTEQUALS LESS_THAN GREATER_THAN LESS_EQUAL
 GREATER_EQUAL LSHIFT RSHIFT MODULO AND NEGATE NOT DOT DEREFERENCE INCREMENT DECREMENT *)

{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf }
| "++" { INCREMENT }
| "--" { DECREMENT }
| '.' { DOT }
| "->" { DEREFERENCE }
| '!' { LOGICAL_NOT }
| '~' { BITWISE_NOT }
| '+' { PLUS }
| '-' { MINUS }
| '%' { MODULUS }
| '*' { TIMES }
| '/' { DIVIDE }
| "<<" { LSHIFT }
| ">>" { RSHIFT }
| '<' { LESS_THAN }
| "<=" { LESS_EQUAL }
| '>' { GREATER_THAN }
| ">=" { GREATER_EQUAL }
| "==" { EQUALS }
| "!=" { NOT_EQUALS }
| '|' { BITWISE_INCLUSIVE_OR }
| '^' { BITWISE_EXCLUSIVE_OR }
| '&' { BITWISE_AND }
| "||" { LOGICAL_OR }
| "&&" { LOGICAL_AND }
| ['0'-'9']+ as lit { LITERAL(int_of_string lit) }
| "auto" { AUTO }
| "register" { REGISTER }
| "static" { STATIC }
| "extern" { EXTERN }
| "typedef" { TYPEDEF }
| "void" { VOID }
| "char" { CHAR }
| "short" { SHORT }
| "int" { INT }
| "long" { LONG }
| "float" { FLOAT }
| "double" { DOUBLE }
| "signed" { SIGNED }
| "unsigned" { UNSIGNED }
| "const" { CONST }
| "volatile" { VOLATILE }
| "struct" { STRUCT }
| "union" { UNION }
| "enum" { ENUM }
| "case" { CASE }
| "default" { DEFAULT }
| "if" { IF }
| "else" { ELSE }
| "switch" { SWITCH }
| "while" { WHILE }
| "do" { DO }
| "for" { FOR }
| "goto" { GOTO }
| "continue" { CONTINUE }
| "break" { BREAK }
| "return" { RETURN }
| '{' { LBRACKET }
| '}' { RBRACKET }
| '[' { LBRACKET_SQUARE }
| ']' { RBRACKET_SQUARE }
| '(' { LPAREN }
| ')' { RPAREN }
| ',' { COMMA }
| '=' { ASSIGN }
| "*=" { ASSIGN_AND_MULTIPLY }
| "/=" { ASSIGN_AND_DIVIDE }
| "%=" { ASSIGN_MODULO }
| "+=" { ASSIGN_AND_PLUS }
| "-=" { ASSIGN_AND_MINUS }
| "<<=" { ASSIGN_AND_LSHIFT }
| ">>=" { ASSIGN_AND RIGHT_SHIFT }
| "&=" { ASSIGN_AND_EQUALS }
| "^=" { ASSIGN_BITWISE_EXCLUSIVE_OR }
| "|=" { ASSIGN_BITWISE_INCLUSIVE_OR }
| ';' { SEMICOLON }
| '?' { QUESTION }
| ':' { COLON }
| '*' { ASTERISK }
| "..." { ELLIPSIS }
| eof { EOF }
