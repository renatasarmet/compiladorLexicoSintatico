/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
*/

grammar Lua;

    public static String grupo="<<606723, , >>";

/*PALAVRAS RESERVADAS*/

PalavraReservada:'and' | 'break' | 'do' | 'else' | 'elseif' | 'end' | 'false' |
                 'for' | 'function' | ‘if’ | 'in' | 'local' | 'nil' | 'not' | 'or' |
                 'for' | 'function' | 'if' | 'in' | 'local' | 'nil' | 'not' | 'or' |
                 'repeat' | 'return' | 'then' | 'true' | 'until' | 'while';



/*
    SIMBOLOS RESERVADOS:

    Precedência:
    Parênteses muda a precedência de uma expressão.
    Os operadores ('..') e ('^') são associativos à direita.
    Todos os demais operadores binários são associativos à esquerda.

*/

/*Operadores de acordo com a precedência*/
OpLogico1: 'or';
OpLogico2: 'and';
OpRel: '<' | '>' |  '<=' | '>=' | '~=' | '==';
OpConcat: '..'; // CONCATENAÇÃO
OpArit1: '+' | '-';
OpArit2: '*'| '/' | '%';
OpLogico3: 'not' | '#' | '-' // '-' UNÁRIO
OpLogico3: 'not' | '#' | '-' ;// '-' UNÁRIO
OpArit3: '^'; //EXPONENCIAÇÃO

OpAtrib: '='; //ATRIBUIÇÃO
OpDelim: '(' | ')' | '{' | '}' | '[' | ']'; //DELIMITADORES
OpDelim: '(' | ')' | '(' | ')*' | '(' | ')?'; //DELIMITADORES
OpOutros: ';' | ':' | ',' | '.' | '...';



/*NOMES*/

fragment LetraMinuscula : ('a'..'z');
fragment LetraMaiuscula : ('A'..'Z');
Letra: ('a'..'z') | ('A'..'Z');
fragment Digito : '0'..'9';

Nome:(Letra|'_')(Letra|'_'|Digito)*
Nome:(Letra|'_')(Letra|'_'|Digito)* ;


/*
    CADEIA DE CARACTERES:
    Apenas as versões curtas, sem sequência de escape, quebras de linha não permitidas
*/

CadeiaCaracteres: ('\'' | '"')(~('\'' | '"'))*('\'' | '"');


/*
    CONSTANTES NUMÉRICAS:
    Apenas decimais, sem sinal, com dígitos antes e depois do ponto decimal opcionais
*/

ConstanteNumerica: Digito+ '.'? Digito+ ;


// Análise sintática

block : chunk ;

chunk : (stat (';')?)* (laststat (';')?)? ;

stat :  varlist '=' explist |
		 functioncall |
		 do block end |
		 while exp do block end |
		 repeat block until exp |
		 if exp then block (elseif exp then block)* (else block)? end |
		 for Name '=' exp ',' exp (',' exp)? do block end |
		 for namelist in explist do block end |
		 function funcname funcbody |
		 local function Name funcbody |
		 local namelist ('=' explist)? ;


laststat : return (explist)? | break ;

funcname : Name ('.' Name)* (':' Name)? ;

varlist : var (',' var)* ;

var :  Name | prefixexp '(' exp ')?' | prefixexp '.' Name ;

namelist : Name (',' Name)* ;

explist : (exp ',')* exp ;

exp :  nil | false | true | Number | String | '...' | function |
     prefixexp | tableconstructor | exp binop exp | unop exp ;

prefixexp : var | functioncall | '(' exp ')' ;

functioncall :  prefixexp args | prefixexp ':' Name args ;

args :  '(' (explist)? ')' | tableconstructor | String ;

function : function funcbody ;

funcbody : '(' (parlist)? ')' block end ;

parlist : namelist (',' '...')? | '...' ;

tableconstructor : '(' (fieldlist)? ')*' ;

fieldlist : field (fieldsep field)* (fieldsep)? ;

field : '(' exp ')?' '=' exp | Name '=' exp | exp ;

fieldsep : ',' | ';' ;

binop : '+' | '-' | '*' | '/' | '^' | '%' | '..' |
     '<' | '<=' | '>' | '>=' | '==' | '~=' |
     and | or ;

unop : '-' | not | '#' ;
