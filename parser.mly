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

