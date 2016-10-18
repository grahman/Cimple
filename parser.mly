%{ open Ast %}

%token ASSIGN
%token PLUS MINUS TIMES DIVIDE EOF
%token <int> LITERAL
%token SEMICOLON
%token AUTO REGISTER STATIC EXTERN TYPEDEF
%token VOID CHAR SHORT INT LONG FLOAT DOUBLE SIGNED UNSIGNED
%token CONST VOLATILE
%token STRUCT UNION
%token ENUM
%token LBRACKET RBRACKET LBRACKET_SQUARE RBRACKET_SQUARE LPAREN RPAREN COMMA COLON ELLIPSIS

%left PLUS MINUS
%left TIMES DIVIDE

%start translation_unit
%type < Ast.expr> expr

%%

translation_unit:
  external_declaration
| translation_unit external_declaration

external_declaration:
  function_definition
| declaration

function_definition:
  declarator compound_statement
| declarator declaration_list compound_statement
| declaration_specifiers declarator compound_statement
| declaration_specifiers declarator declaration_list compound_statement

declaration:
  declaration_specifiers SEMICOLON
| declaration_specifiers init_declarator_list SEMICOLON

declaration_list:
  declaration
| declaration_list declaration

declaration_specifiers:
  storage_class_specifier
| storage_class_specifier declaration_specifiers
| type_specifier
| type_specifier declaration_specifiers
| type_qualifier
| type_qualifier declaration_specifiers

storage_class_specifier:
  AUTO
| REGISTER
| STATIC
| EXTERN
| TYPEDEF

type_specifier:
  VOID
| CHAR
| SHORT
| INT
| LONG
| FLOAT
| DOUBLE
| SIGNED
| UNSIGNED
| struct_or_union_specifier
| enum_specifier
| typedef_name

type_qualifier:
  CONST
| VOLATILE

struct_or_union_specifier:
  struct_or_union LBRACKET struct_declaration_list RBRACKET
| struct_or_union identifier LBRACKET struct_declaration_list RBRACKET
| struct_or_union identifier

struct_or_union:
  STRUCT
| UNION

struct_declaration_list:
  struct_declaration
| struct_declaration_list struct_declaration

init_declarator_list:
  init_declarator
| init_declarator_list COMMA init_declarator

init_declarator:
  declarator
| declarator ASSIGN initializer_

struct_declaration:
  specifier_qualifier_list struct_declarator_list SEMICOLON

specifier_qualifier_list:
  type_specifier
| type_specifier specifier_qualifier_list
| type_qualifier
| type_qualifier specifier_qualifier_list

struct_declarator_list:
  struct_declarator
| struct_declarator_list COMMA struct_declarator

struct_declarator:
  declarator
| COLON constant_expression
| declarator COLON constant_expression

enum_specifier:
  ENUM LBRACKET enumerator_list RBRACKET
| ENUM identifier LBRACKET enumerator_list RBRACKET
| ENUM identifier

enumerator_list:
  enumerator
| enumerator_list COMMA enumerator

enumerator:
  identifier
| identifier ASSIGN constant_expression

declarator:
  direct_declarator
| pointer direct_declarator

direct_declarator:
  identifier
| LPAREN declarator RPAREN
| direct_declarator LBRACKET_SQUARE RBRACKET_SQUARE
| direct_declarator LBRACKET_SQUARE constant_expression RBRACKET_SQUARE
| direct_declarator LPAREN parameter_type_list RPAREN
| direct_declarator LPAREN RPAREN
| direct_declarator LPAREN identifier_list RPAREN

pointer:
  ASTERISK
| ASTERISK type_qualifier_list
| ASTERISK pointer
| ASTERISK type_qualifier_list pointer

type_qualifier_list:
  type_qualifier
| type_qualifier_list type_qualifier

parameter_type_list:
  parameter_list
| parameter_list COMMA ELLIPSIS

parameter_list:
  parameter_declaration
| parameter_list COMMA parameter_declaration

parameter_declaration:
  declaration_specifiers declarator
| declaration_specifiers abstract_declarator
| declaration_specifiers

identifier_list:
  identifier
| identifier_list COMMA identifier

type_name:
  specifier_qualifier_list abstract_declarator
| specifier_qualifier_list

abstract_declarator:
  pointer
| pointer direct_abstract_declarator
| direct_abstract_declarator

direct_abstract_declarator:
  LPAREN abstract_declarator RPAREN
| direct_abstract_declarator LBRACKET_SQUARE constant_expression RBRACKET_SQUARE
| direct_abstract_declarator LBRACKET_SQUARE RBRACKET_SQUARE
| LBRACKET_SQUARE constant_expression RBRACKET_SQUARE
| LBRACKET_SQUARE RBRACKET_SQUARE
| direct_abstract_declarator LPAREN parameter_type_list RPAREN
| LPAREN parameter_type_list RPAREN
| direct_abstract_declarator LPAREN RPAREN
| LPAREN RPAREN

typedef_name:
  identifier

statement:
  labeled_statement
| expression_statement
| compound_statement
| selection_statement
| iteration_statement
| jump_statement

labeled_statement:
 identifier COLON statement
| CASE constant_expression COLON statement
| DEFAULT COLON statement

expression_statement:
  expression SEMICOLON
| SEMICOLON

compound_statement:
  LBRACKET declaration_list statement_list RBRACKET
| LBRACKET declaration_list RBRACKET
| LBRACKET statement_list RBRACKET
| LBRACKET RBRACKET

statement_list:
  statement
| statement_list statement

selection_statement:
  IF LPAREN expression RPAREN statement
| IF LPAREN expression RPAREN statement ELSE statement
| SWITCH LPAREN expression RPAREN statement

iteration_statement:
  WHILE LPAREN expression RPAREN statement
| DO statement WHILE LPAREN expression RPAREN SEMICOLON
| FOR LPAREN expression SEMICOLON expression SEMICOLON expression RPAREN
statement
| FOR LPAREN expression SEMICOLON expression SEMICOLON RPAREN statement
| FOR LPAREN expression SEMICOLON SEMICOLON RPAREN statement
| FOR LPAREN expression SEMICOLON SEMICOLON expression RPAREN statement
| FOR LPAREN SEMICOLON expression SEMICOLON RPAREN statement
| FOR LPAREN SEMICOLON SEMICOLON expression RPAREN statement
| FOR LPAREN SEMICOLON expression SEMICOLON expression RPAREN statement
| FOR LPAREN SEMICOLON SEMICOLON RPAREN statement

jump_statement:
  GOTO identifier SEMICOLON
| CONTINUE SEMICOLON
| BREAK SEMICOLON
| RETURN expression
| RETURN

expression:
  assignment_expression
| expression COMMA assignment_expression

assignment_expression:
  conditional_expression
| unary_expression assignment_operator assignment_expression

assignment_operator:
  ASSIGN
| ASSIGN_AND_MULTIPLY
| ASSIGN_AND_DIVIDE
| ASSIGN_MODULO
| ASSIGN_AND_PLUS
| ASSIGN_AND_MINUS
| ASSIGN_AND_LSHIFT
| ASSIGN_AND_RSHIFT
| ASSIGN_AND_EQUALS
| ASSIGN_BITWISE_EXCLUSIVE_OR
| ASSIGN_BITWISE_INCLUSIVE_OR

conditional_expression:
  logical_OR_expression
| logical_OR_expression QUESTION expression COLON conditional_expression

constant_expression:
  conditional_expression

logical_OR_expression:
    logical_AND_expression
  | logical_OR_expression LOGICAL_OR logical_AND_expression

logical_AND_expression:
    inclusive_OR_expression
  | logical_AND_expression LOGICAL_AND inclusive_OR_expression

inclusive_OR_expression:
    exclusive_OR_expression
  | inclusive_OR_expression OR exclusive_OR_expression

exclusive_OR_expression:
    AND_expression
  | exclusive_OR_expression BITWISE_EXCLUSIVE_OR AND_expression

AND_expression:
    equality_expression
  | AND_expression AND equality_expression

equality_expression:
    relational_expression
  | equality_expression EQUALS relational_expression
  | equality_expression NOT_EQUALS relational_expression

relational_expression:
    shift_expression
  | relational_expression LESS_THAN shift_expression
  | relational_expression GREATER_THAN shift_expression
  | relational_expression LESS_EQUAL shift_expression
  | relational_expression GREATER_EQUAL shift_expression

shift_expression:
    additive_expression
  | shift_expression LSHIFT additive_expression
  | shift_expression RSHIFT additive_expression

additive_expression:
    multiplicative_expression
  | additive_expression PLUS multiplicative_expression
  | additive_expression MINUS multiplicative_expression

multiplicative_expression:
    cast_expression
  | multiplicative_expression TIMES cast_expression
  | multiplicative_expression DIVIDE cast_expression
  | multiplicative_expression MODULO cast_expression

cast_expression:
    unary_expression
  | LPAREN type_name RPAREN cast_expression

unary_expression:
    postfix_expression
  | INCREMENT unary_expression
  | DECREMENT unary_expression
  | unary_operator cast_expression
  | sizeof unary_expression
  | sizeof LPAREN type_name RPAREN

unary_operator:
    BITWISE_AND
  | TIMES
  | PLUS
  | MINUS
  | BITWISE_NOT
  | LOGICAL_NOT

postfix_expression:
    primary_expression
  | postfix_expression LBRACKET_SQUARE expression RBRACKET_SQUARE
  | postfix_expression LPAREN argument_expression_list RPAREN
  | postfix_expression DOT identifier
  | postfix_expression DEREFERENCE identifier
  | postfix_expression INCREMENT
  | postfix_expression DECREMENT

primary_expression:
    identifier
  | constant_expression
  | string
  | LPAREN expression RPAREN

argument_expression_list:
    assignment_expression
  | argument_expression_list COMMA assignment_expression
  
constant:
    integer_constant
  | character_constant
  | floating_constant
  | enumeration_constant